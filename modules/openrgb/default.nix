{ pkgs, ... }:

{
  home.packages = [ pkgs.openrgb ];

  # OpenRGB's native tray menu includes all saved profiles.
  xdg.configFile."autostart/openrgb.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=OpenRGB
    Comment=RGB lighting profiles in the system tray
    Exec=${pkgs.openrgb}/bin/openrgb --startminimized
    Icon=OpenRGB
    Terminal=false
  '';
}
