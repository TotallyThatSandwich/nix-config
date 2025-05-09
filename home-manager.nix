{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in

{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.hamish = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.11";
    home.packages = [ 
      pkgs.zsh 
      pkgs.oh-my-posh
      pkgs.fd
      pkgs.eza
      pkgs.bat
      pkgs.zoxide
      pkgs.git-credential-manager
      #pkgs.neovim
    ];
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch -I nixos-config=/etc/nixconfig";
	cd = "z";
	sesh = "/home/hamish/Projects/scripts/sesh.sh";
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
      '';
    };
  

    programs.oh-my-posh = {
      enable = true;                                                                                                           
      useTheme = "atomic";                                                                                                     
      enableZshIntegration = true;                                                                                            
    };

    programs.kitty = {
      enable = true;
      settings = {
      	  confirm_os_window_close = -1;
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
    programs.neovim = {
      enable = true;
      
      viAlias = true;
      vimAlias = true;
      #vimdiffAlias = true;i

      extraPackages = with pkgs; [
        lua-language-server
        nil

        xclip
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; [
      	nvim-lspconfig
        fzf-lua
	bufferline-nvim

	cmp_luasnip
        cmp-nvim-lsp
	nvim-cmp
	neodev-nvim
	luasnip
	lualine-nvim
	lualine-lsp-progress
	{
	  plugin = nvim-tree-lua;

	}
	{
          plugin = gruvbox-nvim;
          config = "colorscheme gruvbox";
        }
	{
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-json
	    p.tree-sitter-rust
          ]));
        }

      ];

      extraLuaConfig = ''
      	${builtins.readFile ./nvim/options.lua}
	${builtins.readFile ./nvim/plugin/nvim-tree.lua}
        ${builtins.readFile ./nvim/plugin/fzf-lua.lua}
	${builtins.readFile ./nvim/plugin/bufferline.lua}
	${builtins.readFile ./nvim/plugin/lsp.lua}
	${builtins.readFile ./nvim/plugin/treesitter.lua}
	${builtins.readFile ./nvim/plugin/cmp.lua}
	${builtins.readFile ./nvim/plugin/lua-line.lua}
      '';
    };
  };
}
