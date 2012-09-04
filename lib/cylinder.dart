// Construct a solid cylinder. Optional parameters are `start`, `end`,
// `radius`, and `slices`, which default to `[0, -1, 0]`, `[0, 1, 0]`, `1`, and
// `16`. The `slices` parameter controls the tessellation.
// 
// Example usage:
// 
//     var cylinder = CSG.cylinder({
//       start: [0, -1, 0],
//       end: [0, 1, 0],
//       radius: 1,
//       slices: 16
//     });
CSG cylinder([List start, List end, radius = 1, slices = 16]) {
  var s = new Vector.fromCoords(start == null ? [0, -1, 0] : start);
  var e = new Vector.fromCoords(end == null ? [0, 1, 0] : end);
  var ray = e.minus(s);
  var r = radius;
  var axisZ = ray.unit(); 
  var isY = axisZ.y.abs() > 0.5;
  
  var axisX = new Vector( isY? 1 : 0, isY? 0 : 1, 0).cross(axisZ).unit();
  var axisY = axisX.cross(axisZ).unit();
  var start = new Vertex(s, axisZ.negated());
  var end = new Vertex(e, axisZ.unit());
  var polygons = [];
  
  point(stack, slice, normalBlend) {
    var angle = slice * Math.PI * 2;
    var out = axisX.times(Math.cos(angle)).plus(axisY.times(Math.sin(angle)));
    var pos = s.plus(ray.times(stack)).plus(out.times(r));
    var normal = out.times(1 - normalBlend.abs()).plus(axisZ.times(normalBlend));
    return new Vertex(pos, normal);
  }
  for (var i = 0; i < slices; i++) {
    var t0 = i / slices, t1 = (i + 1) / slices;
    polygons.add(new Polygon([start, point(0, t0, -1), point(0, t1, -1)]));
    polygons.add(new Polygon([point(0, t1, 0), point(0, t0, 0), point(1, t0, 0), point(1, t1, 0)]));
    polygons.add(new Polygon([end, point(1, t1, 1), point(1, t0, 1)]));
  }
  return new CSG.fromPolygons(polygons);
}