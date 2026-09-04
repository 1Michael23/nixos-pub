{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = false;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };

    nvidia = {
      open = false;
      nvidiaSettings = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # quadro p5000 not supported anymore
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];

  # Quadro P5000 = Pascal, CC 6.1. CUDA 12.9 drops 6.1 from its default
  # capabilities, so pin it here for ollama-cuda (and any CUDA source builds).
  nixpkgs.config.cudaCapabilities = [ "6.1" ];
}
