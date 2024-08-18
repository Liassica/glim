{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        glim = pkgs.callPackage ./nix/package {
          theme = (pkgs.catppuccin-grub.override { flavor = "frappe"; }).outPath;
        };
        default = self.packages.${system}.glim;
      };
    };
}
