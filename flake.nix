{
  description = "Nemu Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        deps = with pkgs; [
          git
          gnumake
          cmake
          zig_0_13
          zls
        ];
      in
      {
        legacyPackages = pkgs;
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          buildInputs = [ deps ];
          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.ncurses
            pkgs.readline
          ];
          shellHook = "";
        };
      }
    )
    // {
      inherit inputs;
    };
}
