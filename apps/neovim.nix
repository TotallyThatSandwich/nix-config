{ config, pkgs, ... }:

{
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

			indent-blankline-nvim
			neogit
			nvim-comment

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

			${builtins.readFile ./nvim/plugin/other.lua}
      	'';
    };
}
