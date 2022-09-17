const background : vec3<f32> = vec3<f32>(0, 0, 0);
const fogDensity : f32 = 0.005;

fn getEffect(pixel : vec2<i32>) -> vec3<f32> {
  let data : vec4<f32> = textureLoad(dataTexture, pixel, 0);
  let depth : f32 = data.w;
  if (depth >= camera.far) {
    return background;
  }
  let color : vec4<f32> = textureLoad(colorTexture, pixel, 0);
  let position : vec3<f32> = textureLoad(positionTexture, pixel, 0).xyz;
  var out : vec3<f32> = color.xyz * getLight(data.xyz, position);
  out = mix(out, background, 1 - exp(-fogDensity * fogDensity * depth * depth) * color.w);
  return out;
}

fn getLight(normal : vec3<f32>, position : vec3<f32>) -> vec3<f32> {
  let light : Light = Light(
    camera.position,
    vec3<f32>(1, 1, 1),
    vec3<f32>(0.3)
  );
  let theta = dot(camera.direction, -normalize(light.position - position));
  return (
    (
      getDirectLight(light, normal, position, 128)
      * getAttenuation(distance(light.position, position), 1, 0.007, 0.0002)
      * clamp((theta - PI * 0.2) / (PI * 0.5), 0, 1)
    )
  );
}
