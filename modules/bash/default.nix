{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      bashr = "source ~/.bashrc";
      nixr = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      plasmar = "systemctl --user restart plasma-plasmashell";
      gpu = "git push -u origin HEAD";
      vps = "ssh ubuntu@51.83.42.59";
      cc = "claude --continue";
      reboot-windows = "sudo efibootmgr -n 0000 && reboot";
      system = "hardinfo2";
    };
    initExtra = ''
      vpscp() {
        scp "$@" ubuntu@51.83.42.59:~
      }
    '';
  };
}
