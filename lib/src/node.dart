part of csg;

/** Holds a node in a BSP tree. A BSP tree is built from a collection of polygons
 * by picking a polygon to split along. That polygon (and all other coplanar
 * polygons) are added directly to that node and the other polygons are added to
 * the front and/or back subtrees. This is not a leafy BSP tree since there is
 * no distinction between internal and leaf nodes. */
class Node {
  Plane plane;
  Node front, back;
  List<Polygon> polygons;

  Node([this.polygons])
      : plane = null,
        front = null,
        back = null {
    if (polygons != null) {
      build(polygons);
    } else {
      polygons = [];
    }
  }

  Node clone() {
    var node = new Node();
    if (plane != null) { node.plane = plane.clone(); }
    if (front != null) { node.front = front.clone(); }
    if (back != null) { node.back = back.clone(); }
    node.polygons = polygons.map((p) => p.clone());
    return node;
  }

  /** Convert solid space to empty space and empty space to solid space. */
  invert() {
    polygons.forEach((polygon) => polygon.flip());
    plane.flip();
    if (front != null) front.invert();
    if (back != null) back.invert();
    var temp = front;
    front = back;
    back = temp;
  }

  /** Recursively remove all polygons in `polygons` that are inside this BSP tree. */
  List clipPolygons(polys) {
    if (plane == null) return new List.from(polys);
    List front = [], back = [];
    polys.forEach((polygon) => plane.splitPolygon(polygon, front, back, front, back));
    if (this.front != null) {
      front = this.front.clipPolygons(front);
    }
    if (this.back != null) {
      back = this.back.clipPolygons(back);
    } else {
      back = [];
    }
    front.addAll(back);
    return front;
  }

  /** Remove all polygons in this BSP tree that are inside the other BSP tree `bsp`.*/
  clipTo(bsp) {
    polygons = bsp.clipPolygons(polygons);
    if (front != null) { front.clipTo(bsp); }
    if (back != null) { back.clipTo(bsp); }
  }

  /** Return a list of all polygons in this BSP tree. */
  List<Polygon> get allPolygons {
    var polygons = new List.from(this.polygons);
    if (front != null) { polygons.addAll(front.allPolygons); }
    if (back != null) { polygons.addAll(back.allPolygons); }
    return polygons;
  }

  /** Build a BSP tree out of `polygons`. When called on an existing tree, the
   * new polygons are filtered down to the bottom of the tree and become new
   * nodes there. Each set of polygons is partitioned using the first polygon
   * (no heuristic is used to pick a good split). */
  build(List<Polygon> polygons) {
    if (polygons.isEmpty) { return; }
    if (this.plane == null) {
      this.plane = polygons[0].plane.clone();
    }
    var front = [],
        back = [];

    var pl = polygons.length;
    for (var i = 0; i < pl; i++) {
      this.plane.splitPolygon(polygons[i], this.polygons, this.polygons, front, back);
    }

    if (!front.isEmpty) {
      if (this.front == null) this.front = new Node();
      this.front.build(front);
    }
    if (!back.isEmpty) {
      if (this.back == null) this.back = new Node();
      this.back.build(back);
    }
  }
}