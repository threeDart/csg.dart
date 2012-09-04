/** Holds a binary space partition tree representing a 3D solid. Two solids can
 * be combined using the `union()`, `subtract()`, and `intersect()` methods. */
class CSG {
  List polygons;


  /** Construct a CSG solid from a list of `CSG.Polygon` instances.*/
  CSG.fromPolygons(this.polygons);
  
  clone() => new CSG.fromPolygons(polygons.map((p) => p.clone()));

  /** Return a new CSG solid representing space in either this solid or in the
  // solid `csg`. Neither this solid nor the solid `csg` are modified.
  // 
  //     A.union(B)
  // 
  //     +-------+            +-------+
  //     |       |            |       |
  //     |   A   |            |       |
  //     |    +--+----+   =   |       +----+
  //     +----+--+    |       +----+       |
  //          |   B   |            |       |
  //          |       |            |       |
  //          +-------+            +-------+
  / */
  union(csg) {
    var a = new Node(this.clone().polygons);
    var b = new Node(csg.clone().polygons);
    a.clipTo(b);
    b.clipTo(a);
    b.invert();
    b.clipTo(a);
    b.invert();
    a.build(b.allPolygons);
    return new CSG.fromPolygons(a.allPolygons);
  }

  /** Return a new CSG solid representing space in this solid but not in the
  // solid `csg`. Neither this solid nor the solid `csg` are modified.
  // 
  //     A.subtract(B)
  // 
  //     +-------+            +-------+
  //     |       |            |       |
  //     |   A   |            |       |
  //     |    +--+----+   =   |    +--+
  //     +----+--+    |       +----+
  //          |   B   |
  //          |       |
  //          +-------+
  / */ 
  subtract(csg) {
    var a = new Node(this.clone().polygons);
    var b = new Node(csg.clone().polygons);
    a.invert();
    a.clipTo(b);
    b.clipTo(a);
    b.invert();
    b.clipTo(a);
    b.invert();
    a.build(b.allPolygons);
    a.invert();
    return new CSG.fromPolygons(a.allPolygons);
  }

  /** Return a new CSG solid representing space both this solid and in the
  // solid `csg`. Neither this solid nor the solid `csg` are modified.
  // 
  //     A.intersect(B)
  // 
  //     +-------+
  //     |       |
  //     |   A   |
  //     |    +--+----+   =   +--+
  //     +----+--+    |       +--+
  //          |   B   |
  //          |       |
  //          +-------+
  / */ 
  intersect(csg) {
    var a = new Node(this.clone().polygons);
    var b = new Node(csg.clone().polygons);
    a.invert();
    b.clipTo(a);
    b.invert();
    a.clipTo(b);
    b.clipTo(a);
    a.build(b.allPolygons);
    a.invert();
    return new CSG.fromPolygons(a.allPolygons);
  }

  /** Return a new CSG solid with solid and empty space switched. This solid is
   * not modified. */
  inverse() {
    var csg = this.clone();
    csg.polygons.map((p) => p.flip());
    return csg;
  }
}
