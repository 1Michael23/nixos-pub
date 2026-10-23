{
  pkgs,
  ...
}:

{
  fonts.packages = with pkgs; [
    source-code-pro
    dejavu_fonts
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Source Code Pro" ];
    sansSerif = [ "DejaVu Sans" ];
    serif = [ "DejaVu Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };
}
