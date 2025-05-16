{ config, pkgs, ... }:

{
  environment.systemPackages = [
	pkgs.polybar
	pkgs.bspwm
    pkgs.sxhkd
  ];

  # Enable the X11 windowing system and bspwm  
  services.xserver = {
    enable = true;

	#videoDrivers = [ "intel" ];

    windowManager.bspwm.enable = true;
	windowManager.bspwm.configFile = "/etc/nixconfig/bspwm/bspwmrc";
    windowManager.bspwm.sxhkd.package = pkgs.sxhkd;
    windowManager.bspwm.sxhkd.configFile = "/etc/nixconfig/bspwm/sxhkdrc";

    xkb = {
      layout = "au";
      variant = "";
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; 
  };
}
