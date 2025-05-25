{ config, pkgs, lib, ... }:

{
	programs.zsh = {
    	enable = true;
      	enableCompletion = true;
      	autosuggestion.enable = true;
      	syntaxHighlighting.enable = true;

      	shellAliases = {
        	ll = "ls -l";
        	update = "sudo nixos-rebuild switch -I nixos-config=/etc/nixconfig";
			upgrade = "sudo nixos-rebuild switch -I nixos-config=/etc/nixconfig --upgrade";
			cd = "z";
			sesh = "~/projects/scripts/sesh.sh";
      	};
      	history = {
        	size = 10000;
      	};
      	initExtra = ''
      		# Enable oh-my-posh
        	eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/conf.toml)"

        	# ----- FZF -----

			# Set up fzf keybinds
			eval "$(fzf --zsh)"

			# use fd for fzf
			export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
			export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
			export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

			# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
			# - The first argument to the function ($1) is the base path to start traversal
			# - See the source code (completion.{bash,zsh}) for the details.
			_fzf_compgen_path() {
				fd --hidden --exclude .git . "$1"
			}

			# Use fd to generate the list for directory completion
			_fzf_compgen_dir() {
				fd --type=d --hidden --exclude .git . "$1"
			}

			source ~/fzf-git.sh/fzf-git.sh

			export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
			export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

			# Advanced customization of fzf options via _fzf_comprun function
			# - The first argument to the function is the name of the command.
			# - You should make sure to pass the rest of the arguments to fzf.
			_fzf_comprun() {
	  			local command=$1
	  			shift

	  			case "$command" in
	    			cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
	    			export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
	    			ssh)          fzf --preview 'dig {}'                   "$@" ;;
	    			*)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
	  			esac
			}

			# ----- Bat (better cat) -----

			export BAT_THEME=gruvbox-dark

			# ---- Eza (better ls) -----

			alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

			# ---- Zoxide (better cd) ----
			eval "$(zoxide init zsh)"

			export PATH=~/.local/bin:$PATH

			nerdfetch
      '';
	};
  
	
	home.file."${config.xdg.configHome}/ohmyposh/conf.toml".source = /etc/nixconfig/configfiles/poshconf.toml;
	
	programs.oh-my-posh = {
    	enable = true;                                                                                                           
      	enableZshIntegration = true;                                                                                            
    };
}
