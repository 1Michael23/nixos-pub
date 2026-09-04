{
  pkgs,
  ...
}:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host = "127.0.0.1";
    rocmOverrideGfx = "11.0.3";
    loadModels = [
      "qwen2.5-coder:7b"
      "llama3.2:3b"
      "llama3.1:8b"
      "qwen2.5-coder:1.5b-base"
      "nomic-embed-text:latest"
    ];
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_FLASH_ATTENTION = "1";
    };
  };
}
