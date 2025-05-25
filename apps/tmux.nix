{ config, pkgs, lib, ... }:

{
	home.file."${config.xdg.configHome}/tmux/tmux.conf".source = /etc/nixconfig/configfiles/tmux.conf;
}
