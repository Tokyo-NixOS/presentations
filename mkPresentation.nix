# Nix expression to generate a slidy presentation

{ # the nixpkgs set to use
  pkgs
  # the style used by the presentation, can be "light" or "dark"
 ,style ? "light"
  # incremental mode setting
 ,incremental ? true
  # month of the presentation
 ,month
  # year of the presentation
 ,year
  # presentation mardown source file
 ,source
  # extra dependencies
 ,extraBuildInputs ? []
  # assets to include in the result packages, typically examples
 ,assets ? []
}:
let
  # CSS and images used by the presentation 
  commonFiles = ./common-files/.;
  # translate the incremental argument to the pandoc flag
  incrementalFlag = if incremental == true then "-i" else "";
in

pkgs.stdenv.mkDerivation rec {
  # setting the name of the derivation
  identifier = "${year}-${month}";
  name       = "NixOS-meetup-${identifier}";

  preferLocalBuild = true;
  allowSubstitutes = false;

  # passing the source
  src = source;

  # dependencies declaration
  buildInputs = with pkgs; [ pandoc ] ++ extraBuildInputs;

  # building
  buildPhase = ''
    for source in $(find . -name source\*.markdown); do
      id=$(sed 's/.*source\(.*\)\.markdown/\1/' <<<$source)
	    pandoc -s ${incrementalFlag} -t slidy $source -o "index$id.html" \
             --css ${commonFiles}/styles/base.css --css ${commonFiles}/styles/${style}.css \
             --css https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/styles/github.min.css \
             -V slidy-url=${commonFiles} --no-highlight \
             -A ${commonFiles}/highlight
      echo "#!/usr/bin/env sh" > "meetup$id"
      echo "${pkgs.qutebrowser}/bin/qutebrowser $out/share/${name}/index$id.html --target=window &" >> "meetup$id"
    done
  '';

  # installing
  installPhase = ''
    for html in *.html; do
      install -D -m 644 $html       $out/share/${name}/$html
    done
    for bin in meetup*; do
      install -D -m 555 $bin        $out/bin/${identifier}-$bin
    done

    ${pkgs.lib.concatMapStrings (folder: ''
      cp -r ${folder} $out/share/${name}/
    '') assets}
  '';
}
