{
  description = "Zig compiler development.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    # Used for shell.nix
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "zig-ashet";

          version = "0.13.1-ashet";

          buildInputs = [
              pkgs.zig
              pkgs.pkgsStatic.libxml2
              pkgs.pkgsStatic.zlib
              pkgs.pkgsStatic.xz
              pkgs.pkgsStatic.llvmPackages_18.clang
              pkgs.pkgsStatic.llvmPackages_18.clang-unwrapped
              pkgs.pkgsStatic.llvmPackages_18.lld
              pkgs.pkgsStatic.llvmPackages_18.libllvm
            ];
          
          env = { 
              ZIG_GLOBAL_CACHE_DIR = "$TMPDIR/zig-cache";
          };

          src = builtins.filterSource
            (path: type: !(type == "directory" && ((baseNameOf path == ".zig-cache") || (baseNameOf path == "build"))))
            ./.;

          configurePhase = "";

          buildPhase = ''
            zig build                                   \
              --prefix $out                             \
              --search-prefix "$(llvm-config --libdir)/.." \
              --zig-lib-dir "$(realpath lib)"           \
              -Dtarget=x86_64-linux-musl                \
              -Dstatic-llvm                             \
              -Doptimize=ReleaseFast                    \
              -Dno-langref                              \
              -Denable-llvm                             \
              -Dversion-string=0.13.1-ashet
          '';          
          
          installPhase = "";

          hardeningDisable = ["all"];
        };
        # packages.default = ((pkgs.pkgsStatic.zig.override {
        #   llvmPackages = pkgs.pkgsStatic.llvmPackages_18;
        # }).overrideAttrs (old: {
        #     buildInputs = old.buildInputs ++ [pkgs.pkgsStatic.libtinfo];
        #     version = "0.13.1-ashetos";
        #     src = ./.;

        #     postPatch = ""; # disable nix patching
        #     postBuild = ""; # disable langref
        #     postInstall = ""; # disable langref
        #     fixupPhase = ""; 
        #     outputs = ["out"]; # remove langref
        # }));
      }
    );
}
