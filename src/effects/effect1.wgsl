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
  return (
    0.1
    + getDirectLight(Light(position + vec3<f32>(0, 1, 0), vec3<f32>(1), vec3<f32>(0.3)), normal, position, 32) * 0.5
    + getDirectLight(Light(position + vec3<f32>(1, 1, 1), vec3<f32>(1), vec3<f32>(0.3)), normal, position, 32) * 0.25
    + getDirectLight(Light(position + vec3<f32>(-1, 1, -1), vec3<f32>(1), vec3<f32>(0.3)), normal, position, 32) * 0.25
  );
}
