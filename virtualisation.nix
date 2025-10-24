{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ 
	virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = { # not needed in NixOS 25.11 since https://github.com/NixOS/nixpkgs/pull/421549
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
}
