% NixOS Basics
% Tokyo NixOS Meetup
% 2015, 7 September

# Sales pitch

> The Purely Functional Linux Distribution  

> [NixOS](https://nixos.org/) is a Linux distribution with a unique approach to package and configuration management. Built on top of the Nix package manager, it is completely declarative, makes upgrading systems reliable, and has many other [advantages](https://nixos.org/nixos/about.html).

# NixOS Glossary

* Nix: The Nix package manager
* NixOS: Linux distribution using Nix
* Derivation: a package build action
* Nix expression language: language to write derivations or configuration files
* Channel: a way to distribute derivations and associated binaries
* Nix store: local place where derivations are installed, `/nixos/store`
* nixpkgs: nix packages [github repository](https://github.com/NixOS/nixpkgs)
* Hydra: Nix packages build farm

# Specificities

* Declarative configuration
* nixpkgs
* Multiple software versions
* Multi-user support
* Atomic upgrades
* Rollback
* Functional
* Deterministic
* Complete dependencies
* Binary and source based

# Declarative configuration

* Main configuration file is `/etc/nixos/configuration.nix`
* `/etc/nixos/hardware-configuration.nix` contains hardware specific settings and is automatically generated during install.  
Edit at own risk.
* Configuration is wrote in [Nix expression language](http://nixos.org/nix/manual/#ch-expression-language)
* Nix expression language is very rich, and configurations can be turned in programs for more modularity
* Running the `nixos-rebuild` command update the system based on `configuration.nix, example:`

~~~~
nixos-rebuild switch
~~~~

* [Declarative configuration manual](https://nixos.org/nixos/manual/sec-configuration-syntax.html)

# Configuration Options

* [Available options search engine](https://nixos.org/nixos/options.html)
* `nixos-option` command:

~~~~
nixos-option services.xserver.enable
~~~~

* `nix-repl` command:

~~~~
nix-repl '<nixos>'
config.services.xserver
~~~~

# Configuration Recipes 1/6

Import separate files:

~~~~
  imports = [ 
    ./hardware-configuration.nix
    ./software.nix
    ./fonts.nix
    ./containers.nix
  ];
~~~~

# Configuration Recipes 2/6

Global packages installation:

~~~~
environment.systemPackages = [ pkgs.emacs pkgs.vim ];
~~~~

or

~~~~
environment.systemPackages = with pkgs; [ emacs vim ];
~~~~

# Configuration Recipes 3/6

Enabling japanese input:

~~~~
  programs = {
    ibus.enable  = true;
    ibus.plugins = [ pkgs.ibus-anthy pkgs.mozc ];
  };
~~~~

or 

~~~~
  programs = {
    ibus = {
      enable  = true;
      plugins = [ pkgs.ibus-anthy pkgs.mozc ];
    };
  };
~~~~


# Configuration Recipes 4/6

Enabling Apache web server:

~~~~
  services = {
    httpd = {
      enable = true;
      adminAddr = "alice@example.org";
      documentRoot = "/webroot";
    };
  };
~~~~

# Configuration Recipes 5/6

Using functions:

~~~~
  services.httpd.virtualHosts =
    let
      makeVirtualHost = { name, root }:
        { hostName = name;
          documentRoot = root;
          adminAddr = "alice@example.org";
        };
    in map makeVirtualHost
      [ { name = "example.org"; root = "/sites/example.org"; }
        { name = "example.com"; root = "/sites/example.com"; }
        { name = "example.gov"; root = "/sites/example.gov"; }
        { name = "example.nl";  root = "/sites/example.nl"; }
      ];
~~~~

# Configuration Recipes 6/6

Using Conditionals:

~~~~
  environment.systemPackages =
    if config.services.xserver.enable then
      [ pkgs.firefox
        pkgs.thunderbird
      ]
    else
      [ ];
~~~~

# nixpkgs

* [nixpkgs](https://github.com/NixOS/nixpkgs) is the github repository containing all nixos packages
* Every derivation is a nix expression
* Nix expressions are lazy, installing a package is forcing the evaluation of a derivation.
* packages are classified in sections under [/pkgs](https://github.com/NixOS/nixpkgs/tree/master/pkgs)
* configuration options are in [/modules](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules)
* last version is the norm, but multiple versions available when meaningful (compilers, ..)
* adding packages or modules is submitting a pull-request

# nixpkgs

* [simple derivation](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/ex-2/default.nix):

~~~~
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hello-2.10";

  src = fetchurl {
    url = "mirror://gnu/hello/${name}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };

  doCheck = true;

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = http://www.gnu.org/software/hello/manual/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
~~~~

# nixpkgs

* nixpkgs also manage language specific packages: [haskell](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/haskell-packages.nix), [python](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/python-packages.nix), [php](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/php-packages.nix), ...
    * has advantages: binaries, flexible management, no dependency hell, external dependencies
* [helpers functions](https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support) are available to make derivation creation even simpler.

# Nix Store

* locally located in `/nix/store`
* read only 
* contains installed derivations (and uninstalled derivations not yet garbage-collected)
* every package is isolated in its own folder using the `/nix/store/HASH-NAME-VERSION/` pattern
* the HASH part is the only important for the system
* the hash is computed using all the inputs of the derivation

~~~~
ls -d /nix/store/*/ | grep firefox
/nix/store/3qv1pxgfb8afgzv1mn8ik7k6wibm9ixr-firefox-with-plugins-40.0.2/
/nix/store/48j5d2432lfl7b6qky20zvqnx4limmln-firefox-40.0.3/
/nix/store/9sa1yd509ria6wdqdb1170wsr8q46rvh-firefox-with-plugins-40.0.2/
/nix/store/a4rzv3bpvf74i6c1bysg2dk4wik7s4wn-firefox-with-plugins-40.0.3/
/nix/store/cs44vfr4ap1sw2f1mi9m0gf6vyb3h7y9-firefox-with-plugins-40.0.3/
/nix/store/cxnrfl4mns2i41h5mna0ig9xs7ckcf5c-firefox-with-plugins-39.0/
/nix/store/da9ni00z5hkni0aaz0n9q64crxvwy2kp-firefox-with-plugins-40.0.2/
/nix/store/gmw42qaghjv9xkrq83ay0k18jfysfrqi-firefox-40.0.3/
/nix/store/jlygv8k720s252qf9c0hdd2riai4a900-firefox-40.0.2/
/nix/store/m6flvkyagk20sig628g5ziwaslpiimrn-firefox-39.0/
/nix/store/nna0d4wdbfp3z5azjjn4jl5089f741fc-firefox/
/nix/store/pzni8z4s8d43j5486pmrlfl2dmwwxzqi-firefox-40.0.2/
/nix/store/rrnjk0vqyng331z78c2dv1nh5swyks96-firefox-40.0.2/
/nix/store/vvlc51dbrpadm2qz9pcb3pz7yvmzf2c9-firefox/
~~~~

# Nix Store

* A store folder contains *all* the files of the package

~~~~
tree /nix/store/nmg89z2dxrx87wdqfhfbgbm3jzvczwq0-tree-1.7.0/
/nix/store/nmg89z2dxrx87wdqfhfbgbm3jzvczwq0-tree-1.7.0/
├── bin
│   └── tree
└── share
    └── man
        └── man1
            └── tree.1.gz
~~~~

* Active packages paths are merged in an environment derivation `/nix/store/HASH-system-path` that is in turn used by the main nixos derivation `/nix/store/HASH-nixos-LABEL`
* Assembled nixos environments can be found in `/nix/var/nix/profiles/`
* uninstalling a derivation just unlink it from user environment
* nixos garbage-collection can be used ([nix-collect-garbage](http://nixos.org/nix/manual/#sec-nix-collect-garbage) command) to delete unused derivations from the disk
* rollbacks are possible with `nixos-rebuild switch --rollback` or at machine boot menu

# Channels

* Channels are how NixOS distribute derivations and binaries
* There is 3 kinds of channels
    * *Stable channels* - released about twice a year, get only bug fixes and conservative minor upgrades after releases
    * *Unstable channel* - aka rolling release
    * *Small channels* - available with stable and unstable, they contains fewer packages and get updated more frequently. Suitable for servers.
* It is generally safe to switch between channels
* Channels can be found on github as branches on a [dedicated repository](https://github.com/NixOS/nixpkgs-channels)

# Channel Update Workflow

* [Hydra](http://hydra.nixos.org/) is the build farm for nixos/nixpkgs

1. Jobs are set in [Hydra](http://hydra.nixos.org/) that grab nixpkgs expressions dedicated to [channel building](https://github.com/NixOS/nixpkgs/blob/master/nixos/release-combined.nix)
2. When a job succeeds, the binary cache server download the binaries from Hydra
3. When binaries are all downloaded the channel is updated

* This assures that all packages correctly build and that binary cache is available

# nix-shell

* `nix-shell` is a tool that start a clean shell
* the system use it when building derivations
* because the shell is pure(without any packages beside stdenv), derivations are assured to have complete dependencies it they build

# nix-shell

* `nix-shell` has a `-p` argument that take a list of packages to bring in the shell
* this is allow quick testing of packages

~~~~
# java -version
The program ‘java’ is currently not installed. It is provided by
several packages. You can install it by typing one of the following:
  nix-env -i jdk
  nix-env -i jdk7
# nix-shell -p java
# java -version
openjdk version "1.8.0_60"
OpenJDK Runtime Environment (build 1.8.0_60-24)
OpenJDK 64-Bit Server VM (build 25.60-b23, mixed mode)
# exit
# nix-shell -p java7 
# java -version
openjdk version "1.7.0-80"
OpenJDK Runtime Environment (build 1.7.0-80-b32)
OpenJDK 64-Bit Server VM (build 24.80-b11, mixed mode)
~~~~

* `--pure` flags turn the shell pure
* nix files can be passed to `nix-shell` to set up a fully customized shell
    * very useful for development

# Non Determinism

* To have consistent derivations hash across machines, it is very important for the build process to be as deterministic as possible
* NixOS use tricks to take out non-determinism (try `uname -a`)
* Nix store derivation hash is computed by all inputs of the derivation (including dependencies)

# Functional distribution?

* laziness - derivations are `thunks` evaluated when installed
* no global state - derivations outputs depends only on the inputs
* purity - derivations don't have side effect (no changes to `/etc` or `/bin`)
* no mutability - installing a modified derivation will not change other versions of the derivation

# Containers

* `nix-container` can be used to create lightweight containers
* containers can also be defined in the global configuration
* Useful for web services and web development
* [Container management manual](https://nixos.org/nixos/manual/ch-containers.html)

# Tips

* for single user environment, using `configuration.nix` to manage installed software is recommended
* having a local fork of `nixpkgs` is useful for trying and submitting new packages
* having `nix-shell` templates for languages you often use
* for installing packages [`nox`](https://github.com/madjar/nox) is simpler to use than `nix-env`

# Useful resources

* [NixOS Manual](http://nixos.org/nixos/manual/)
* [Packages Search](http://nixos.org/nixos/packages.html)
* [Configuration Options Search](http://nixos.org/nixos/packages.html)
* [Contributor Guide](http://nixos.org/nixpkgs/manual/)
* [Wiki](https://nixos.org/wiki/Main_Page)
* [Install tutorial](http://nixos.org/nixos/manual/sec-installation.html)
* [Install in virtualbox](https://nixos.org/wiki/Installing_NixOS_in_a_VirtualBox_guest)
