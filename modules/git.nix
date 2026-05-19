{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Theoe";
    userEmail = "theo.eco@outlook.fr";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
