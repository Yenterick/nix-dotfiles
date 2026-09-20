{ pkgs, inputs, lib, ... }:

let
  # Zen Mod: Transparent Zen (https://www.sameerasw.com/zen)
  modId = "642854b5-88b4-4c40-b256-e035532109df";

  # Prefs the Transparent Zen mod reads to know which of its features to
  # enable; kept here so a fresh profile ends up configured the same way.
  modPrefs = {
    "browser.tabs.allow_transparent_browser" = true;
    "zen.widget.linux.transparency" = true;
    "mod.sameerasw.zen_transparent_sidebar_enabled" = true;
    "mod.sameerasw.zen_transparent_glance_enabled" = true;
    "mod.sameerasw.zen_tab_switch_anim" = true;
    "mod.sameerasw_zen_animations" = "1";
    "mod.sameerasw_zen_light_tint" = "2";
    "mod.sameerasw_zen_compact_sidebar_type" = "0";
    "mod.sameerasw.zen_compact_sidebar_width" = "165px";
    "mod.sameerasw.zen_no_shadow" = false;
    "mod.sameerasw.zen_bg_color_enabled" = false;
    "mod.sameerasw.zen_transparency_color" = "#00000000";
    "mod.sameerasw.zen_bg_img_enabled" = false;
    "mod.sameerasw.zen_bg_img_not_fullscreen" = false;
    "mod.sameerasw.zen_bg_img" = "url('https://github.com/sameerasw/my-internet/blob/main/wallpapers/zen-coral-01.jpeg?raw=true')";
    "mod.sameerasw.zen_bg_opacity" = "0.8";
    "mod.sameerasw.zen_bg_blur" = "3px";
    "mod.sameerasw_zen_empty_tab_logo" = "0";
    "mod.sameerasw.zen_notab_img" = "url('https://github.com/sameerasw/my-internet/blob/main/wave-light.png?raw=true')";
    "mod.sameerasw.zen_notab_img_size" = "150px";
    "mod.sameerasw.zen_notab_img_opacity" = "1";
    "mod.sameerasw.zen_urlbar_zoom_anim" = false;
    "mod.sameerasw.zen_trackpad_anim" = false;
  };

  toPrefLine = name: value:
    "user_pref(${builtins.toJSON name}, ${
      if builtins.isBool value then (if value then "true" else "false")
      else if builtins.isString value then builtins.toJSON value
      else toString value
    });";

  userJs = pkgs.writeText "zen-user.js"
    (lib.concatStringsSep "\n" (lib.mapAttrsToList toPrefLine modPrefs) + "\n");
in
{
  home.packages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Zen profile directories are named "<random>.Default Profile" and can't be
  # known ahead of time, so find the (single) profile at activation time and
  # seed its mods/prefs/shortcuts from the repo. Non-destructive: only
  # touches the specific files below.
  home.activation.zenBrowserConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    profile_dir=$(find "$HOME/.config/zen" -mindepth 1 -maxdepth 1 -type d -name '*.Default Profile' 2>/dev/null | head -n1)
    if [ -n "$profile_dir" ]; then
      $DRY_RUN_CMD install -Dm644 ${userJs} "$profile_dir/user.js"
      $DRY_RUN_CMD install -Dm644 ${./zen/zen-themes.json} "$profile_dir/zen-themes.json"
      $DRY_RUN_CMD install -Dm644 ${./zen/keyboard-shortcuts.json} "$profile_dir/zen-keyboard-shortcuts.json"
      $DRY_RUN_CMD install -Dm644 ${./zen/mods/transparent-zen/chrome.css} "$profile_dir/chrome/zen-themes/${modId}/chrome.css"
      $DRY_RUN_CMD install -Dm644 ${./zen/mods/transparent-zen/preferences.json} "$profile_dir/chrome/zen-themes/${modId}/preferences.json"
      $DRY_RUN_CMD install -Dm644 ${./zen/mods/transparent-zen/readme.md} "$profile_dir/chrome/zen-themes/${modId}/readme.md"
    fi
  '';
}
