{ pkgs, ... }:

{
  xdg.configFile = {
    "zed/settings.json".text = builtins.toJSON {
      lsp = {
        rust-analyzer = {
          binary = {
            path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
        };
      };
    };
    "zed/keymap.json".text = builtins.toJSON [
      {
        bindings = {
          "alt-shift-a" = "editor::ToggleComments";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-(" = "pane::SplitRight";
        };
      }
    ];
  };
}
