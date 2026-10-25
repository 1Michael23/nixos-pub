{
  lib,
  pkgs,
  ...
}:

let
  rawThumbnailer = pkgs.writeShellApplication {
    name = "raw-thumbnailer";
    runtimeInputs = with pkgs; [
      coreutils
      exiftool
      imagemagick
    ];
    text = ''
      set -o errexit
      set -o nounset
      set -o pipefail

      input=$1
      output=$2
      size=$3

      tmp=$(mktemp --suffix=.jpg)
      trap 'rm -f "$tmp"' EXIT

      convert_preview() {
        local tag
        tag=$1

        if exiftool -b "-$tag" "$input" > "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
          if magick "$tmp" -thumbnail "''${size}x''${size}>" "png:$output" 2>/dev/null; then
            return 0
          fi
        fi

        : > "$tmp"
        return 1
      }

      # Prefer the embedded preview: it is much faster than decoding the raw
      # image and works for cameras that ImageMagick's LibRaw cannot handle.
      if convert_preview PreviewImage; then
        exit 0
      fi

      if convert_preview JpgFromRaw; then
        exit 0
      fi

      # Fall back to a full raw decode for files without an embedded preview.
      if magick "$input" -thumbnail "''${size}x''${size}>" "png:$output" 2>/dev/null; then
        exit 0
      fi

      # Last resort: the small embedded thumbnail.
      if convert_preview ThumbnailImage; then
        exit 0
      fi

      exit 1
    '';
  };

  rawThumbnailerFile = pkgs.writeTextFile {
    name = "raw.thumbnailer";
    destination = "/share/thumbnailers/raw.thumbnailer";
    text = ''
      [Thumbnailer Entry]
      TryExec=${lib.getExe rawThumbnailer}
      Exec=${lib.getExe rawThumbnailer} %i %o %s
      MimeType=image/x-adobe-dng;image/x-canon-cr2;image/x-canon-cr3;image/x-canon-crw;image/x-epson-erf;image/x-fuji-raf;image/x-minolta-mrw;image/x-nikon-nef;image/x-nikon-nrw;image/x-olympus-orf;image/x-panasonic-rw2;image/x-pentax-pef;image/x-samsung-srw;image/x-sigma-x3f;image/x-sony-arw;
    '';
  };
in
{
  environment.systemPackages = [
    pkgs.gdk-pixbuf
    pkgs.ffmpegthumbnailer
    pkgs.tumbler
    rawThumbnailer
    rawThumbnailerFile
  ];
}
