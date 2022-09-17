fn getScene(pos : vec3<f32>) -> SDF {
  let q = pos - vec3<f32>(0, 0, -64);
  let n = abs(FBM(q * (0.06 + sin(time * 0.5) * 0.01) - 0.2));
  return SDF(
    hsl2Rgb(vec3<f32>(n, 0.7, 0.5)),
    sdSphere(q, 32 - n * 8)
  );
}

fn FBM(p : vec3<f32>) -> f32 {
  var value : f32;
  var amplitude : f32 = 0.5;
  var q : vec3<f32> = p;
  for (var i : i32 = 0; i < 3; i++) {
    value += SimplexNoise(q) * amplitude;
    q *= 2;
    amplitude *= 0.5;
  }
  return value;
}
