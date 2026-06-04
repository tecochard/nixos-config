{ pkgs, ... }:

let
  wallpaper = ../../assets/Chants_Of_Sennaar_2023-09-07_17-31-31.jpg;
in
{
  programs.plasma.enable = true;
  programs.plasma.workspace.wallpaper = wallpaper;

  systemd.user.services.plasma-apply-wallpaper = {
    Unit = {
      Description = "Apply Plasma wallpaper after the graphical session starts";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.writeShellScript "plasma-apply-wallpaper" ''
        exec /run/current-system/sw/bin/plasma-apply-wallpaperimage "${wallpaper}"
      ''}";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
