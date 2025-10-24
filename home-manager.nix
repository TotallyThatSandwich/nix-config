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
      		kitty
	  		zsh 
      		oh-my-posh
      		fd
      		eza
      		bat
      		zoxide
	  		fzf
	  		thefuck
      		git-credential-manager
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
