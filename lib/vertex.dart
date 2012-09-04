// # class Vertex

// Represents a vertex of a polygon. Use your own vertex class instead of this
// one to provide additional features like texture coordinates and vertex
// colors. Custom vertex classes need to provide a `pos` property and `clone()`,
// `flip()`, and `interpolate()` methods that behave analogous to the ones
// defined by `CSG.Vertex`. This class provides `normal` so convenience
// functions like `CSG.sphere()` can return a smooth vertex normal, but `normal`
// is not used anywhere else.
class Vertex {

  Vector pos;
  Vector normal;
  
  Vertex(this.pos, [this.normal]);

  clone() => new Vertex(pos.clone(), (normal != null) ? normal.clone() : null);

  // Invert all orientation-specific data (e.g. vertex normal). Called when the
  // orientation of a polygon is flipped.
  flip() { normal = (normal != null) ? normal.negated() : normal; }

  // Create a new vertex between this vertex and `other` by linearly
  // interpolating all properties using a parameter of `t`. Subclasses should
  // override this to interpolate additional properties.
  interpolate(Vertex other, num t) => new Vertex( pos.lerp(other.pos, t),
                                                  (normal != null) ? normal.lerp(other.normal, t) : null);
  
}
