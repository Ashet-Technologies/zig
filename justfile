build:
    zig build                                        \
        --prefix zig-out                             \
        --search-prefix $(nix eval --inputs-from . --raw nixpkgs#pkgs.pkgsStatic.llvmPackages_18.clang-unwrapped.lib) \
        --search-prefix $(nix eval --inputs-from . --raw nixpkgs#pkgs.pkgsStatic.llvmPackages_18.clang-unwrapped.dev) \
        --search-prefix $(nix eval --inputs-from . --raw nixpkgs#pkgs.pkgsStatic.llvmPackages_18.lld.lib) \
        --search-prefix $(nix eval --inputs-from . --raw nixpkgs#pkgs.pkgsStatic.llvmPackages_18.lld.dev) \
        --search-prefix $(nix eval --inputs-from . --raw nixpkgs#pkgs.pkgsStatic.llvmPackages_18.libllvm.lib) \
        --search-prefix $(nix eval --inputs-from . --raw nixpkgs#pkgs.pkgsStatic.llvmPackages_18.libllvm.dev) \
        --zig-lib-dir "$(realpath lib)"              \
        -Dno-langref                                 \
        -Denable-llvm=true                           \
        -Dstatic-llvm=false                          \
        -Dversion-string=0.13.1-ashet                \
        -Dllvm-has-m68k=false                        \
        -Dllvm-has-xtensa=false                      \
        -Dllvm-has-arc=false                         \
        -Dllvm-has-csky=false

# -Dtarget=x86_64-linux-musl                   \
# -Dcpu=baseline                               \