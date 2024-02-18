{ nixpkgs ? import <nixpkgs> { } }:

let
  cyclonedx-cli = nixpkgs.buildDotnetModule rec {
    pname = "cyclonedx-cli";
    version = "0.25.0";
    src = nixpkgs.fetchFromGitHub {
      owner = "CycloneDX";
      repo = "cyclonedx-cli";
      rev = "v${version}";
      hash = "sha256-kAMSdUMr/NhsbMBViFJQlzgUNnxWgi/CLb3CW9OpWFo=";
    };

    dotnet-sdk = nixpkgs.dotnetCorePackages.sdk_6_0;
    dotnet-runtime = nixpkgs.dotnetCorePackages.runtime_6_0;
    projectFile = "src/cyclonedx/cyclonedx.csproj";
    nugetDeps = ./deps.nix;
    executables = [ "cyclonedx" ];
  };
in nixpkgs.mkShell {
  buildInputs = [
    cyclonedx-cli
    nixpkgs.cargo-cyclonedx
    nixpkgs.poetry
    nixpkgs.rustfmt
    nixpkgs.rustup
    nixpkgs.trivy
    nixpkgs.yapf
  ];
}
