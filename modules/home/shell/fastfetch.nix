_:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        position = "top";
        padding.right = 2;
      };
      display = {
        separator = ": ";
        key.width = 8;
      };
      modules = [
        "os"
        "kernel"
        "uptime"
        {
          type = "wm";
          key = "WM";
        }
        "cpu"
        "gpu"
        "memory"
        {
          type = "disk";
          key = "Disk";
          folders = "/";
        }
      ];
    };
  };
}
