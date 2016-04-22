{ pkgs
 ,style ? "light"
 ,incremental ? true
 ,month
 ,year
 ,source
 ,extraBuildInputs ? []
 ,assets ? []
}:
let
  commonFiles = ./common-files/.;
  incrementalFlag = if incremental == true then "-i" else "";
in
pkgs.stdenv.mkDerivation rec {
  identifier = "${year}-${month}";
  name       = "NixOS-meetup-${identifier}";

  src = source;

  buildInputs = with pkgs; [ pandoc ] ++ extraBuildInputs;

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    for source in $(find . -name source\*.markdown); do
      id=$(sed 's/.*source\(.*\)\.markdown/\1/' <<<$source)
	    pandoc -s ${incrementalFlag} -t slidy $source -o "index$id.html" --css ${commonFiles}/base.css --css ${commonFiles}/${style}.css
      echo "${pkgs.qutebrowser}/bin/qutebrowser $out/share/${name}/index$id.html --target=window &" > "meetup$id"
    done
  '';

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
