{ config, pkgs, ... }:

let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
	hostname = config.networking.hostName;

	polybar = if hostname == "nixos-desktop" then
		./apps/polybar-desktop.nix
	else if hostname == "nixos-laptop" then
		./apps/polybar-laptop.nix
	else
		./apps/polybar-laptop.nix; # fallback

in

{
	imports = [
		(import "${home-manager}/nixos")
	];

	home-manager.users.hamish = {
		/* The home.stateVersion option does not have a default and must be set */
		home.stateVersion = "24.11";

		home.file.".mozilla/firefox/yourprofile.default-release/chrome/userChrome.css".source = ./themes/Firefox-Mod-Blur/userChrome.css;

		fonts.fontconfig.enable = true;

		home.packages = with pkgs; [
			# Core tools
			wget
			tmux
			git

			# Terminal enhancements
			oh-my-posh
			fd
			eza
			bat
			zoxide
			fzf
			thefuck
			git-credential-manager

			# Fetch tools
			nerdfetch
			freshfetch
			jp2a

			# Utilities
			bc
			zip
			unzip

			# File managers
			nemo

			# Audio
			pavucontrol

			# Applications
			spotify
			discord
			libreoffice-qt6
			dbeaver-bin
			vscodium
			sabnzbd
			localsend
			deluge
			nzbget
			vlc
			postman
			termius
			darktable
			gparted

			# Development tools
			redis
			postgresql
			infisical
			shellify
			ansible
			cloudflared
			kubectl
			kubernetes-helm
			openssl

			# Fonts
			(pkgs.nerdfonts.override {
				fonts = [
					"FiraCode"
					"JetBrainsMono"
				];
			})
		];

		imports = [
			./apps/kitty.nix
			./apps/zsh.nix
			./apps/neovim.nix
			./apps/gtk.nix
			./apps/neofetch.nix
			./apps/picom.nix
			./apps/tmux.nix
			./apps/rofi.nix

			polybar
		];

	};
}
