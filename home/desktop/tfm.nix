{ ... }:

let
  palette = import ../core/palette.nix;
in
{
  home.file.".config/tfm/config.toml".text = ''
    [theme]
    bg             = "${palette.background}"
    sidebarBg      = "${palette.color0}"
    sidebarFg      = "${palette.foreground}"
    sidebarFgMuted = "${palette.color8}"
    accent         = "${palette.accent}"
    accentBg       = "${palette.color3}"
    hoverBg        = "${palette.color6}"
    border         = "${palette.color3}"
    divider        = "${palette.color3}"
    white          = "${palette.foreground}"
    syntaxString   = "${palette.color4}"
    syntaxNumber   = "${palette.color10}"
    syntaxType     = "${palette.color13}"
    syntaxFunction = "${palette.accent}"
    syntaxOperator = "${palette.color7}"
    syntaxProperty = "${palette.color12}"
    ansi0          = "${palette.color0}"
    ansi1          = "${palette.color1}"
    ansi2          = "${palette.color2}"
    ansi3          = "${palette.color3}"
    ansi4          = "${palette.color4}"
    ansi5          = "${palette.color5}"
    ansi6          = "${palette.color6}"
    ansi7          = "${palette.color7}"
    ansi8          = "${palette.color8}"
    ansi9          = "${palette.color9}"
    ansi10         = "${palette.color10}"
    ansi11         = "${palette.color11}"
    ansi12         = "${palette.color12}"
    ansi13         = "${palette.color13}"
    ansi14         = "${palette.color14}"
    ansi15         = "${palette.color15}"
  '';

  xdg.desktopEntries.tfm = {
    name = "tfm";
    comment = "Terminal file manager";
    exec = "kitty --class tfm --title tfm -e tfm %f";
    terminal = false;
    type = "Application";
    icon = "system-file-manager";
    categories = [ "System" "FileTools" "FileManager" ];
    mimeType = [ "inode/directory" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "tfm.desktop";
      # Preserve the association the claude-code CLI installer writes
      # directly to ~/.local/share/applications; home-manager now owns
      # mimeapps.list wholesale, so it has to be declared here too.
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  # ~/.config/mimeapps.list already existed as a plain file (written by
  # something other than home-manager) before this module started managing
  # it, so without `force` the activation refuses to overwrite it.
  xdg.configFile."mimeapps.list".force = true;
}
