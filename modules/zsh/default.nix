{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      zed = "zeditor";
      zshr = "source ~/.zshrc";
      nixr = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      nixs = "nix-shell";
      rtr = "cd ~/Documents/dev/opengl/opengl-real-time-rendering";
      plasmar = "systemctl --user restart plasma-plasmashell";
      gpu = "git push -u origin HEAD";
      gco = "git checkout";
      gcob = "git checkout -b";
      vps = "ssh ubuntu@51.83.42.59";
      cc = "claude --continue";
      reboot-windows = "sudo efibootmgr -n 0000 && reboot";
      system = "hardinfo2";
    };

    initContent = ''
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

      vpscp() {
        scp "$@" ubuntu@51.83.42.59:~
      }
    '';
  };
}
