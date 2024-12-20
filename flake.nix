{
  description = "A disko images example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, disko, nixpkgs }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ({ config, ... }: {
          # shut up state version warning
          system.stateVersion = config.system.nixos.version;

          disko.devices = {
            disk = {
              main = {
                device = "/dev/disk/by-id/some-disk-id";
                type = "disk";
                imageSize = "10G";
                content = {
                  type = "gpt";
                  partitions = {
                    ESP = {
                      type = "EF00";
                      size = "500M";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = [ "umask=0077" ];
                      };
                    };
                    root = {
                      size = "100%";
                      content = {
                        type = "filesystem";
                        format = "ext4";
                        mountpoint = "/";
                      };
                    };
                  };
                };
              };
            };
          };
        })
      ];
    };
  };
}
