# Hyprland 0.53+ Windowrule Migration

Hyprland **0.53.0** (released Jan 2026) completely rewrote the `windowrule` syntax. Configs written for 0.52 and earlier will surface a red "Config error" banner at the top of the screen on every reload.

This document is a quick migration reference. For the full spec, see the upstream [Window Rules wiki](https://wiki.hypr.land/Configuring/Window-Rules/).

## How to know you're affected

```bash
hyprctl version        # confirm you are on 0.53 or newer
hyprctl configerrors   # show the exact failing lines
```

Typical error shapes:

```
Config error in file .../windowrules.conf at line 2: invalid field noinitialfocus: missing a value
Config error in file .../bindings.conf at line 62: invalid field class:^(Code)$: missing a value
Config error in file .../input.conf at line 33: invalid field type scrolltouchpad
```

All three are symptoms of the same thing: old syntax that 0.53's parser no longer recognises.

## What changed

### 1. The `windowrulev2` keyword is gone

`windowrule` now natively supports the "v2" matcher style. Replace any remaining `windowrulev2 = ...` with `windowrule = ...`.

### 2. Matchers use `match:KEY VALUE` (space), not `KEY:VALUE` (colon)

| Old (≤0.52) | New (0.53+) |
| --- | --- |
| `class:^(Code)$` | `match:class ^(Code)$` |
| `title:^(Foo)$` | `match:title ^(Foo)$` |
| `xwayland:1` | `match:xwayland 1` |
| `floating:1` | `match:float 1` |
| `fullscreen:1` | `match:fullscreen 1` |
| `pinned:1` | `match:pin 1` |
| `onworkspace:*` | drop it (universal match is implicit) |

Multiple matchers are still comma-separated:

```
windowrule = workspace 6, match:class ^(Spotify)$
windowrule = tag +term, match:class footclient, match:xwayland 0
```

Order doesn't matter — matchers can come before or after the action.

### 3. Several action names got an underscore

| Old | New |
| --- | --- |
| `noinitialfocus` | `no_initial_focus on` |
| `suppressevent` | `suppress_event` |
| `scrolltouchpad` | `scroll_touchpad` |
| `nofocus` | `no_focus on` |
| `noblur` | `no_blur on` |
| `nodim` | `no_dim on` |
| `noshadow` | `no_shadow on` |
| `noanim` | `no_anim on` |

### 4. Static boolean actions now require an explicit `on`

Bare `fullscreen` / `maximize` / `no_initial_focus` error with _"missing a value"_. Append `on`:

```
windowrule = fullscreen on,        match:class ^(org\.omarchy\.screensaver)$
windowrule = no_initial_focus on,  match:class .*
```

### 5. The `windowtype` matcher was dropped

Rules like `windowrulev2 = float, xwayland:1, windowtype:^(dialog|splash|utility)$` no longer have a new-syntax equivalent — there is no `match:windowtype`. Hyprland 0.53 handles XWayland dialog/splash/tooltip floating on its own, so these rules can usually be **deleted**.

## Concrete before/after examples (from this repo)

### `configs/hypr/bindings.conf` (workspace pinning)

```diff
-windowrule = workspace 2, class:^(Code)$
-windowrule = workspace 5, class:^(Brave-browser)$
+windowrule = workspace 2, match:class ^(Code)$
+windowrule = workspace 5, match:class ^(Brave-browser)$
```

### `configs/hypr/input.conf` (per-app scroll factor)

```diff
-windowrule = scrolltouchpad 1.5, class:(Alacritty|kitty)
-windowrule = scrolltouchpad 0.2, class:com.mitchellh.ghostty
+windowrule = scroll_touchpad 1.5, match:class (Alacritty|kitty)
+windowrule = scroll_touchpad 0.2, match:class com.mitchellh.ghostty
```

### `configs/hypr/windowrules.conf` (focus suppression + screensaver)

```diff
-windowrule = noinitialfocus, class:.*
-windowrule = suppressevent activatefocus, class:.*
-windowrulev2 = fullscreen, class:^(org\.omarchy\.screensaver)$
-windowrulev2 = noinitialfocus, class:^(org\.omarchy\.screensaver)$, onworkspace:*
+windowrule = no_initial_focus on, match:class .*
+windowrule = suppress_event activatefocus, match:class .*
+windowrule = fullscreen on, match:class ^(org\.omarchy\.screensaver)$
+windowrule = no_initial_focus on, match:class ^(org\.omarchy\.screensaver)$
```

### `configs/hypr/monitors.conf` (XWayland dialog rules — deleted)

```diff
-# dialogs/splash/utility ONLY
-windowrulev2 = float,  xwayland:1, windowtype:^(dialog|splash|utility)$
-windowrulev2 = center, xwayland:1, windowtype:^(dialog|splash|utility)$
-# never center menus/tooltips
-windowrulev2 = tile,   xwayland:1, windowtype:^(popup_menu|dropdown_menu|tooltip)$
+# Hyprland 0.53+ dropped the `windowtype` matcher; Hyprland handles
+# XWayland dialog/splash/tooltip floating automatically. Rules removed.
```

## Verification

After editing, reload and confirm no errors:

```bash
hyprctl reload
hyprctl configerrors    # should print nothing
```

## Related upstream references

- Hyprland 0.53 release notes: https://hypr.land/news/update53/
- Window Rules wiki: https://wiki.hypr.land/Configuring/Window-Rules/
- Omarchy issue #4234 (windowrule 0.53): https://github.com/basecamp/omarchy/issues/4234
- Omarchy issue #4276 (scrolltouchpad): https://github.com/basecamp/omarchy/issues/4276
