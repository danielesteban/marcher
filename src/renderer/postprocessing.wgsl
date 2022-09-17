@group(0) @binding(0) var<uniform> camera : Camera;
@group(0) @binding(1) var<uniform> time : f32;
@group(1) @binding(0) var colorTexture : texture_2d<f32>;
@group(1) @binding(1) var dataTexture : texture_2d<f32>;
@group(1) @binding(2) var positionTexture : texture_2d<f32>;

fn linearTosRGB(linear : vec3<f32>) -> vec3<f32> {
  if (all(linear <= vec3<f32>(0.0031308))) {
    return linear * 12.92;
  }
  return (pow(abs(linear), vec3<f32>(1.0/2.4)) * 1.055) - vec3<f32>(0.055);
}

@vertex
fn vertex(@builtin(vertex_index) index : u32) -> @builtin(position) vec4<f32> {
  // Hack to prevent BindGroup errors
  // when user code doesn't use all of the uniforms
  let t : f32 = time;

  const quad = array<vec2<f32>, 6>(
    vec2<f32>(-1, -1), vec2<f32>(1, -1), vec2<f32>(-1, 1),
    vec2<f32>(-1, 1), vec2<f32>(1, -1), vec2<f32>(1, 1)
  );
  return vec4<f32>(quad[index], 0, 1);
}

@fragment
fn fragment(@builtin(position) uv : vec4<f32>) -> @location(0) vec4<f32> {
  return vec4<f32>(linearTosRGB(getEffect(vec2<i32>(floor(uv.xy)))), 1);
}
