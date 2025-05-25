{ config, pkgs, ... }:

{
	gtk = {
    	enable = true;

    	theme = {
      		name = "Gruvbox-Dark";
      		package = pkgs.gruvbox-gtk-theme;
    	};

    	iconTheme = {
      		name = "Gruvbox-Dark";
      		package = pkgs.gruvbox-dark-icons-gtk;
    	};

    	gtk3.extraConfig = {
      		gtk-application-prefer-dark-theme = true;
    	};
    	gtk4.extraConfig = {
      		gtk-application-prefer-dark-theme = true;
    	};
  	};
	home.sessionVariables = {
    	GTK_THEME = "Gruvbox-Dark";
    	GDK_THEME = "dark";  # Some apps check this
  	};

}
