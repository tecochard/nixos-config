{ pkgs, ... }:

{
  home.packages = [ pkgs.posy-cursors ];

  home.pointerCursor = {
    name = "Posy_Cursor";
    package = pkgs.posy-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
