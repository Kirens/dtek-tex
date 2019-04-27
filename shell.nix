{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs)
    callPackage
    buildEnv
    stdenv
    texlive
    ;

  # HACK: Not sure if there is a proper way to do this
  # We want to make our package mutable during development
  src = "/path/to/project/root/src";

  dTeX = (callPackage ./default.nix { }).overrideDTeX (oldDTeX: {
    version = "live";
    installPhase = ''
      mkdir -p $out/tex/latex/dTeX

      ln -s ${src}/dtek.cls          $out/tex/latex/dTeX/dtek.cls
      ln -s ${src}/dtekkallelse.cls  $out/tex/latex/dTeX/dtekkallelse.cls
      ln -s ${src}/dteklogo.pdf      $out/tex/latex/dTeX/dteklogo.pdf
      ln -s ${src}/dtekprotokoll.cls $out/tex/latex/dTeX/dtekprotokoll.cls
    '';
  });

in stdenv.mkDerivation rec {
  name = "TeX-env";
  env = buildEnv {
    inherit name;
    paths = buildInputs;
  };
  buildInputs = [
    (texlive.combine {
      inherit dTeX;
      inherit (texlive)
        titlesec
        l3build
        ;
    })
  ];
}
