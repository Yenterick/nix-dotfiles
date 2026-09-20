{ ... }:

{
  imports = [ ./arsene-hardware.nix ];
  networking.hostName = "arsene";
  hardware.graphics.enable = true;

  # Lid-switch handling is done ourselves (see home/desktop/scripts/lid-handler.sh)
  # so it can hand off to an HDMI monitor instead of suspending when docked.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
