{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    custom.pgp = {
      enable = lib.mkEnableOption "PGP / GnuPG with signing subkey support";

      defaultKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "0x37ACBCDA569C5C44788";
        description = "Long key ID of your signing key (used as default-key).";
      };

      cacheTtl = lib.mkOption {
        type = lib.types.int;
        default = 3600; # 1h
        description = "Seconds a cached passphrase stays valid after last use.";
      };

      maxCacheTtl = lib.mkOption {
        type = lib.types.int;
        default = 7200; # 2h
        description = "Max total seconds a cached passphrase remains valid.";
      };
    };
  };

  config = lib.mkIf config.custom.pgp.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;

      # Pick the right pinentry for the platform.
      # Darwin: pinentry_mac (native Cocoa dialog).
      # Linux:  pinentry-qt (works under KDE/Hyprland/etc).
      pinentryPackage = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;

      defaultCacheTtl = config.custom.pgp.cacheTtl;
      inherit (config.custom.pgp) maxCacheTtl;
      defaultCacheTtlSsh = config.custom.pgp.cacheTtl;
      maxCacheTtlSsh = config.custom.pgp.maxCacheTtl;

      # Populate if/when you move to a YubiKey or want a specific subkey
      # exposed to ssh (keygrip from `gpg --list-keys --with-keygrip`).
      sshKeys = [ ];
    };

    home.packages = [ pkgs.gnupg ];

    programs.gpg = {
      enable = true;

      settings = lib.mkMerge [
        {
          # --- Crypto hygiene (drduh-style hardening) ---
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          cert-digest-algo = "SHA512";
          s2k-digest-algo = "SHA512";
          s2k-cipher-algo = "AES256";

          # --- Display / compat ---
          charset = "utf-8";
          fixed-list-mode = "";
          no-comments = "";
          no-emit-version = "";
          no-greeting = "";
          keyid-format = "0xlong";
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          with-fingerprint = "";
          require-cross-certification = "";
          no-symkey-cache = "";
        }

        # Only add default-key / trusted-key if the user supplied one
        (lib.mkIf (config.custom.pgp.defaultKey != null) {
          default-key = config.custom.pgp.defaultKey;
          trusted-key = config.custom.pgp.defaultKey;
        })
      ];
    };

    # Tell git to sign with the same key; format=openpgp is the default
    # but stating it explicitly avoids surprises if you later try SSH signing.
    programs.git = lib.mkIf (config.custom.pgp.defaultKey != null) {
      enable = true;
      signing = {
        key = config.custom.pgp.defaultKey;
        signByDefault = true;
        format = "openpgp";
      };
      extraConfig.gpg.program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
