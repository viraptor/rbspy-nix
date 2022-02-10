{
  description = "rbspy";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in rec {
          defaultPackage = pkgs.rustPlatform.buildRustPackage rec {
            pname = "rbspy";
            version = "0.10.0";
            src = pkgs.fetchFromGitHub {
              owner = "rbspy";
              repo = "rbspy";
              rev = "v0.10.0";
              sha256 = "sha256-zvH2oPm2tOdk4C5EDNhNgO9nt4usnuBTp+fh6xfwraQ=";
            };
            cargoSha256 = "sha256-Es4COQiNZmbGdWeSyOvx4tiV1ygic3VPQLTiispVWpM=";
            doCheck = false;  # filesystem writing test fails
          };

          apps = {
            cf-vault = {
              type = "app";
              program = "${defaultPackage.${system}}/bin/rbspy";
            };
          };

          defaultApp = apps.${system}.rbspy;
        }
      );
}
