{
  config,
  pkgs,
  opencode,
  ...
}:

let
  opencodePackages = opencode.packages.${pkgs.stdenv.hostPlatform.system};
  # v2.2.0's desktop build ignores the CLI directory prepared by its Nix derivation.
  opencodeDesktop = opencodePackages.opencode-desktop.overrideAttrs (old: {
    postPatch = old.postPatch + ''
      substituteInPlace packages/desktop/script/build.ts \
        --replace-fail 'const cli = path.resolve(dir, "../cli/dist")' \
                       'const cli = process.env.OPENCODE_CLI_DIST ?? path.resolve(dir, "../cli/dist")'
    '';
  });

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
    "OpenCode" = {
      exec = "opencode-desktop";
      icon = "ai.opencode.desktop";
      categories = "Development;";
      comment = "AI coding agent";
    };
    "The Witcher 3: Wild Hunt" = {
      exec = "steam steam://rungameid/292030";
      icon = "steam_icon_292030";
      categories = "Game;";
      comment = "Play The Witcher 3: Wild Hunt";
    };
    "Outer Wilds" = {
      exec = "steam steam://rungameid/753640";
      icon = "steam_icon_753640";
      categories = "Game;";
      comment = "Play Outer Wilds";
    };
    "OBS Studio" = {
      exec = "obs";
      icon = "com.obsproject.Studio";
      categories = "AudioVideo;Recorder;";
      comment = "Record and stream video";
    };
  };
in
{
  # Auto-import all modules from ./modules/
  imports =
    let
      modulesDir = ./modules;
      entries = builtins.readDir modulesDir;
    in
    map (name: modulesDir + "/${name}") (builtins.attrNames entries);

  home.username = "theoe";
  home.homeDirectory = "/home/theoe";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11"; # adjust if needed

  # Standalone packages (complex ones live in their own modules)
  home.packages =
    (with pkgs; [
      # System
      git
      gh
      zip
      unzip
      nixfmt
      hardinfo2

      # Productivity
      vivaldi
      discord
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
    blender
    lmms
      tiled
      appimage-run
      docker

      # Music
      spotify
      audacity

      # Gaming
      steamcmd
      r2modman

      # Unity
      unityhub
      p7zip
      dotnet-sdk_10
      gitlab-runner
      butler
      ffmpeg

      # AI dev tools from nixpkgs
      claude-code
      codex
    ])
    ++ [
      # CLI and desktop from the same pinned OpenCode v2 release
      opencodePackages.opencode
      opencodeDesktop
    ];

  home.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
  };

  # Startup apps
  xdg.configFile = builtins.listToAttrs (
    map (app: {
      name = "autostart/${app}.desktop";
      value.text = ''
        [Desktop Entry]
        Type=Application
        Name=${app}
        Exec=${app}
        X-GNOME-Autostart-enabled=true
      '';
    }) [ "albert" ]
  );

  home.file = builtins.listToAttrs (
    map (name: {
      name = "Desktop/${name}.desktop";
      value =
        let
          launcher = desktopLaunchers.${name};
        in
        {
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
    }) (builtins.attrNames desktopLaunchers)
  );
}
