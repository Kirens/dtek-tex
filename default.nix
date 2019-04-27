{ stdenv, texlive, lib, dTeX-src ? null, ... }:

let
  dTeX = stdenv.mkDerivation rec {
    name = "dTeX-src";
    version = "v4.0";
    src = {
      outPath = ./src;
      name = "${name}-${version}";
    };
    buildPhase = ''
      echo Nothing to build
    '';
    installPhase = ''
      mkdir -p $out/tex/latex
      cp *.cls $out/tex/latex
      cp dteklogo.pdf $out/tex/latex
    '';
    pname = name;
    tlType = "run";
  };

  combinePkgs = lib.concatMap (a: a.pkgs);

  overridable = initialDTeX: initialDeps: {
    pkgs = [ initialDTeX ] ++ combinePkgs initialDeps;
    overrideDTeX = overrider:
      overridable (initialDTeX.overrideAttrs overrider) initialDeps;
    overrideDeps = overrider:
      overridable initialDTeX (overrider initialDeps);
  };
in overridable dTeX (with texlive; [
  amsmath
  babel-swedish
  collection-basic
  collection-fontsrecommended
  collection-xetex
  datetime
  etoolbox
  fancyhdr
  fmtcount
  fontspec
  geometry
  graphics
  hyperref
  lastpage
  oberdiek
  parskip
  pdfpages
  tocloft
  tools
  url
  xkeyval
])
