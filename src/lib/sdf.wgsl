struct SDF {
  color : vec3<f32>,
  distance : f32,
}

fn opUnion(a : SDF, b : SDF) -> SDF {
  if (a.distance < b.distance) {
    return a;
  }
  return b;
}

fn opSubstraction(a : SDF, b : SDF) -> SDF {
  if (a.distance > -b.distance) {
    return a;
  }
  return SDF(b.color, -b.distance);
}

fn opSmoothUnion(a : SDF, b : SDF, k : f32) -> SDF {
  let h : f32 = clamp(0.5 + 0.5 * (b.distance - a.distance) / k, 0, 1);
  return SDF(
    mix(b.color, a.color, h),
    mix(b.distance, a.distance, h) - k*h*(1-h)
  );
}

fn opSmoothSubstraction(a : SDF, b : SDF, k : f32) -> SDF {
  let h : f32 = clamp(0.5 - 0.5 * (a.distance + b.distance) / k, 0, 1);
  return SDF(
    mix(a.color, b.color, h),
    mix(a.distance, -b.distance, h) + k*h*(1-h)
  );
}

fn sdBox(p : vec3<f32>, r : vec3<f32>) -> f32 {
  let q : vec3<f32> = abs(p) - r;
  return length(max(q, vec3<f32>(0))) + min(max(q.x, max(q.y, q.z)), 0);
}

fn sdCapsule(p : vec3<f32>, r : vec2<f32>) -> f32 {
  let q : vec3<f32> = vec3<f32>(p.x, p.y - clamp(p.y, -r.y + r.x, r.y - r.x), p.z);
  return length(q) - r.x;
}

fn sdEllipsoid(p : vec3<f32>, r : vec3<f32>) -> f32 {
  let k0 : f32 = length(p / r);
  let k1 : f32 = length(p / (r * r));
  return k0 * (k0 - 1.0) / k1;
}

fn sdHexPrism(pos : vec3<f32>, r : vec2<f32>) -> f32 {
  const k : vec3<f32> = vec3<f32>(-0.8660254, 0.5, 0.57735);
  var p : vec3<f32> = abs(pos);
  p = vec3<f32>(
    p.xy - 2.0*min(dot(k.xy, p.xy), 0)*k.xy,
    p.z
  );
  let d : vec2<f32> = vec2<f32>(
    length(p.xy-vec2(clamp(p.x,-k.z*r.x,k.z*r.x), r.x))*sign(p.y-r.x),
    p.z-r.y
  );
  return min(max(d.x,d.y),0) + length(max(d,vec2<f32>(0)));
}

fn sdOctahedron(pos : vec3<f32>, r : f32) -> f32 {
  let p : vec3<f32> = abs(pos);
  let m : f32 = p.x+p.y+p.z-r;
  var q : vec3<f32>;
  if (3.0*p.x < m) { q = p.xyz; }
  else if (3.0*p.y < m) { q = p.yzx; }
  else if (3.0*p.z < m) { q = p.zxy; }
  else { return m*0.57735027; }
  let k : f32 = clamp(0.5*(q.z-q.y+r),0.0,r); 
  return length(vec3(q.x,q.y-r+k,q.z-k)); 
}

fn sdPlane(p : vec3<f32>, n : vec3<f32>, r : f32) -> f32 {
  return dot(p,n) + r;
}

fn sdSphere(p : vec3<f32>, r : f32) -> f32 {
  return length(p) - r;
}

fn sdTorus(p : vec3<f32>, r : vec2<f32>) -> f32 {
  let q : vec2<f32> = vec2<f32>(length(p.xz) - r.x, p.y);
  return length(q) - r.y;
}

fn sdTriPrism(p : vec3<f32>, r : vec2<f32>) -> f32 {
  let q : vec3<f32> = abs(p);
  return max(q.z-r.y,max(q.x*0.866025+p.y*0.5,-p.y)-r.x*0.5);
}
