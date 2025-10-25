{ config, pkgs, ... }:

{
	home.file."${config.xdg.configHome}/rofi/config.rasi".source = /etc/nixconfig/configfiles/rofi-config.rasi;
	home.file."${config.xdg.configHome}/rofi/gruvbox-material.rasi".source = /etc/nixconfig/configfiles/rofi-theme.rasi;
	home.file."${config.xdg.configHome}/rofi/scripts/rofi-power-menu" = { 
		source = /etc/nixconfig/scripts/rofi/rofi-power-menu;
		executable = true;
	};

}

