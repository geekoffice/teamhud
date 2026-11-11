# Soft Halo: an overlay backdrop shader

A **backdrop** is the layer TeamHUD draws *behind and around the hub buttons* on your overlay.
The built-in goo is one; you can write your own as a single `.wgsl` file. Soft Halo puts a soft
glow and a thin rim around each hub, in that hub's own colour, and leaves the rest of the screen
untouched. One file, no build step, no TeamHUD source needed.

This is not the same as a [live wallpaper](../live-wallpaper). Both are `.wgsl` files with the
same header, but a wallpaper paints your whole desktop behind every window, while a backdrop sits
on the overlay, is transparent wherever it draws nothing, and follows the hubs as they move.

```
backdrop-soft-halo/
  soft-halo.wgsl   the shader
  README.md        this file
```

Written against TeamHUD **1.0.0-alpha.1**.

## Install

1. Get the file into your shader library. Either:
   - **Drop it in:** copy `soft-halo.wgsl` to `.teamhud/shaders` in your home folder
     (`~/.teamhud/shaders/` on macOS and Linux, `%USERPROFILE%\.teamhud\shaders\` on Windows).
     TeamHUD watches that folder.
   - **Or import it** in the theme editor (next step): the **Import** square at the end of the
     backdrop row.
2. Open Preferences → Appearance → Theme → **New theme** (or **Edit** on one of My themes). This
   opens the theme editor, a sandbox: nothing changes on your overlay yet.
3. In the editor's backdrop row, pick **Soft Halo**. Its three sliders (Glow size, Glow
   brightness, Rim line) appear in the inspector, in a folder named after the shader.
4. Press **Apply to HUD**. To keep the look as a theme, use **Save as theme** (or **Save theme**)
   in the same footer.

The file name is the shader's id, so `soft-halo.wgsl` is `soft-halo`, and a theme selects it as
`user:soft-halo` (see [`theme-harbor-night`](../theme-harbor-night) for a theme that does).
Use letters, numbers, dots, dashes and underscores. Files over 64 KB, or without the header, are
ignored.

## Change it

**The header** (the JSON comment at the top) names the shader and declares up to 24 options.
Each `number` option becomes a slider. Values you change are saved into the theme; untouched ones
follow the defaults in the header.

- `"hubBackgrounds": "show"` keeps the hubs' own buttons drawn on top, so the shader only
  decorates around them. `"hide"` (the default, and what goo does) blanks the buttons so your
  shader *is* the hub.
- `"animated": false` means the shader is drawn only when a hub moves, then the GPU idles. If you
  use `time` for motion, set it to `true`, and say in your description that it costs battery: an
  animated backdrop redraws every frame.

**`backdrop_main`** runs for every pixel. Keep its signature exactly as in the file.

| Input | What it is |
|---|---|
| `uv`, `resolution` | Pixel position (0 to 1, top-left origin) and drawing size in device pixels. `uv * resolution` is the pixel in the same space as the hubs. |
| `color` | The theme's backdrop colour (linear RGB), a fallback for hubs without their own. |
| `widget_count`, `ws` | The hubs. Hub `i` is four `vec4`s from `ws[i*4]`: centre and velocity, size plus corner radius plus flags, merge hints, colour plus opacity. Loop to `i32(widget_count)`, never to a fixed number, and leave `WS_LEN` as written; TeamHUD fills in the real length. |
| `params` | Your options in declared order: option 1 is `params[0].x`, 2 is `.y`, 3 is `.z`, 4 is `.w`, 5 is `params[1].x`. |
| `time` | Seconds; only advances when `"animated": true`. Soft Halo ignores it. |

Return **premultiplied** `vec4<f32>(rgb, alpha)`: colour never brighter than alpha, and alpha 0
lets the desktop show through. You only draw; you can't change what's clickable.

Things to try: widen the glow (`36.0` in `reach`), drop the `if (d < 0.0)` line to tint the inside
of the hubs too, or make it breathe by multiplying `glow` by `0.8 + 0.2 * sin(time)` and setting
`"animated": true`.

In the theme editor, a selected shader of your own shows its source: edit it there and press
**Save shader**, or press **Export** to save the `.wgsl`. An edit to the file in
`~/.teamhud/shaders` from any text editor is picked up live too.

## Keep it light

The overlay is on screen all day. Soft Halo does a rounded-box distance and an `exp` per hub,
skips hubs far from the pixel, and skips team avatars and covered panels. Avoid loops that don't
depend on `widget_count`, texture-heavy effects, and `"animated": true` unless the motion is the
point.

## Safety

A backdrop is GPU code with no access to files, the network or other apps. TeamHUD test-compiles
it before switching, and if it fails, the overlay keeps the previous backdrop. A broken shader
can't take the overlay down, but a very heavy one can make it slow. Only install `.wgsl` files you
have read or got from someone you trust.

## Licence

MIT, see [LICENSING.md](../../LICENSING.md). This covers these files only, not the TeamHUD app.
