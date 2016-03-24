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

  buildInputs = with pkgs; [ pandoc qutebrowser ] ++ extraBuildInputs;

  buildPhase = ''
	  pandoc -s ${incrementalFlag} -t slidy source.markdown -o index.html --css ${commonFiles}/base.css --css ${commonFiles}/${style}.css
    echo "${pkgs.qutebrowser}/bin/qutebrowser $out/share/${name}/index.html --target=window &" > meetup
  '';

  installPhase = ''
    install -D -m 644 index.html   $out/share/${name}/index.html
    install -D -m 555 meetup       $out/bin/meetup-${identifier}

    ${pkgs.lib.concatMapStrings (folder: ''
      cp -r ${folder} $out/share/${name}/
    '') assets}
  '';
}
