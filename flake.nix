{
  description = "A very basic flake";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
     home-manager = {
       url = github:nix-community/home-manager;
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        alfrheim = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alfrheim = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
        hmConfig = {
          alfrheim = home-manager.lib.homeManagerConfiguration {
            inherit system pkgs;
            username = "alfrheim";
            homeDirectory = "/home/alfrheim";
            configuration = {
              imports = [
                ./home.nix
              ];
            };
          };
        };
      };
    }; 

}
