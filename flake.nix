{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: somehow move this to home.nix
    cornelis = {
      url = "github:isovector/cornelis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # should create one for host name DESKTOP-A64068I (or even better:
      # change this desktop's host name!)
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          { nix.registry.nixpkgs.flake = nixpkgs; }
          ./configuration.nix
          inputs.NixOS-WSL.nixosModules.wsl
          inputs.home-manager.nixosModules.default
          { nixpkgs.overlays = [inputs.cornelis.overlays.cornelis]; }
	      ];
      };
    };
}

