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

      for file in $(find * -mindepth 1 -maxdepth 1)
      do
        ln -s ${src}/$file  $out/tex/latex/dTeX$(echo $file | grep -o '/.*')
      done
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
