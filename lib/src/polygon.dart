// # class Polygon

part of csg;

// Represents a convex polygon. The vertices used to initialize a polygon must
// be coplanar and form a convex loop. They do not have to be `CSG.Vertex`
// instances but they must behave similarly (duck typing can be used for
// customization).
//
// Each convex polygon has a `shared` property, which is shared between all
// polygons that are clones of each other or were split from the same polygon.
// This can be used to define per-polygon properties (such as surface color).
class Polygon {

  List vertices, shared;
  Plane plane;

  Polygon(this.vertices, [this.shared]) {
    this.plane = new Plane.fromPoints(vertices[0].pos, vertices[1].pos, vertices[2].pos);
  }

  clone() =>  new Polygon(vertices.map((v) => v.clone()).toList(), shared);

  flip() {
    var flipped = [];
    var i = vertices.length;
    while(--i > 0) {
      flipped.add(vertices[i].flip());
    }

    plane.flip();
  }

  Vector get normal => plane.normal;
}
