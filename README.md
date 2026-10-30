# Nectar V4

Atlas-inspired UI with independent Bee Swarm Simulator helpers and an opt-in Original Atlas launcher.

## Solara loader

    loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/loader.lua"))()

## Nectar features

- Modern 10-tab GUI with search, scrolling and toggles; RightShift shows/hides
- Farming: field choice, walking farm, tool dig, sprinkler helper
- Collection: token movement and attempted honey conversion when stats and hive are identifiable
- Combat: approach spawned mobs
- Quests: NPC and proximity prompt assistance (not automatic quest completion)
- Config: client WalkSpeed 16-200, persistent preferences when file APIs work
- Planters/Toys/RBC/advanced Farming/Quests: opt-in original Atlas launcher (separate UI)

## Important limitations

The Original Atlas upstream script is obfuscated. It is loaded only when the user explicitly selects Launch Original Atlas. Its features run in a separate interface and are not controlled by Nectar toggles.

Nectar helpers are best-effort and untested in live Bee Swarm Simulator. Game/server limits, executor support and game updates may prevent them from working. No anti-cheat bypass or ban immunity is provided.

NectarV3.lua is retained for rollback.