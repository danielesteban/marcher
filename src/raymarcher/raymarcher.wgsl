struct FragmentOutput {
  @location(0) color : vec4<f32>,
  @location(1) data : vec4<f32>,
  @location(2) position : vec4<f32>,
}

struct VertexOutput {
  @builtin(position) position : vec4<f32>,
  @location(0) ray : vec3<f32>,
}

@group(0) @binding(0) var<uniform> camera : Camera;
@group(0) @binding(1) var<uniform> time : f32;

const epsilon : f32 = 0.01;

fn getNormal(pos : vec3<f32>, distance : f32) -> vec3<f32> {
  const o : vec2<f32> = vec2<f32>(epsilon, 0);
  return normalize(
    distance - vec3<f32>(
      getScene(pos - o.xyy).distance,
      getScene(pos - o.yxy).distance,
      getScene(pos - o.yyx).distance
    )
  );
}

@vertex
fn vertex(@builtin(vertex_index) index : u32) -> VertexOutput {
  // Hack to prevent BindGroup errors
  // when user code doesn't use all of the uniforms
  let t : f32 = time;

  const quad = array<vec2<f32>, 6>(
    vec2<f32>(-1, -1), vec2<f32>(1, -1), vec2<f32>(-1, 1),
    vec2<f32>(-1, 1), vec2<f32>(1, -1), vec2<f32>(1, 1)
  );
  var out : VertexOutput;
  out.position = vec4<f32>(quad[index], 0, 1);
  let r : vec4<f32> = camera.inverseMatrix * vec4<f32>(quad[index], 0.5, 1);
  out.ray = normalize((r.xyz / r.w) - camera.position);
  return out;
}

@fragment
fn conetracing(@location(0) ray : vec3<f32>) -> FragmentOutput {
  var out : FragmentOutput;
  var coverage : f32 = 1;
  var depth : f32 = camera.near;
  for (var i : u32 = 0; i < maxIterations && depth < camera.far; i++) {
    let pos : vec3<f32> = camera.position + ray * depth;
    let step : SDF = getScene(pos);
    let cone : f32 = camera.cone * depth;
    if (step.distance < cone) {
      let alpha : f32 = smoothstep(cone, -cone, step.distance);
      let normal : vec3<f32> = getNormal(pos, step.distance);
      out.color += vec4<f32>(step.color * alpha * coverage, 0);
      out.data += vec4<f32>(normal, depth) * alpha * coverage;
      out.position += vec4<f32>(pos * alpha * coverage, 0);
      coverage *= 1 - alpha;
      if (coverage <= epsilon * 0.1) {
        break;
      }
    }
    depth += max(step.distance, epsilon);
  }
  if (coverage < 1) {
    out.color = vec4<f32>(out.color.xyz, 1 - coverage);
    out.data = vec4<f32>(normalize(out.data.xyz), out.data.w);
    return out;
  }
  discard;
}

@fragment
fn raymarching(@location(0) ray : vec3<f32>) -> FragmentOutput {
  var out : FragmentOutput;
  var depth : f32 = camera.near;
  for (var i : u32 = 0; i < maxIterations && depth < camera.far; i++) {
    let pos : vec3<f32> = camera.position + ray * depth;
    let step : SDF = getScene(pos);
    if (step.distance < epsilon) {
      let normal : vec3<f32> = getNormal(pos, step.distance);
      out.color = vec4<f32>(step.color, 1);
      out.data = vec4<f32>(normal, depth);
      out.position = vec4<f32>(pos, 1);
      return out;
    }
    depth += max(step.distance, epsilon);
  }
  discard;
}
