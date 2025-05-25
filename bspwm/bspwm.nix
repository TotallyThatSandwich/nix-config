{ config, pkgs, ... }:

{
  environment.systemPackages = [
	pkgs.polybar
	pkgs.bspwm
    pkgs.sxhkd
	pkgs.picom
	pkgs.feh
    pkgs.scrot
    pkgs.xclip
	pkgs.dunst
    pkgs.libnotify
	pkgs.rofi
  ];

  # Enable the X11 windowing system and bspwm  
  services.xserver = {
	#videoDrivers = [ "intel" ];

    windowManager.bspwm.enable = true;
	windowManager.bspwm.configFile = "/etc/nixconfig/bspwm/bspwmrc";
    windowManager.bspwm.sxhkd.package = pkgs.sxhkd;
    windowManager.bspwm.sxhkd.configFile = "/etc/nixconfig/bspwm/sxhkdrc";
  };
  
}
