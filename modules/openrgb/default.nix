{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.openrgb ];

  programs.plasma.configFile."plasma-org.kde.plasma.desktop-appletsrc".
    "Containments/2/Applets/7/General".hiddenItems = "openrgb";

  # Seed writable profiles on a new installation without replacing local edits.
  home.activation.openrgbProfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg "${config.xdg.configHome}/OpenRGB/Lights on.orp"} ]; then
      run ${pkgs.coreutils}/bin/install -Dm644 \
        ${lib.escapeShellArg (toString ./profiles + "/Lights on.orp")} \
        ${lib.escapeShellArg "${config.xdg.configHome}/OpenRGB/Lights on.orp"}
    fi
  '';

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
