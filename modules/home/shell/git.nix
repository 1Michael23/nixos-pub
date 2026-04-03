{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "1Michael23";
      user.email = "";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = false;
    };
    # signing = {
    #     signByDefault = true;
    #     key = "0xYOURKEYID";
    # };
  };
}
