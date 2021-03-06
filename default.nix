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
      mkdir -p $out/tex/latex/dTeX
      cp ./*/* $out/tex/latex/dTeX
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
  datetime2
  datetime2-swedish
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
  pgf
  tocloft
  tools
  tracklang
  url
  xkeyval
])
