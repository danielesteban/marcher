fn getScene(pos : vec3<f32>) -> SDF {
  const r : vec3<f32> = vec3<f32>(8, 8, 8);
  let q = abs(pos % r) - r * 0.5;

  let id : vec3<f32> = floor(pos / r);
  let n = SimplexNoise(id);
  let s = 1 + sin(id.x * id.y * id.z);
  let di = 2 + (abs(id.x + id.y + id.z) % 8);
  let d = sin(pos.x * di) * sin(pos.y * di) * sin(pos.z * di) * 0.1;

  let a = SDF(
    getColor(u32(abs(n + 0.5) * 0xFFFFFF)),
    sdSphere(q + sin(id + time * 0.5) * (s * 0.5), s) + d
  );
  let b = SDF(
    getColor(u32(abs(n - 0.5) * 0xFFFFFF)),
    sdSphere(q - sin(id + time * sin(id.x + id.z) * 0.5) * (s * 0.5), s) - d
  );
  return opSmoothUnion(a, b, 1);
}

fn getColor(c : u32) -> vec3<f32> {
  return vec3<f32>(
    f32((c >> 16) & 0xFF) / 0xFF,
    f32((c >> 8) & 0xFF) / 0xFF,
    f32(c & 0xFF) / 0xFF,
  );
}
