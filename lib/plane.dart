class Plane {
  
  Vector normal;
  num w;
  
  Plane(this.normal, this.w);

  factory Plane.fromPoints(Vector a, Vector b, Vector c) {
    Vector n = b.clone().minus(a).cross(c.clone().minus(a)).unit();
    return new Plane(n, n.dot(a));
  }

  Plane clone() => new Plane(normal.clone(), w);

  toString() => "${normal} * ${w}";
  
   flip() {
     normal = normal.negated();
     w = -w;
   }

   static const int COPLANAR = 0;
   static const int FRONT = 1;
   static const int BACK = 2;
   static const int SPANNING = 3;
   
   _classifyVertex( vertex ) {  
     var side_value = this.normal.dot( vertex ) - this.w;
     if ( side_value < -EPSILON ) {
       return BACK;
     } else if ( side_value > EPSILON ) {
       return FRONT;
     } else {
       return COPLANAR;
     }
   }
   
   // Split `polygon` by this plane if needed, then put the polygon or polygon
   // fragments in the appropriate lists. Coplanar polygons go into either
   // `coplanarFront` or `coplanarBack` depending on their orientation with
   // respect to this plane. Polygons in front or in back of this plane go into
   // either `front` or `back`.
   splitPolygon(Polygon polygon, coplanarFront, coplanarBack, front, back) {

     // Classify each point as well as the entire polygon into one of the above
     // four classes.
     
     var num_positive = 0,
         num_negative = 0;
     
     var vertice_count = polygon.vertices.length; //
     for ( var i = 0; i < vertice_count; i++ ) {
       var v = polygon.vertices[i];
       var classification = _classifyVertex(v.pos);
       if ( classification == FRONT ) {
         num_positive++;
       } else if ( classification == BACK ) {
         num_negative++;
       }
     }

     var polygonType = 0;
     
     if ( num_positive > 0 && num_negative == 0 ) {
       polygonType = FRONT;
     } else if ( num_positive == 0 && num_negative > 0 ) {
       polygonType = BACK;
     } else if ( num_positive == 0 && num_negative == 0 ) {
       polygonType = COPLANAR;
     } else {
       polygonType = SPANNING;
     }
     
     // Put the polygon in the correct list, splitting it when necessary.
     switch (polygonType) {
       case COPLANAR:
         (this.normal.dot(polygon.plane.normal) > 0 ? coplanarFront : coplanarBack).add(polygon);
         break;
       case FRONT:
         front.add(polygon);
         break;
       case BACK:
         back.add(polygon);
         break;
       case SPANNING:
         var f = [], b = [];
         for (var i = 0; i < polygon.vertices.length; i++) {
           var j = (i + 1) % polygon.vertices.length;
          
           var vi = polygon.vertices[i], 
               vj = polygon.vertices[j];
           
           int ti = _classifyVertex(vi.pos), 
               tj = _classifyVertex(vj.pos);
           
           if (ti != BACK) f.add(vi);
           if (ti != FRONT) b.add(ti != BACK ? vi.clone() : vi);
           
           if ((ti | tj) == SPANNING) {
             var t = (this.w - this.normal.dot(vi.pos)) / this.normal.dot(vj.pos.minus(vi.pos));
             var v = vi.interpolate(vj, t);
             f.add(v);
             b.add(v.clone());
           }
         }
         if (f.length >= 3) front.add(new Polygon(f)); //, polygon.shared));
         if (b.length >= 3) back.add(new Polygon(b)); //, polygon.shared));
         break;
     }  
  }
}
