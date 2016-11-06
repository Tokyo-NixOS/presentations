with import <nixpkgs> {};

(python3.withPackages (ps: [ ps.pyramid ])).env
