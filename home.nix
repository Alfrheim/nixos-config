#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ./modules/programs/alacritty.nix
    ];


  home = {                                        
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      # Terminal
      neofetch
      pfetch
      enpass
      zathura
      p7zip
      mplayer
      openvpn
      redshift
      blueman
      spotify
      flameshot

      albert
      dmenu
      copyq
      conky
      compton
      arandr
      feh
      gnomeExtensions.caffeine
      i3lock-pixeled
      pasystray

      pamixer
      guake
      gxkb

      pavucontrol
      rofi
      sysstat
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-dropbox-plugin
      xorg.xkill
      xorg.xbacklight

      remmina
      telegram-cli
      signal-desktop


      jetbrains.idea-ultimate
      jetbrains.rider
      jetbrains.webstorm
      jetbrains.datagrip

      qutebrowser
      opera
      google-chrome
      nodejs
    ];
    stateVersion = "22.05";
  };

  programs = {
    alacritty = {                                 # Terminal Emulator
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zsh = {                                       # Post installation script is run in configuration.nix to make it default shell
      enable = true;
      enableAutosuggestions = true;               # Auto suggest options and highlights syntact, searches in history for options
      enableSyntaxHighlighting = true;
      history.size = 10000;
      enableCompletion = true;
      autocd = true;
      cdpath = ["~/Work" "~/Projects" "~/tmp"];
      initExtraFirst = ''
        nixify() {
        if [ ! -e ./.envrc ]; then
        echo "use nix" > .envrc
        direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
        cat > default.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
        nativeBuildInputs = [
        bashInteractive
        ];
        }
        EOF
        ${EDITOR:-vim} default.nix
        fi
        }
        flakify() {
        if [ ! -e flake.nix ]; then
        nix flake new -t github:nix-community/nix-direnv .
        elif [ ! -e .envrc ]; then
        echo "use flake" > .envrc
        direnv allow
        fi
        ${EDITOR:-vim} flake.nix
        }
      '';

      oh-my-zsh = {                               # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };


      initExtra = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
        pfetch
      '';                                         # Zsh theme
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [

        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace                             # Opens document where you left it
        auto-pairs                                # Print double quotes/brackets/etc.
        vim-gitgutter                             # See uncommitted changes of file :GitGutterEnable

        # File Tree
        nerdtree                                  # File Manager - set in extraConfig to F6

        # Customization 
        wombat256-vim                             # Color scheme for lightline
        srcery-vim                                # Color scheme for text

        lightline-vim                             # Info bar at bottom
        indent-blankline-nvim                     # Indentation lines
      ];

      extraConfig = ''
        syntax enable                             " Syntax highlighting
        colorscheme srcery                        " Color scheme text

        let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ }                                     " Color scheme lightline

        highlight Comment cterm=italic gui=italic " Comments become italic
        hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme
        
        set number                                " Set numbers

        nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
      '';
    };
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
      ];
    };
  };
}
