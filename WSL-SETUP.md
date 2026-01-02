# WSL Setup Guide

This guide explains how to replicate this NixOS configuration on Windows Subsystem for Linux (WSL).

## Overview

WSL differs from a full NixOS installation in several ways:
- No bootloader or kernel configuration needed
- Limited/no GUI support (unless using WSLg)
- Different hardware integration
- Windows filesystem integration

## Two Approaches

### Option 1: NixOS-WSL (Recommended)

This gives you a full NixOS system running in WSL.

#### Installation

1. **Install WSL on Windows**
   ```powershell
   wsl --install
   ```

2. **Download NixOS-WSL**
   - Download the latest release from: https://github.com/nix-community/NixOS-WSL
   - Extract `nixos-wsl.tar.gz`

3. **Import into WSL**
   ```powershell
   wsl --import NixOS $env:USERPROFILE\NixOS nixos-wsl.tar.gz
   wsl -d NixOS
   ```

4. **Clone this repository**
   ```bash
   git clone https://github.com/TotallyThatSandwich/nix-config.git ~/nix-config
   cd ~/nix-config
   ```

5. **Create WSL-specific configuration**

   Create a new file `wsl.nix`:
   ```nix
   { config, pkgs, lib, ... }:

   {
     wsl = {
       enable = true;
       defaultUser = "hamish";
       startMenuLaunchers = true;

       # Enable integration with Windows
       wslConf = {
         automount.root = "/mnt";
         network.generateHosts = false;
         network.generateResolvConf = true;
       };
     };

     # Time zone
     time.timeZone = "Australia/Melbourne";

     # Locale
     i18n.defaultLocale = "en_AU.UTF-8";

     # Core packages (GUI apps removed)
     environment.systemPackages = with pkgs; [
       wget
       curl
       tmux
       git

       # fetch tools
       neofetch
       nerdfetch
       freshfetch

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

       # Utilities
       zip
       unzip
       bc
     ];

     # Enable Zsh
     programs.zsh.enable = true;

     # User configuration
     users.users.hamish = {
       isNormalUser = true;
       extraGroups = [ "wheel" ];
       shell = pkgs.zsh;
     };

     # Allow unfree packages
     nixpkgs.config.allowUnfree = true;

     # System version
     system.stateVersion = "24.11";
   }
   ```

6. **Create WSL-specific home-manager config**

   Create `home-manager-wsl.nix`:
   ```nix
   { config, pkgs, ... }:

   let
     home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
   in

   {
     imports = [
       (import "${home-manager}/nixos")
     ];

     home-manager.users.hamish = {
       home.stateVersion = "24.11";

       fonts.fontconfig.enable = true;

       home.packages = with pkgs; [
         kitty  # Works with WSLg
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
         ./apps/neofetch.nix
         ./apps/tmux.nix
         # Note: Skip GUI-specific configs like bspwm, polybar, rofi, picom
       ];
     };
   }
   ```

7. **Create main WSL configuration file**

   Edit `/etc/nixos/configuration.nix`:
   ```nix
   { config, pkgs, ... }:

   {
     imports = [
       <nixos-wsl/modules>
       /home/hamish/nix-config/wsl.nix
       /home/hamish/nix-config/home-manager-wsl.nix
       /home/hamish/nix-config/virtualisation.nix  # If you want Docker/VMs
     ];
   }
   ```

8. **Apply configuration**
   ```bash
   sudo nixos-rebuild switch
   ```

### Option 2: Home-Manager Standalone

Use home-manager without full NixOS system management. Good if you want to keep the default Ubuntu/Debian WSL.

#### Installation

1. **Install Nix package manager**
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Install home-manager**
   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
   nix-channel --update
   nix-shell '<home-manager>' -A install
   ```

3. **Clone and configure**
   ```bash
   git clone https://github.com/TotallyThatSandwich/nix-config.git ~/nix-config
   ```

4. **Create standalone home-manager config**

   Create `~/.config/home-manager/home.nix`:
   ```nix
   { config, pkgs, ... }:

   {
     home.username = "your-username";
     home.homeDirectory = "/home/your-username";
     home.stateVersion = "24.11";

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
       neofetch
       redis
       postgresql
       kubectl
       kubernetes-helm
       (pkgs.nerdfonts.override {
         fonts = [
           "FiraCode"
           "JetBrainsMono"
         ];
       })
     ];

     imports = [
       /home/your-username/nix-config/apps/kitty.nix
       /home/your-username/nix-config/apps/zsh.nix
       /home/your-username/nix-config/apps/neovim.nix
       /home/your-username/nix-config/apps/neofetch.nix
       /home/your-username/nix-config/apps/tmux.nix
     ];

     programs.home-manager.enable = true;
   }
   ```

5. **Apply configuration**
   ```bash
   home-manager switch
   ```

## What Works and What Doesn't in WSL

### ✅ Works Great
- Terminal emulators (kitty with WSLg)
- CLI tools (zsh, tmux, neovim, git)
- Development tools (docker, kubernetes, databases)
- Nerd fonts
- Most CLI utilities

### ⚠️ Limited/Modified Functionality
- GUI applications (need WSLg enabled on Windows 11)
- X server applications (need VcXsrv or similar)
- Hardware access (Bluetooth, GPU)

### ❌ Doesn't Work
- Window managers (bspwm, i3, etc.)
- Desktop environments (KDE Plasma, GNOME)
- Display managers (sddm, gdm)
- Bootloader configuration
- Kernel modules
- Audio (PipeWire/PulseAudio) - use Windows audio
- Brightness controls

## GUI Applications in WSL

If you want GUI apps on Windows 11:

1. **Enable WSLg** (built-in on Windows 11)
   - GUI apps should work automatically

2. **For Windows 10** - Use VcXsrv:
   ```bash
   # Download and run VcXsrv on Windows
   # Add to ~/.zshrc or ~/.bashrc:
   export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
   ```

## Configuration Tips

### File System Integration
```bash
# Windows drives are at /mnt/c, /mnt/d, etc.
# Keep projects in Linux filesystem for better performance:
~/projects  # Good
/mnt/c/Users/YourName/projects  # Slower
```

### Git Configuration
```nix
# Add to home-manager config for better Windows integration:
programs.git = {
  enable = true;
  extraConfig = {
    core.autocrlf = "input";
    credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
  };
};
```

### Docker in WSL
Enable Docker Desktop's WSL2 backend or use the virtualisation.nix configuration with modifications.

## Recommended Workflow

1. Use NixOS-WSL (Option 1) for full reproducibility
2. Keep GUI apps on Windows
3. Run development tools in WSL
4. Use Windows Terminal with WSL profile
5. Keep files in WSL filesystem for performance

## Troubleshooting

### DNS Issues
```nix
# In wsl.nix:
wsl.wslConf.network.generateResolvConf = false;
```
Then manually set DNS in `/etc/resolv.conf`.

### Systemd Services
NixOS-WSL supports systemd, but some services may need modification.

### Performance
- Keep files in Linux filesystem (~/), not /mnt/c
- Use WSL2, not WSL1
- Allocate enough RAM in .wslconfig

## Further Resources

- [NixOS-WSL Documentation](https://github.com/nix-community/NixOS-WSL)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
