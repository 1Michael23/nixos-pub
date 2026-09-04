{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Forge 1.12.2 requires Java 8. Prebuilt Temurin JRE (GPL-2.0 + Classpath,
  # no allowUnfree needed) — the most reliable pin. Free-from-source alt:
  # pkgs.jdk8_headless / pkgs.openjdk8_headless.
  jre8 = pkgs.temurin-jre-bin-8;

  forgeJar = "forge-1.12.2-14.23.5.2855.jar";

  ftburZip = pkgs.requireFile {
    name = "FTBUltimateReloaded-server.zip";
    sha256 = "sha256-kNWBeZePAFMgRta11NVg0SdSNSgr5jJHoHNckIhEA9Y=";
    message = ''
      Download/build the FTB Ultimate Reloaded (1.12.2) SERVER files. The zip
      must be a fully-installed server (forge jar + minecraft_server.1.12.2.jar
      + populated libraries/ + mods/ + config/ + scripts/ + .patches/), NOT the
      client modpack.

      Quickest path:
        1. curl -L https://api.feed-the-beast.com/v1/modpacks/public/modpack/36/2052/server/linux -o serverinstall
        2. chmod +x serverinstall && ./serverinstall --auto --force   # in an empty dir
           (if the forge installer aborts on a vanilla-jar download reset, re-run;
            or pre-place minecraft_server.1.12.2.jar in that dir)
        3. rm -rf jre serverinstall start.sh .manifest.json *.log animation artwork resources
        4. zip -r FTBUltimateReloaded-server.zip .
        5. nix-store --add-fixed sha256 FTBUltimateReloaded-server.zip
           then `nix hash file FTBUltimateReloaded-server.zip` and set `sha256` above.
    '';
  };

  ftburServer =
    pkgs.runCommand "ftbur-server-files"
      {
        nativeBuildInputs = [ pkgs.unzip ];
      }
      ''
        mkdir -p "$out"
        unzip -q "${ftburZip}" -d "$out"
      '';

  ftburPackage = pkgs.writeShellScriptBin "minecraft-server" ''
    exec ${jre8}/bin/java \
      -Djava.awt.headless=true \
      -Dlog4j.configurationFile=${ftburServer}/.patches/log4j2_112-116.xml \
      "$@" \
      -jar ${ftburServer}/${forgeJar} nogui
  '';
in
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = ftburPackage;
    dataDir = "/var/lib/minecraft"; # local disk, not /mnt/media (region-file locking)
    openFirewall = true; # opens server-port TCP (UDP only if enable-query)

    jvmOpts = lib.concatStringsSep " " [
      "-Xms6G"
      "-Xmx6G"
      "-XX:+UseG1GC"
      "-XX:+ParallelRefProcEnabled"
      "-XX:MaxGCPauseMillis=200"
      "-XX:+UnlockExperimentalVMOptions"
      "-XX:+DisableExplicitGC"
      "-XX:+AlwaysPreTouch"
      "-XX:G1NewSizePercent=30"
      "-XX:G1MaxNewSizePercent=40"
      "-XX:G1HeapRegionSize=8M"
      "-XX:G1ReservePercent=20"
      "-XX:G1HeapWastePercent=5"
      "-XX:G1MixedGCCountTarget=4"
      "-XX:InitiatingHeapOccupancyPercent=15"
      "-XX:G1MixedGCLiveThresholdPercent=90"
      "-XX:G1RSetUpdatingPauseTimePercent=5"
      "-XX:SurvivorRatio=32"
      "-XX:+PerfDisableSharedMem"
      "-XX:MaxTenuringThreshold=1"
    ];

    declarative = true;

    serverProperties = {
      server-port = 25565;
      level-name = "Dehydration";
      motd = "FTB Ultimate Reloaded (NixOS)";
      difficulty = 3;
      gamemode = 0;
      max-players = 10;
      white-list = true;
      online-mode = true;
      view-distance = 16;
    };

    whitelist = {
      Dip_Bean = "74f5d028-87ef-4a8b-86ee-e53e481668cd";
      HarmDav = "b9e9b783-84d2-49b1-a541-837bd8efa102";
    };
  };

  # Merge read-only modpack into writable dataDir. Symlink read-only dirs
  # (they retarget to the new store path on every rebuild), copy `config`
  # once and leave it mutable (mods rewrite it at runtime). The stamp file
  # keys the copy on the store path so it refreshes when the pack changes.
  systemd.services.minecraft-server.preStart = lib.mkAfter ''
    for p in scripts libraries minecraft_server.1.12.2.jar; do
      [ -e "${ftburServer}/$p" ] && ln -sfn "${ftburServer}/$p" "$p"
    done

    if [ -L mods ] || [ ! -e mods ]; then
      rm -f mods
      cp -r --no-preserve=ownership "${ftburServer}/mods" mods
      chmod -R u+w mods
    fi

    stamp=".ftbur-src"
    if [ "$(cat "$stamp" 2>/dev/null)" != "${ftburServer}" ]; then
      rm -rf config
      cp -r --no-preserve=ownership "${ftburServer}/config" config
      chmod -R u+w config
      echo "${ftburServer}" > "$stamp"
    fi
  '';
}
