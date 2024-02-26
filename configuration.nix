# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.eduardo = {
    isNormalUser = true;
    description = "eu";
    extraGroups = [ "network-manager" "wheel" ];
  };

  security.sudo.extraRules = [
    {
      users = [ "eduardo" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
   
    useGlobalPkgs = true;

    users = {
      "eduardo" = import ./home.nix;
    };
  };

  wsl.enable = true;
  wsl.defaultUser = "eduardo";
  wsl.nativeSystemd = true;
  
  # networking.hostName = "DESKTOP-A64068I";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  
}
