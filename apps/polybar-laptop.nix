{ config, pkgs, ... }:

let
  polybarDir = "${config.home.homeDirectory}/.config/polybar";
  gruvboxColors = {
    background = "#282828";
    foreground = "#ebdbb2";
    primary    = "#fabd2f";
    secondary  = "#83a598";
    urgent     = "#fb4934";
    gray       = "#a89984";
    black      = "#1d2021";
  };
in {
  home.packages = with pkgs; [ polybar ];

  # Polybar config.ini written inline
  home.file."${polybarDir}/config.ini".text = ''
      [colors]
      background = ${gruvboxColors.background}
      foreground = ${gruvboxColors.foreground}
      primary    = ${gruvboxColors.primary}
      secondary  = ${gruvboxColors.secondary}
      urgent     = ${gruvboxColors.urgent}
      gray       = ${gruvboxColors.gray}
      black      = ${gruvboxColors.black}

      [bar/main]
      width = 100%
      height = 28pt
	  radius = 6

	  border-size = 4pt
	  border-color = #00000000
      
	  background = ${gruvboxColors.background}
      foreground = ${gruvboxColors.foreground}
      
	  font-0 = "JetBrainsMono NFM:style=Regular:size=12;2"
      
	  modules-left = bspwm active-window
      modules-center = 
      modules-right = volume battery wlan date
	  
	  line-size = 3pt
	  
	  padding-left = 0
	  padding-right = 1
	  module-margin = 1
	  separator = |

      [module/bspwm]
      type = internal/bspwm

	  ws-icon-0 = discord;
	  ws-icon-1 = 1;1
	  ws-icon-2 = 2;2
	  ws-icon-3 = 3;3
	  ws-icon-4 = 4;4
	  ws-icon-5 = 5;5
	  ws-icon-6 = 6;6
	  ws-icon-7 = 7;7
	  ws-icon-8 = 8;8
	  ws-icon-9 = 9;9


      label-focused = %icon%
      label-focused-foreground = ${gruvboxColors.primary}
      label-focused-background = ${gruvboxColors.black}
	  label-focused-padding = 1

      label-occupied = %icon%
      label-occupied-foreground = ${gruvboxColors.foreground}
      label-occupied-padding = 1

	  label-urgent = %icon%
      label-urgent-foreground = ${gruvboxColors.urgent}
      label-urgent-padding = 1 

	  label-empty = 
      label-empty-padding = 1 
	 
	  pin-workspaces = true

	  label-separator =  
	  label-separator-padding = 2

      [module/active-window]
      type = internal/xwindow
      label = %title%
      label-maxlen = 60
      label-empty = Desktop
      label-empty-foreground = ${gruvboxColors.gray}

      [module/volume]
  	  type = custom/script
  	  tail = true
  	  exec = pulseaudio-control --node-nicknames-from "device.description" --node-nickname "alsa_output.pci-0000_00_1b.0.analog-stereo:  Speakers" --node-nickname "alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo:  Headphones" listen
  	  label = %output%
	  label-foreground = ${gruvboxColors.foreground}

      [module/battery]
      type = internal/battery
      battery = BAT0
      adapter = AC
	  full-at = 99
	  low-at = 5

      label-charging-foreground = ${gruvboxColors.primary}
      label-full-foreground = ${gruvboxColors.secondary}
      label-discharging-foreground = ${gruvboxColors.foreground}

	  time-format = %H:%M

	  format-charging = <animation-charging> <label-charging>
	  format-discharging = <ramp-capacity> <label-discharging>
	  format-full = <ramp-capacity> <label-full>
	  format-low = <label-low> <animation-low>

	  label-charging = %percentage%%
	  label-discharging = %percentage%%
	  label-full = Fully charged
	  label-low = BATTERY LOW


	  ramp-capacity-0 = 
	  ramp-capacity-1 = 
	  ramp-capacity-2 = 
	  ramp-capacity-3 = 
	  ramp-capacity-4 = 

	  bar-capacity-width = 10

	  animation-charging-0 = 
	  animation-charging-1 = 
	  animation-charging-2 = 
	  animation-charging-3 = 
	  animation-charging-4 = 
	  animation-charging-framerate = 750

	  animation-discharging-0 = 
	  animation-discharging-1 = 
	  animation-discharging-2 = 
	  animation-discharging-3 = 
	  animation-discharging-4 = 
	  animation-discharging-framerate = 500

	  animation-low-0 = !
	  animation-low-1 = 
	  animation-low-framerate = 200

      [module/storage]
      type = internal/fs
      mount-0 = /
	  interval = 10
	  fixed-values = true
	  warn-percentage = 75
	  
	  format-mounted = <label-mounted>
	  format-unmounted = <label-unmounted>

      label-mounted =   %free% / %total%

	  label-unmounted = %mountpoint%: not mounted
	  label-unmounted-foreground = #55

      [module/date]
      type = internal/date
      interval = 5
      date = "%a %d %b %H:%M"
      label =  %date%
      label-foreground = ${gruvboxColors.secondary}

	  [network-base]
	  type = internal/network

	  interval = 5

	  format-connected = <label-connected>
	  format-disconnected = <label-disconnected>
	  label-disconnected = %{F#F0C674}%ifname%%{F#707880} disconnected

	  [module/wlan]
	  inherit = network-base

	  interface-type = wireless
	  label-connected = %essid% %local_ip%

	  [module/eth]
	  inherit = network-base

	  interface-type = wired
	  label-connected = %{F#F0C674}%ifname%%{F-} %local_ip%
	'';

  # Polybar launcher script
  home.file."${polybarDir}/launch.sh" ={
	text = ''
		#!/usr/bin/env sh

		# Terminate already running bar instances
		killall -q polybar

		# Wait until the processes have been shut down
		while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

		# Launch polybar for all monitors
    	polybar -c ~/.config/polybar/config.ini main &
  	'';
	executable = true;
  };
}

