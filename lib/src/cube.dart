part of csg;

/** Construct an axis-aligned solid cuboid. Optional parameters are `center` and
// `radius`, which default to `[0, 0, 0]` and `[1, 1, 1]`. The radius can be
// specified using a single number or a list of three numbers, one for each axis.
//
// Example code:
//
//     var cube = CSG.cube({
//       center: [0, 0, 0],
//       radius: 1
 *     }); */
CSG cube([List center, var radius]) {
    var coords = center == null ? [0, 0, 0] : center;
    var c = new Vector.fromCoords(coords);

    List r =  (radius == null) ? [1, 1, 1] : ( radius is List ? radius : [radius, radius, radius] );

    return new CSG.fromPolygons([
      [[0, 4, 6, 2], [-1, 0, 0]],
      [[1, 3, 7, 5], [1, 0, 0]],
      [[0, 1, 5, 4], [0, -1, 0]],
      [[2, 6, 7, 3], [0, 1, 0]],
      [[0, 2, 3, 1], [0, 0, -1]],
      [[4, 5, 7, 6], [0, 0, 1]]
    ].map((info) {
      return new Polygon(info[0].map((i) {
        var dx = ( (i & 1) != 0)? 1 : 0,
            dy = ( (i & 2) != 0)? 1 : 0,
            dz = ( (i & 4) != 0)? 1 : 0;

        var pos = new Vector(
          c.x + r[0] * (2 * dx - 1),
          c.y + r[1] * (2 * dy - 1),
          c.z + r[2] * (2 * dz - 1)
        );
        return new Vertex(pos, new Vector.fromCoords(info[1]));
      }));
    }));
}