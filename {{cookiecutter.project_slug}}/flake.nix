{
  description = "{{ cookiecutter.project_slug }} - {{ cookiecutter.description }}";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "uv2nix/nixpkgs";
      # inputs.uv2nix.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "uv2nix/nixpkgs";
      # inputs.uv2nix.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      # stale nixpkgs is missing the alias `lib.match` -> `builtins.match`
      # therefore point uv2nix to a patched nixpkgs, which introduces this alias
      # this is a temporary solution until nixpkgs us up-to-date again
      inputs.nixpkgs.url = "github:runtimeverification/nixpkgs/libmatch";
      # inputs.uv2nix.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, pyproject-nix, pyproject-build-systems, uv2nix }:
  let
    pythonVer = "310";
  in flake-utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system:
    let
      # due to the nixpkgs that we use in this flake being outdated, uv is also heavily outdated
      # we can instead use the binary release of uv provided by uv2nix for now
      uvOverlay = final: prev: {
        uv = uv2nix.packages.${final.system}.uv-bin;
      };
      {{ cookiecutter.project_slug }}Overlay = final: prev: {
        {{ cookiecutter.project_slug }} = final.callPackage ./nix/{{ cookiecutter.project_slug }} {
          inherit pyproject-nix pyproject-build-systems uv2nix;
          python = final."python${pythonVer}";
        };
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          uvOverlay
          {{ cookiecutter.project_slug }}Overlay
        ];
      };
      python = pkgs."python${pythonVer}";
    in {
      devShells.default = pkgs.mkShell {
        name = "uv develop shell";
        buildInputs = [
          python
          pkgs.uv
        ];
        env = {
          # prevent uv from managing Python downloads and force use of specific 
          UV_PYTHON_DOWNLOADS = "never";
          UV_PYTHON = python.interpreter;
        };
        shellHook = ''
          unset PYTHONPATH
        '';
      };
      packages = rec {
        inherit (pkgs) {{ cookiecutter.project_slug }};
        default = {{ cookiecutter.project_slug }};
      };
    }) // {
      overlays.default = final: prev: {
        inherit (self.packages.${final.system}) {{ cookiecutter.project_slug }};
      };
    };
}
