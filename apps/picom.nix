{ config, pkgs, ... }:

{
	home.file."${config.xdg.configHome}/picom/picom.conf".source = /etc/nixconfig/configfiles/picom.conf;

}
