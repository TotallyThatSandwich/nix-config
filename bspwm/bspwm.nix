{ config, pkgs, ... }:

let
  hostname = config.networking.hostName;

  bspwmrc = if hostname == "nixos-desktop" then
    /etc/nixconfig/bspwm/bspwmrc-desktop
  else if hostname == "nixos-laptop" then
    /etc/nixconfig/bspwm/bspwmrc-laptop
  else
    /etc/nixconfig/bspwm/bspwmrc-desktop; # fallback
	
  sxhkdrc = /etc/nixconfig/bspwm/sxhkdrc;
in
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
	windowManager.bspwm.configFile = bspwmrc;
    windowManager.bspwm.sxhkd.package = pkgs.sxhkd;
    windowManager.bspwm.sxhkd.configFile = sxhkdrc;
  };
  
}
