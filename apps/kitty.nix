{ config, pkgs, ... }:

{
    programs.kitty = {
      enable = true;
      settings = {
		  dynamic_background_opacity = true;
          enable_audio_bell = false;
      	  confirm_os_window_close = -1;
		  background_opacity = "0.9";
          background_blur = 5;
		
		  font_family = "JetBrainsMono Nerd Font";
		  bold_font = "auto";
		  italic_font = "auto";
		  bold_italic_font = "auto";

	  	  foreground = "#ebdbb2";
	  	  background = "#282828";

	  	  selection_foreground = "#655b53";
	  	  selection_background = "#ebdbb2";
	  	  
		  url_color = "#d65c0d";

	  	  color0 = "#272727";
	  	  color8 = "#928373";

	  	  color1 = "#cc231c";
	  	  color9 = "#fb4833";
 
	  	  color2 = "#989719";
	  	  color10 = "#b8ba25";
	  
	  	  color3 = "#d79920";
	  	  color11 = "#fabc2e";

	  	  color4 = "#448488";
		  color12 = "#83a597";

		  color5 = "#b16185";
		  color13 = "#d3859a";
	  
		  color6 = "#689d69";
		  color14 = "#8ec07b";

		  color7 = "#a89983";
		  color15 = "#ebdbb2";
	  };
    };
}

