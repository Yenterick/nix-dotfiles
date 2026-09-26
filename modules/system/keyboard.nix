{ ... }:

{
  # Linux (XKB) only turns Caps Lock off when the key is *released*, so typing
  # fast after the second press gives "HOla" instead of "Hola". keyd sends the
  # full press+release on key down, which matches Windows/macOS behaviour.
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        # Avoid toggling Caps Lock repeatedly when the key is held down
        global.macro_timeout = 1000000;
        main.capslock = "macro(capslock)";
      };
    };
  };
}
