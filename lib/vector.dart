class Vector {
  num x, y, z;
  
  Vector(this.x, this.y, this.z);
  
  factory Vector.fromCoords(List coords) => new Vector(coords[0], coords[1], coords[2]);

  toString() => "[$x, $y, $z]";
  
  Vector clone() => new Vector(x, y, z);

  Vector negated() => new Vector(-x, -y, -z);

  Vector plus(Vector a) => new Vector(x + a.x, y + a.y, z + a.z);

  Vector minus(Vector a) => new Vector(x - a.x, y - a.y, z - a.z);

  Vector times(num a) => new Vector(x * a, y * a, z * a);

  Vector dividedBy(num a) => new Vector(x / a, y / a, z / a);

  num dot(Vector a) => x * a.x + y * a.y + z * a.z;

  Vector lerp(Vector a, num t) => plus(a.minus(this).times(t));

  get length => Math.sqrt(this.dot(this));

  Vector unit() => dividedBy(length);

  Vector cross(Vector a) => new Vector(  y * a.z - z * a.y,
                                  z * a.x - x * a.z,
                                  x * a.y - y * a.x);
  
}
