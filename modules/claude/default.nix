{ ... }:

{
  home.file.".claude/statusline.sh" = {
    source = ./statusline.sh;
    executable = true;
  };

  home.file.".claude/settings.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "Read"
        "Write"
        "Edit"
        "Glob"
        "Grep"
        "Bash"
        "WebFetch"
        "WebSearch"
      ];
    };
    statusLine = {
      type = "command";
      command = "~/.claude/statusline.sh";
    };
  };
}
