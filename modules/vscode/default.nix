{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cmake-tools
      twxs.cmake
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
    ];

    userSettings = {
      "workbench.iconTheme" = "material-icon-theme";

      "files.associations" = {
        "*.glsl" = "glsl";
        "*.vert" = "glsl";
        "*.frag" = "glsl";
      };

      "C_Cpp.intelliSenseEngine" = "disabled";
      "clangd.arguments" = [
        "--compile-commands-dir=build"
      ];

      "cmake.showConfigureWithDebuggerNotification" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;

      "editor.inlayHints.enabled" = "on";
      "editor.formatOnSave"= true;
    };
  };
}
