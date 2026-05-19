{ pkgs, ... }:

let
  albert-zed-workspaces = pkgs.runCommand "albert-plugin-zed-workspaces" {
    src = pkgs.fetchFromGitHub {
      owner = "HarshNarayanJha";
      repo = "albert-plugin-python-zed-workspaces";
      rev = "1cd0dcb5ca966233da783870f3d0a3be5c006df1";
      hash = "sha256-IAmlSLg4N5aYHXeZi30PWpTNgdRepERqhCThGQMc0gw=";
    };
  } ''
    mkdir -p $out/share/albert/python/plugins/albert_zed_workspaces
    cp -r $src/* $out/share/albert/python/plugins/albert_zed_workspaces/
  '';
in
{
  home.packages = with pkgs; [
    albert
    albert-zed-workspaces
    (python3.withPackages (ps: [ ps.python-dateutil ]))
  ];

  xdg.configFile."albert/config" = {
    text = ''
      [General]
      showTray=true
      telemetry=false

      [python]
      enabled=true

      [python.albert_zed_workspaces]
      enabled=true

      [applications]
      enabled=true

      [spotify]
      enabled=true

      [websearch]
      enabled=true

      [widgetsboxmodel]
      action_item_padding=6
      action_item_selection_border_radius=11
      action_item_selection_border_width=0
      alwaysOnTop=true
      clearOnHide=true
      disable_input_method=true
      displayScrollbar=false
      followCursor=true
      hideOnFocusLoss=true
      historySearch=true
      input_border_radius=11
      input_font_size=19
      input_padding=5
      itemCount=5
      result_item_horizontal_spacing=6
      result_item_icon_size=39
      result_item_padding=6
      result_item_selection_border_radius=11
      result_item_selection_border_width=0
      result_item_subtext_font_size=9
      result_item_text_font_size=14
      result_item_vertical_spacing=2
      showCentered=true
      window_border_radius=18
      window_border_width=1
      window_padding=7
      window_shadow_offset=8
      window_shadow_size=80
      window_spacing=7
      window_width=640
    '';
  };
}
