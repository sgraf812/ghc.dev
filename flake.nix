{
  description = "ghc-dev-webgen";
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      ghc = "ghc92";
      pkgs = nixpkgs.legacyPackages.${system};
      haskellPackages =
        pkgs.haskell.packages.${ghc}.extend(hself: hsuper: {
          ghc-dev-webgen = haskellPackages.callCabal2nix "ghc-dev-webgen" "${self}/src/" {};
        });
    in
    {
      packages.${system}.ghc-dev-webgen = haskellPackages.ghc-dev-webgen;
      defaultPackage.${system} = self.packages.${system}.ghc-dev-webgen;
      devShell.${system} = pkgs.mkShell {
        buildInputs = [
          (haskellPackages.ghcWithPackages(p: p.ghc-dev-webgen.getCabalDeps.executableHaskellDepends))
          haskellPackages.ghc-dev-webgen.getCabalDeps.executableToolDepends
          haskellPackages.hie-bios
          haskellPackages.haskell-language-server
          haskellPackages.cabal-install
          pkgs.graphviz
        ];
      };
    };
}