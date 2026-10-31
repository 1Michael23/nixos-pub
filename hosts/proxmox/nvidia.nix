{
  config,
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
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };

    nvidia = {
      open = false;
      nvidiaSettings = false;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # quadro p5000 not supported anymore
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];
}
