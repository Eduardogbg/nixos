{ config, pkgs, inputs, lib, ... }:

{

  programs.git = {
    enable = true;
    userName = "Eduardo Bonilha";
    userEmail = "eduardogbg@gmail.com";
    extraConfig = {
      init = {
      	defaultBranch = "main";
      };
    };
  };

  programs.neovim = {
    enable = true;
    
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = builtins.readFile ./init.vim;

    plugins = let
      fromGitHub = ref: repo: pkgs.vimUtils.buildVimPlugin {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = ref;
        src = builtins.fetchGit {
          url = "https://github.com/${repo}.git";
          ref = ref;
        };
      };
    in
    with pkgs.vimPlugins; [
      {
        plugin = cornelis;
      	config = "let g:cornelis_use_global_library = 1";
      }
    ];

    extraPackages = [ pkgs.cornelis ];
  };
  
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash.enable = true;

  home.packages = with pkgs; [];

  home.file = with pkgs; {
    # ".emacs.d" = {
    #   source = fetchFromGitHub {
    #     owner = "doomemacs";
    #     repo = "doomemacs";
    #     rev = "98d753e1036f76551ccaa61f5c810782cda3b48a";
    #     hash = "sha256-HbWLLaNhGbAkaHCb0nXwE4YpVfbKF4fHxux49jdJ+Go=";
    #   };
    # };
  };
  # ---

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eduardo";
  home.homeDirectory = "/home/eduardo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # home.packages = [
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
  # ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  #home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  #};

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
