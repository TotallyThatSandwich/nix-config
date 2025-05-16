{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./steam.nix
      ./home-manager.nix
	  ./laptop.nix
	  ./bspwm/bspwm.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["ipv6.disable=1"];

  networking.hostName = "nixlaptop"; # Define your hostname.
  
  # Enable networking
  networking.enableIPv6 = false;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  environment.localBinInPath = true;
 
  environment.systemPackages = [
    pkgs.kitty
    pkgs.rofi
    pkgs.wget
    pkgs.tmux
    pkgs.git
    pkgs.nerdfetch
    pkgs.dunst
    pkgs.libnotify
    pkgs.pavucontrol
    pkgs.vesktop
    pkgs.neofetch
    pkgs.feh
    pkgs.scrot
    pkgs.xclip
	pkgs.bluez
	pkgs.bc
	pkgs.brightnessctl
	pkgs.polybar-pulseaudio-control
	pkgs.blueman
	pkgs.docker
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; 
  };


  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable Zsh
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hamish = {
    isNormalUser = true;
    description = "Hamish Mcdonald";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fontDir.enable = true;

  # Disale Firewall
  networking.firewall.enable = false;

  # System version
  system.stateVersion = "24.11";


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
