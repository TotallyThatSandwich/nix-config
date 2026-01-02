{ config, pkgs, ... }:

let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
	hostname = config.networking.hostName;

	# Common packages shared across all hosts
	commonPackages = with pkgs; [
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

		# Fonts
		pkgs.nerd-fonts.fira-code
		pkgs.nerd-fonts.jetbrains-mono
	];

	# Desktop-specific packages
	desktopPackages = with pkgs; [
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
	];

	# Laptop-specific packages
	laptopPackages = with pkgs; [
		# File managers
		nemo

		# Audio
		pavucontrol

		# Applications
		spotify
		discord
		libreoffice-qt6
		vscodium
		localsend
		vlc

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
	];

	# WSL-specific packages (CLI only, no GUI apps)
	wslPackages = with pkgs; [
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
	];

	# Select packages based on hostname
	hostnamePackages = if hostname == "nixos-desktop" then
		desktopPackages
	else if hostname == "nixos-laptop" then
		laptopPackages
	else if hostname == "nixos-wsl" then
		wslPackages
	else
		[]; # fallback to no additional packages

	# Select polybar config based on hostname
	polybar = if hostname == "nixos-desktop" then
		./apps/polybar-desktop.nix
	else if hostname == "nixos-laptop" then
		./apps/polybar-laptop.nix
	else
		./apps/polybar-laptop.nix; # fallback

	# Common imports for all hosts
	commonImports = [
		./apps/kitty.nix
		./apps/zsh.nix
		./apps/neovim.nix
		./apps/gtk.nix
		./apps/neofetch.nix
		./apps/tmux.nix
	];

	# WSL-specific common imports (no GTK)
	wslCommonImports = [
		./apps/kitty.nix
		./apps/zsh.nix
		./apps/neovim.nix
		./apps/neofetch.nix
		./apps/tmux.nix
	];

	# Desktop-specific imports
	desktopImports = [
		./apps/picom.nix
		./apps/rofi.nix
		polybar
	];

	# Laptop-specific imports
	laptopImports = [
		./apps/picom.nix
		./apps/rofi.nix
		polybar
	];

	# WSL-specific imports (no window manager components)
	wslImports = [
		# WSL doesn't need picom, rofi, or polybar
	];

	# Select common imports based on hostname
	selectedCommonImports = if hostname == "nixos-wsl" then
		wslCommonImports
	else
		commonImports;

	# Select imports based on hostname
	hostnameImports = if hostname == "nixos-desktop" then
		desktopImports
	else if hostname == "nixos-laptop" then
		laptopImports
	else if hostname == "nixos-wsl" then
		wslImports
	else
		[]; # fallback

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

		# Combine common and hostname-specific packages
		home.packages = commonPackages ++ hostnamePackages;

		# Combine common and hostname-specific imports
		imports = selectedCommonImports ++ hostnameImports;
	};
}
