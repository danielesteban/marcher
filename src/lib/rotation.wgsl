const PI : f32 = 3.141592653589793;

fn rotateX(radians : f32) -> mat3x3<f32> {
  var c : f32 = cos(radians);
  var s : f32 = sin(radians);
  return mat3x3<f32>(
    1, 0, 0,
    0, c, s,
    0, -s, c,
  );
}

fn rotateY(radians : f32) -> mat3x3<f32> {
  var c : f32 = cos(radians);
  var s : f32 = sin(radians);
  return mat3x3<f32>(
    c, 0, -s,
    0, 1, 0,
    s, 0, c,
  );
}

fn rotateZ(radians : f32) -> mat3x3<f32> {
  var c : f32 = cos(radians);
  var s : f32 = sin(radians);
  return mat3x3<f32>(
    c, s, 0,
    -s, c, 0,
    0, 0, 1,
  );
}

fn spherical(phi : f32, theta : f32, radius : f32) -> vec3<f32> {
  let sinPhiRadius = sin(phi) * radius;
  return vec3<f32>(
    sinPhiRadius * sin(theta),
    cos(phi) * radius,
    sinPhiRadius * cos(theta)
  );
}
