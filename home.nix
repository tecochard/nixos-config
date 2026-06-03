{ config, pkgs, ... }:

{
  # Auto-import all modules from ./modules/
  imports = let
    modulesDir = ./modules;
    entries = builtins.readDir modulesDir;
  in map (name: modulesDir + "/${name}") (builtins.attrNames entries);

  home.username = "theoe";
  home.homeDirectory = "/home/theoe";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11"; # adjust if needed

  # Standalone packages (complex ones live in their own modules)
  home.packages = with pkgs; [
    # System
    git
    gh
    zip
    unzip
    hardinfo2

    # Productivity
    vivaldi
    discord
    spotify
    kdePackages.kate
    zed-editor
    nodejs_22
    corepack_22
    libreoffice
    google-fonts
    kdePackages.kcolorchooser
    obs-studio
    mpv
    shotcut
    untrunc-anthwlock
    gimp
    audacity
    lmms
    tiled
    appimage-run

    # Gaming
    steamcmd
    r2modman

    # Unity
    unityhub
    p7zip
    dotnet-sdk_8
  ];

  home.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
  };

  # Startup apps
  xdg.configFile = builtins.listToAttrs (map (app: {
    name = "autostart/${app}.desktop";
    value.text = ''
      [Desktop Entry]
      Type=Application
      Name=${app}
      Exec=${app}
      X-GNOME-Autostart-enabled=true
    '';
  }) [ "albert" ]);

}
