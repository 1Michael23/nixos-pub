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

      #digikam #TODO i dont want to build this rn

      nomacs
    ];
}
