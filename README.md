# Nectar Speed Edition V6 💜

**Cyber Violet** — modern, original speed-only Roblox GUI. No autofarm modules are loaded by the default loader.

## Solara loader

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/loader.lua"))()
```

## Features

- Cyber Violet dark GUI, neon highlights and translucent secondary labels
- Speed slider 16–200 and presets 30 / 50 / 100
- Speed on/off switch, settings page and reset-to-default action
- Smooth TweenService animations, draggable window, minimize, close
- RightShift to show/hide
- Cleanup and speed restoration on close or re-execution

## Files

- `NectarSpeedV6.lua` — **current version**, standalone Speed Edition
- `loader.lua` — points only to Speed Edition V6
- `NectarV5.lua`, `src/nectar_engine.lua`, `src/nectar_ui.lua` — **archived older code**, not loaded by default
- `NectarV3.lua` — previous speed GUI

### Important

Client-side WalkSpeed changes are not guaranteed to persist. Bee Swarm Simulator can override movement, and no detection evasion / anti-cheat bypass or ban immunity is provided. Solara execution has not been tested in a live game.

## Liquid glass character background

The Cyber Violet menu includes the user-selected blonde anime character. The uploaded image is held at `assets/nectar_character_base64.txt` as a compressed JPEG encoded in Base64. The client tries to download, decode, write and display it through `writefile` and `getcustomasset`/`getsynasset`. If the executor does not support local custom assets, the purple glass menu still works, but the illustration will not appear. For universal Roblox rendering, a published Roblox image asset ID would be required. The screenshot is not uploaded to Roblox by GitHub.
