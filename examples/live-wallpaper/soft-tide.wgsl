/* @teamhud-shader {
  "schemaVersion": 1,
  "id": "soft-tide",
  "name": "Soft Tide",
  "description": "Three slow bands of light rolling like a calm tide, tinted by your theme color.",
  "language": "wgsl",
  "animated": true,
  "options": [
    { "key": "speed", "label": "Speed", "type": "number", "min": 0, "max": 100, "default": 25, "group": "Motion" },
    { "key": "waves", "label": "Wave height", "type": "number", "min": 0, "max": 100, "default": 50, "group": "Look" },
    { "key": "brightness", "label": "Brightness", "type": "number", "min": 0, "max": 100, "default": 45, "group": "Look" }
  ]
} */

// One wave band: a soft glowing crest line plus a faint fill below it (uv is y-down).
fn tide_band(x: f32, y: f32, t: f32, base: f32, amp: f32, freq: f32, phase: f32) -> f32 {
  let crest = base + amp * (0.6 * sin(x * freq + t + phase) + 0.4 * sin(x * freq * 2.3 - t * 0.7 + phase));
  let d = y - crest;
  return exp(-d * d * 900.0) * 0.6 + smoothstep(0.0, 0.25, d) * 0.12;
}

// Entry point required by the TeamHUD shader contract. Keep the signature exactly as is,
// including WS_LEN (the runtime substitutes it); this wallpaper ignores the hub array `ws`.
fn backdrop_main(
  uv: vec2<f32>,
  resolution: vec2<f32>,
  color: vec3<f32>,
  widget_count: f32,
  ws: array<vec4<f32>, WS_LEN>,
  params: array<vec4<f32>, 6>,
  time: f32
) -> vec4<f32> {
  // Options arrive in declaration order: params[0].x = speed, .y = waves, .z = brightness.
  let speed = 0.02 + (params[0].x / 100.0) * 0.18;
  let amp = 0.01 + (params[0].y / 100.0) * 0.05;
  let brightness = 0.2 + (params[0].z / 100.0) * 0.8;
  let t = time * speed;

  let aspect = resolution.x / max(resolution.y, 1.0);
  let x = uv.x * aspect;
  let y = uv.y;

  // Keep a little light even if the theme color is very dark.
  let tint = max(color, vec3<f32>(0.08));
  let pale = mix(tint, vec3<f32>(1.0), 0.35);
  let paler = mix(tint, vec3<f32>(1.0), 0.6);

  // Dim sky, a touch brighter toward the horizon.
  var acc = tint * mix(0.04, 0.12, y);
  acc += tint * tide_band(x, y, t, 0.62, amp, 3.0, 0.0) * 0.55 * brightness;
  acc += pale * tide_band(x, y, t * 1.3, 0.72, amp * 0.8, 4.2, 2.1) * 0.45 * brightness;
  acc += paler * tide_band(x, y, t * 1.7, 0.83, amp * 0.6, 5.5, 4.4) * 0.35 * brightness;

  // Soft vignette so the edges fall away.
  let c = uv - vec2<f32>(0.5);
  acc = acc * (1.0 - 0.4 * dot(c, c));

  return vec4<f32>(clamp(acc, vec3<f32>(0.0), vec3<f32>(1.0)), 1.0);
}
