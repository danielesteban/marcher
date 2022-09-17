fn hsl2Rgb(hsl : vec3<f32>) -> vec3<f32> {
  let h : f32 = clamp(hsl.x, 0, 1);
  let s : f32 = clamp(hsl.y, 0, 1);
  let l : f32 = clamp(hsl.z, 0, 1);
  if (s == 0) {
    return vec3<f32>(l, l, l);
  }
  var q : f32;
  if (l < 0.5) {
    q = l * (1 + s);
  } else {
    q = l + s - l * s;
  }
  let p = 2 * l - q;
  return vec3<f32>(
    hue2Rgb(p, q, h + 1 / 3.0),
    hue2Rgb(p, q, h),
    hue2Rgb(p, q, h - 1 / 3.0)
  );
}

fn hue2Rgb(p : f32, q : f32, tt : f32) -> f32 {
  var t : f32 = tt;
  if (t < 0) { t += 1; }
  if (t > 1) { t -= 1; }
  if (t < 1 / 6.0) { return p + (q - p) * 6 * t; }
  if (t < 1 / 2.0) { return q; }
  if (t < 2 / 3.0) { return p + (q - p) * (2 / 3.0 - t) * 6; }
  return p;
}
