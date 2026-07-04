{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # CVE-2026-31431: block algif_aead to prevent AF_ALG page cache corruption privilege escalation
  boot.blacklistedKernelModules = [ "algif_aead" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.settings.General.Numlock = "on";
  services.displayManager.sddm.settings.Theme = {
    CursorTheme = "Posy_Cursor";
    CursorSize = 24;
  };
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.discover
    kdePackages.kate
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics.enable = true;

  hardware.xone.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  console.keyMap = "fr";
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig."disable-webcam-mic" = {
      "monitor.alsa.rules" = [{
        matches = [{ "node.name" = "alsa_input.usb-Jieli_Technology_USB_PHY_2.0-02.mono-fallback"; }];
        actions.update-props."node.disabled" = true;
      }];
    };
  };

  users.users.theoe = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.download-buffer-size = 134217728; # 128 MiB
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    appimage-run
    firefox
    lm_sensors
    usbutils
    efibootmgr
  ];

  programs.steam.enable = true;
  programs.noisetorch.enable = true;
  programs.kdeconnect.enable = true;

  system.stateVersion = "25.11";

  services.gitlab-runner.enable = true;

  systemd.services.gitlab-runner.serviceConfig = {
    User = "theoe";
    Group = "users";
    WorkingDirectory = "/home/theoe";
  };
}
