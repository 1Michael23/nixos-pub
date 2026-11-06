{ pkgs, ... }:

{
  # 24 GiB GTT cap. The BIOS UMA/VRAM carveout is set to 512 MiB, so the
  # OS sees ~30.6 GiB of RAM; 24 GiB leaves enough headroom for a loaded model.
  # `ttm.page_pool_size` is intentionally left at its default: it is a page
  # cache pool limit, not the GTT mapping size.
  boot.kernelParams = [ "ttm.pages_limit=6291456" ];

  # Pi is installed through modules/home/editors/pi.nix. Only the server is new.
  environment.systemPackages = [ pkgs.llama-cpp-vulkan ];

  systemd.user.services.llama-router = {
    description = "llama.cpp router (Vulkan)";
    wantedBy = [ "default.target" ];
    path = [ pkgs.coreutils ];

    script = ''
      mkdir -p "$HOME/models"
      # Idle sleep destroys the model/context, freeing memory. There is no
      # disk swap, so leaving a model idle-loaded is what keeps a closed lid
      # from pushing the 30 GiB of RAM into OOM.
      # 128K context with q8_0 K/V stays within the 24 GiB GTT cap. One
      # slot avoids multiplying KV and checkpoint memory; Pi is a single
      # user client.
      exec ${pkgs.llama-cpp-vulkan}/bin/llama-server \
        --models-dir "$HOME/models" \
        --models-max 1 \
        --no-models-autoload \
        --sleep-idle-seconds 900 \
        --jinja \
        -ngl 999 \
        -c 131072 \
        --parallel 1 \
        -fa on \
        --cache-type-k q8_0 --cache-type-v q8_0 \
        --load-mode none \
        --ctx-checkpoints 8 --checkpoint-min-step 0 \
        --cache-ram 2048 \
        --reasoning auto \
        --host 127.0.0.1 --port 8080
    '';

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
