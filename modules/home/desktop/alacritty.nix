_:

{
  programs.alacritty = {
    enable = true;
    settings = {
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
