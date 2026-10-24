_:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # Keep this exact tilde path: Noctalia's built-in Alacritty template
      # rewrites the import in place and must see no diff through the HM symlink.
      general.import = [ "~/.config/alacritty/themes/noctalia.toml" ];
      window = {
        opacity = 0.7;
        padding = {
          x = 6;
          y = 6;
        };
      };
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Regular";
        };
        bold = {
          family = "Source Code Pro";
          style = "Bold";
        };
        italic = {
          family = "Source Code Pro";
          style = "Italic";
        };
        size = 12.0;
      };
    };
  };
}
