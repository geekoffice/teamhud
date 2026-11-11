/* @teamhud-shader {
  "schemaVersion": 1,
  "id": "soft-halo",
  "name": "Soft Halo",
  "description": "A soft glow and a thin rim around each hub, in that hub's own colour. Static: redraws only when hubs move.",
  "language": "wgsl",
  "animated": false,
  "hubBackgrounds": "show",
  "options": [
    { "key": "size", "label": "Glow size", "type": "number", "min": 0, "max": 100, "default": 45, "group": "Halo" },
    { "key": "strength", "label": "Glow brightness", "type": "number", "min": 0, "max": 100, "default": 55, "group": "Halo" },
    { "key": "rim", "label": "Rim line", "type": "number", "min": 0, "max": 100, "default": 40, "group": "Halo" }
  ]
} */

// Signed distance from p to a rounded box of half-size h and corner radius r (negative inside).
fn halo_sd_box(p: vec2<f32>, h: vec2<f32>, r: f32) -> f32 {
  let q = abs(p) - h + vec2<f32>(r);
  return length(max(q, vec2<f32>(0.0))) + min(max(q.x, q.y), 0.0) - r;
}

// Entry point required by the TeamHUD shader contract. Keep the signature exactly as is,
// including WS_LEN (the runtime substitutes the real length before compiling).
fn backdrop_main(
  uv: vec2<f32>,
  resolution: vec2<f32>,
  color: vec3<f32>,
  widget_count: f32,
  ws: array<vec4<f32>, WS_LEN>,
  params: array<vec4<f32>, 6>,
  time: f32
) -> vec4<f32> {
  let px = uv * resolution;               // this pixel, in device px (same space as ws)
  let n = i32(widget_count);
  let reach = 4.0 + 36.0 * params[0].x / 100.0; // option 1: glow falloff, in px
  let gain = params[0].y / 100.0;               // option 2
  let rim_k = params[0].z / 100.0;              // option 3

  var acc = vec3<f32>(0.0);
  var a = 0.0;
  for (var i = 0; i < n; i++) {               // loop to the live count, never a constant
    let v0 = ws[i * 4 + 0];                   // centre.xy, velocity.zw
    let v1 = ws[i * 4 + 1];                   // size.xy, corner radius, flags
    let v2 = ws[i * 4 + 2];                   // merge hints
    let v3 = ws[i * 4 + 3];                   // colour.rgb, opacity
    // Hubs only: team avatars have merge-edge off (v2.x = 0), covered panels set flag bit 1.
    if (v2.x < 0.5 || (u32(v1.w) & 2u) != 0u) { continue; }
    let h = v1.xy * 0.5;
    let p = px - v0.xy;
    if (length(p) > max(h.x, h.y) + reach * 5.0) { continue; } // far away: skip the maths
    let d = halo_sd_box(p, h, min(v1.z, min(h.x, h.y)));
    if (d < 0.0) { continue; }                // inside the hub: its own chrome draws there

    // The hub's own colour when it has one, else the theme's backdrop colour.
    let tint = select(color, v3.xyz, dot(v3.xyz, v3.xyz) > 1e-4);
    let glow = exp(-d / reach) * gain * 0.6;
    let rim = (1.0 - smoothstep(0.0, 1.5, abs(d - 1.0))) * rim_k;
    let m = clamp((glow + rim) * v3.w, 0.0, 1.0);
    acc += tint * m;
    a = max(a, m);
  }
  // Premultiplied: colour never exceeds alpha. Alpha 0 = the desktop shows through.
  return vec4<f32>(min(acc, vec3<f32>(a)), a);
}
