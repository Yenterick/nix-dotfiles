{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Keep Bluetooth headphones in A2DP (stereo, high quality): don't drop to the
  # mono HSP/HFP call profile just because an app opened a microphone.
  services.pipewire.wireplumber.extraConfig."91-bluetooth-no-autoswitch" = {
    "wireplumber.settings"."bluetooth.autoswitch-to-headset-profile" = false;
  };

  # AndroidMic: phone streams to the PC app, which plays into the "Phone Mic" sink below
  environment.systemPackages = [ pkgs.android-mic ];
  networking.firewall.allowedTCPPorts = [ 54345 ];
  networking.firewall.allowedUDPPorts = [ 54345 ];

  # Virtual mic: whatever is played into the "Phone Mic (output)" sink comes out of
  # the "Phone Mic" source, which apps like Discord can pick as their input.
  services.pipewire.extraConfig.pipewire."90-phone-mic" = {
    "context.modules" = [
      {
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "Phone Mic";
          "audio.position" = [ "MONO" ];
          "capture.props" = {
            "node.name" = "phone_mic_sink";
            "node.description" = "Phone Mic (output)";
            "media.class" = "Audio/Sink";
            "priority.session" = 0; # never become the default speaker
          };
          "playback.props" = {
            "node.name" = "phone_mic";
            "node.description" = "Phone Mic";
            "media.class" = "Audio/Source";
          };
        };
      }
    ];
  };
}
