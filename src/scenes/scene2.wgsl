fn getScene(pos : vec3<f32>) -> SDF {
  let q : vec3<f32> = pos - vec3<f32>(0, 0, -8);
  let d : f32 = sin(q.x * 10) * sin(q.y * 10) * sin(q.z * 10) * 0.1;

  let a : SDF = SDF(
    vec3<f32>(1, 1, 1) - vec3<f32>(d * 10, d * 5, d * 5),
    sdSphere(q, 4) + d
  );

  let b : SDF = SDF(
    clamp(vec3<f32>(0.5, 0.5, 0.5) + vec3<f32>(d * 10, d * 5, d * 5), vec3<f32>(0), vec3<f32>(1)),
    sdSphere(q - vec3<f32>(0, 0, 4), 2) + d
  );

  return opSmoothSubstraction(a, b, 0.15);
}
