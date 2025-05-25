{ config, pkgs, ... }:

{
	home.file."${config.xdg.configHome}/neofetch/config.conf".source = /etc/nixconfig/configfiles/neofetchconfig.conf;

}
