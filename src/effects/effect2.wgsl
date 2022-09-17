const background : vec3<f32> = vec3<f32>(0, 0, 0);
const fogDensity : f32 = 0.005;

const edgeColor : vec3<f32> = vec3<f32>(0, 0, 0);
const edgeIntensity : f32 = 0.5;
const depthScale : f32 = 0.5;
const depthBias : f32 = 1;
const normalBias : f32 = 10;
const normalScale : f32 = 0.5;

fn getEffect(pixel : vec2<i32>) -> vec3<f32> {
  let data : vec4<f32> = textureLoad(dataTexture, pixel, 0);
  let depth : f32 = data.w;
  if (depth >= camera.far) {
    return background;
  }
  let color : vec4<f32> = textureLoad(colorTexture, pixel, 0);
  let position : vec3<f32> = textureLoad(positionTexture, pixel, 0).xyz;
  var out : vec3<f32> = color.xyz * getLight(data.xyz, position);
  out = mix(out, edgeColor, getEdge(pixel, data) * edgeIntensity);
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

fn getEdge(pixel : vec2<i32>, data : vec4<f32>) -> f32 {
  const offset : vec3<i32> = vec3<i32>(1, 1, 0);
  let dataLeft : vec4<f32> = textureLoad(dataTexture, pixel - offset.xz, 0);
  let dataRight : vec4<f32> = textureLoad(dataTexture, pixel + offset.xz, 0);
  let dataUp : vec4<f32> = textureLoad(dataTexture, pixel + offset.zy, 0);
  let dataDown : vec4<f32> = textureLoad(dataTexture, pixel - offset.zy, 0);
  let edge : vec4<f32> = (
    abs(dataLeft - data)
    + abs(dataRight - data) 
    + abs(dataUp - data) 
    + abs(dataDown - data)
  );
  return clamp(max(pow((edge.x + edge.y + edge.z) * normalScale, normalBias), pow(edge.w * depthScale, depthBias)), 0, 1);
}
