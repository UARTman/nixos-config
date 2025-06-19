{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "uartman";
  home.homeDirectory = "/home/uartman";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/uartman/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      lsp = {
        enable = true;

        trouble.enable = true;
      };

      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix = {
          enable = true;
          lsp.server = "nixd";
          format.type = "nixfmt";
        };
        # markdown.enable = true; -- wait for nixpkgs deno fix
        lua.enable = true;
        lua.lsp.lazydev.enable = true;
      };

      statusline = {
        lualine = {
          enable = true;
          theme = "gruvbox";
          globalStatus = false;
          refresh.statusline = 500;
        };
      };

      tabline = {
        nvimBufferline.enable = true;
      };

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };

      autopairs.nvim-autopairs.enable = true;

      autocomplete.blink-cmp = {
        enable = true;
        setupOpts.completion.menu.auto_show = false;
      };

      filetree = {
        neo-tree = {
          enable = true;
        };
        nvimTree = {
          enable = true;
        };
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      telescope.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
        vim-fugitive.enable = true;
      };

      notify = {
        nvim-notify.enable = true;
      };

      terminal = {
        toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };

      comments = {
        comment-nvim.enable = true;
      };

      visuals = {
        nvim-scrollbar = {
          enable = true;
          setupOpts = {
            marks.Cursor.blend = 70;
            excluded_buftypes = ["terminal" "nofile"];
          };
        };
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;

        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      utility = {
        motion = {
          flash-nvim = {
            enable = true;
          };
        };
      };

      mini.surround.enable = true;

      ui.breadcrumbs.enable = true;
      ui.breadcrumbs.navbuddy.enable = true;

      options = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 8;
        softtabstop = 2;
      };

      keymaps = [
        {
          key = "<leader>T";
          mode = [
            "n"
            "v"
          ];
          action = ":ToggleTerm<CR>";
          desc = "ToggleTerm";
        }
        {
          key = "<Esc><Esc>";
          mode = [ "t" ];
          action = "<C-\\><C-n>";
          desc = "Exit terminal mode";
        }
        {
          key = "<leader>k";
          mode = [ "n" ];
          lua = true;
          action = "function() vim.diagnostic.open_float() end";
          desc = "Show diagnostic float";
        }
        {
          key = "<leader>nt";
          mode = [ "n" ];
          action = ":Neotree<CR>";
          desc = "Toggle Neotree";
        }
        {
          key = "<leader>bq";
          mode = [ "n" ];
          action = ":bdelete<CR>";
          desc = "Close buffer";
        }
      ];

      lazy.plugins = {
        "idris2-nvim" = {
          package = pkgs.vimPlugins.idris2-nvim;
          setupModule = "idris2";
          setupOpts = {
            server.settings.briefCompletions = true;
          };
        };
      };

    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
