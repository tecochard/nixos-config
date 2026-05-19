{ pkgs, ... }:

{
  home.packages = [ pkgs.noisetorch ];

  systemd.user.services.noisetorch = {
    Unit = {
      Description = "NoiseTorch noise suppression";
      After = [ "pipewire.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s alsa_input.usb-HP__Inc_HyperX_Cloud_III_Wireless_0000000000000000-00.mono-fallback";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
