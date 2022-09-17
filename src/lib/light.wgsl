struct Light {
  position : vec3<f32>,
  diffuse : vec3<f32>,
  specular : vec3<f32>,
}

fn getAttenuation(dist : f32, constant : f32, linear : f32, quadratic : f32) -> f32 {
  return 1.0 / (constant + linear * dist + quadratic * (dist * dist));
}

fn getDirectLight(light : Light, normal : vec3<f32>, position : vec3<f32>, shininess : f32) -> vec3<f32> {
  let lightDir = normalize(light.position - position);
  let viewDir : vec3<f32> = normalize(camera.position - position);
  let halfwayDir : vec3<f32> = normalize(lightDir + viewDir);

  let diffuse : vec3<f32> = max(dot(lightDir, normal), 0) * light.diffuse;
  let specular : vec3<f32> = pow(max(dot(normal, halfwayDir), 0), shininess) * light.specular;

  return diffuse + specular;
}
