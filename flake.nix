{
  description = "x CLI project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "x";
          version = "6.0.0";
          src = ./.;
          cargoHash = "sha256-NnUBs6P0HLfDaBTLWgyef4sM7vDzzojoOEXNL5p6rMM=";
          buildInputs = with pkgs; [ openssl ];
          nativeBuildInputs = with pkgs; [ pkg-config rustc cargo ];
          OPENSSL_DIR = "${pkgs.openssl.out}";
          OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rustc
            cargo
            rustfmt
            clippy
            pkgconf
            openssl.dev
            openssl
          ];
          env = {
            OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
          };
        };
      }
    );
}
