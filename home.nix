{ config, pkgs, ... }:

let
  desktopLaunchers = {
    "Ankama Launcher" = {
      exec = "sh -c 'appimage-run \"/home/theoe/Applications/Ankama Launcher-Setup-x86_64.AppImage\"'";
      icon = "/home/theoe/.local/share/icons/ankama-launcher.png";
      categories = "Game;";
      comment = "Launcher Dofus / Ankama";
    };
    "Unity Hub" = {
      exec = "unityhub";
      icon = "unityhub";
      categories = "Development;";
      comment = "Manage Unity installations and projects";
    };
    "Discord" = {
      exec = "Discord";
      icon = "discord";
      categories = "Network;InstantMessaging;";
      comment = "Chat for communities and friends";
    };
  };
in
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

    # AI dev tools
    claude-code
    codex
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

  home.file = builtins.listToAttrs (map (name: {
    name = "Desktop/${name}.desktop";
    value = let
      launcher = desktopLaunchers.${name};
    in {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=${name}
        Exec=${launcher.exec}
        Icon=${launcher.icon}
        Terminal=false
        Categories=${launcher.categories}
        Comment=${launcher.comment}
      '';
    };
  }) (builtins.attrNames desktopLaunchers));

}
