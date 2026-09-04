{
  pkgs,
  lib,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      exiftool
      imagemagick
      libraw
      jpegoptim
      oxipng
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      ansel

      gphoto2
      entangle

      gimp

      digikam

      nomacs
    ];

  home.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    GDK_BACKEND = "wayland,x11";
  };
}
