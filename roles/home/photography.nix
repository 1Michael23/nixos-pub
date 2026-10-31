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
      jpegoptim
      oxipng
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      ansel

      gphoto2
      entangle

      gimp
      nomacs
    ];
}
