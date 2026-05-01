{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    host = "0.0.0.0";
    port = 11434;

    # home = "/var/lib/ollama";
    # models = "/var/lib/ollama/models";

    # loadModels = [ "llama3.1:8b" "qwen2.5-coder:7b" ];

    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_FLASH_ATTENTION = "1";
    };
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";
    };
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      11434
      8080
    ];
  };
}
