fn getScene(pos : vec3<f32>) -> SDF {
  var scene : SDF = SDF(
    vec3<f32>(.8, .1, .05),
    sdBox(rotateY(PI * 0.25) * rotateX(PI * 0.25) * (pos - vec3<f32>(-7, 0, -10)), vec3<f32>(1, 1, 1))
  );
  scene = opUnion(scene, SDF(
    vec3<f32>(.8, .2, .05),
    sdCapsule(pos - vec3<f32>(-3.5, 0, -10), vec2<f32>(0.5, 2))
  ));
  scene = opUnion(scene, SDF(
    vec3<f32>(.2, .2, .8),
    sdSphere(pos - vec3<f32>(0, 0, -10), 1)
  ));
  scene = opUnion(scene, SDF(
    vec3<f32>(.8, .2, .05),
    sdEllipsoid(pos - vec3<f32>(3.5, 0, -10), vec3<f32>(1, 2, 1))
  ));
  scene = opUnion(scene, SDF(
    vec3<f32>(.8, .1, .05),
    sdTorus(rotateX(PI * 0.5) * (pos - vec3<f32>(7, 0, -10)), vec2<f32>(1, 0.25))
  ));
  scene = opSmoothUnion(scene, SDF(
    vec3<f32>(0.8, 0.8, 0.1),
    sdPlane(pos, vec3<f32>(0, 1, 0), 1.5)
  ), 1);
  return scene;
}
