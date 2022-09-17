const background : vec3<f32> = vec3<f32>(0, 0, 0);

fn getEffect(pixel : vec2<i32>) -> vec3<f32> {
  let data : vec4<f32> = textureLoad(dataTexture, pixel, 0);
  let depth : f32 = data.w;
  if (depth >= camera.far) {
    return background;
  }
  let color : vec4<f32> = textureLoad(colorTexture, pixel, 0);
  let position : vec3<f32> = textureLoad(positionTexture, pixel, 0).xyz;
  var out : vec3<f32> = color.xyz * getLight(data.xyz, position);
  out = mix(out, background, 1 - color.w);
  return out;
}

fn getLight(normal : vec3<f32>, position : vec3<f32>) -> vec3<f32> {
  const target : vec3<f32> = vec3<f32>(0, 0, -8);
  let lights : array<Light, 2> = array<Light, 2>(
    Light(
      target + spherical(PI * 0.25, time, 8),
      vec3<f32>(0.8, 0.4, 0),
      vec3<f32>(0.3)
    ),
    Light(
      target + spherical(PI * 0.25, time - PI, 8),
      vec3<f32>(0, 0.2, 0.8),
      vec3<f32>(0.3)
    ),
  );
  var light : vec3<f32> = vec3<f32>(0.01);
  for (var i : u32 = 0; i < 2; i++) {
    light += (
      getDirectLight(lights[i], normal, position, 32)
      * getAttenuation(distance(lights[i].position, position), 1, 0.09, 0.032)
    );
  }
  return light;
}
