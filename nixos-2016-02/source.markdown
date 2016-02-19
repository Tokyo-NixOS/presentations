% Packaging 101
% Tokyo NixOS Meetup
% 2016, 18 February

# This month in Nix - 1

## News from the front

* [Nix 1.11 released](http://nixos.org/nix/manual/#ssec-relnotes-1.11)
* [Nix Funding](https://github.com/NixOS/nix/issues/341): remove perl from Nix, successly founded!
* [New Nix Command line coming](https://github.com/NixOS/nix/issues/779) ヽ(=´▽`=)ﾉ
* [dockerTools](http://hydra.nixos.org/build/31821726/download/1/nixpkgs/manual.html#ex-dockerTools-buildImage): build docker images from Nix expressions
* [Multiple outputs PR on the point of being merged](https://github.com/NixOS/nixpkgs/pull/7701)

# This month in Nix - 2

## NixOS Reddit selection

- [NixOS on Digital Ocean](http://blog.tinco.nl/2016/02/05/nixos-on-digital-ocean.html)
- [Using Nix instead of Docker](http://www.mpscholten.de/docker/2016/01/27/you-are-most-likely-misusing-docker.html)
- [What are NixOS cons](https://www.reddit.com/r/NixOS/comments/441ymh/nixos_users_tell_me_what_are_the_cons/)
- [Migration to NixOS](https://www.reddit.com/r/NixOS/comments/45jptz/migration_to_nixos/)
- [Setting up your own build farm](https://www.youtube.com/watch?v=RXV0Y5Bn-QQ) ([Repository](https://github.com/peti/hydra-tutorial))


# This month in Nix - 3

## Mailing list selection

- [Using Nix as the package manager for a new language](http://lists.science.uu.nl/pipermail/nix-dev/2016-February/019450.html)
- [Flattening pkgs tree](http://lists.science.uu.nl/pipermail/nix-dev/2016-January/019120.html)
- [Wiki is dead](http://lists.science.uu.nl/pipermail/nix-dev/2016-February/019459.html)
- [CVE-2015-7547 stdenv-changing fix merged on master and 15.09](http://lists.science.uu.nl/pipermail/nix-dev/2016-February/019557.html)


# This month in Nix - 4

## Tokyo NixOS Meetup activities

* [OSC Tokyo Spring](http://www.ospn.jp/osc2016-spring/) on Feb 26 - 27, everybody welcome to join!
* Simple wallpapers (Welcoming contributions!)
* Nix goodies
* [Japanese input done right! (almost)](https://github.com/NixOS/nixpkgs/pull/11254)
* [Japanese Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki): new pages: Install & Nix internals!


# Understand Nix in 10 minuts

- Nix: compiler for a functional package centric DSL
    - functional = lazy + pure + deterministic
    - pure = no missing dependency
    - deterministic = binary install for free
    - lazy = lightweight and fast
    - DSL = easy customization 
    - package isolation = atomic upgrades + easy rollback + no Dependency hell + impossible to break system by installing a package
    - not limited to system packages, Nix can package almost anything (great packaging of hackage)
    - can be thought as "One package manager to rule them all" "Make on steroids"
- NixOS: an OS is packages + configuration, NixOS is Nix extended with a configuration DSL (module system)
    - declarative configuration with typed properties
    - lightweight containers (based on systemd nspawn)
    - easy to add custom services


# Packaging 101: packaging basics

Foreword:

- Reading the [contributor guide](http://nixos.org/nixpkgs/manual/) is always a good idea
- Basic understanding of the Nix language can help a lot, [a tour of nix](https://nixcloud.io/tour/?id=1) and the [manual](http://nixos.org/nix/manual/#chap-writing-nix-expressions) are great resources

Basic workflow:

- get [nixpkgs](https://github.com/NixOS/nixpkgs)
- create a package file in the somewhere in `pkgs/`
- add the package entry in `pkgs/top-level/all-packages.nix`
- build the package and test


# Packaging 101: getting nixpkgs

- go to [github nixpkgs](https://github.com/NixOS/nixpkgs) and click the Fork button
- go to the forked repository and get the clone url
- clone to a local machine

    ~~~~
    $ git clone git@github.com:USER/nixpkgs.git
    ~~~~

- Or just clone the official nixpkgs if you have no github account or don't plan to submit PRs.

## Exercices

- check the structure under the `pkgs/`.
- check `pkgs/top-level/all-packages.nix`.


# Packaging 101: create a custom hello package (derivation)

- check the default hello package in `pkgs/applications/misc/hello/default.nix`
- create a dedicated branch

    ~~~~
    $ git checkout -b pkg/my-hello
    ~~~~

- create `my-hello` folder in misc

    ~~~~
    $ mkdir pkgs/applications/misc/my-hello/
    ~~~~

- copy the hello derivation to my-hello

    ~~~~
    $ cp pkgs/applications/misc/{,my-}hello/default.nix
    ~~~~

- edit `pkgs/applications/misc/my-hello/default.nix` and change the derivation name to my-hello

## Exercices

- Find what meta maintainers and licence fields refer to.
- Make yourself as the maintainer of `my-hello`.


# Packaging 101: register the package to all-packages.nix

- add a my-hello entry to `all-packages.nix`

## Exercice

- figure the relation between the package name, the package path and the `all-packages.nix` entry name.
- move the version in a dedicated attribute. 
    - (tip: check the tilda package)


# Packaging 101: build the package 

- build the package

    ~~~~
    $ nix-build -A my-hello
    ~~~~

- run it!

    ~~~~
    $ ./result/bin/hello
    ~~~~

## Exercice

- Check and note the my-hello nix store hash. 
    - (tip: result is a symlink to the store)
- Change my-hello version to 2.9
    - (tip: `man nix-prefetch-url`).
- Compare the first my-hello and 2.9 my-hello store hash.
- Can you still run my-hello 2.10?


# Packaging 101: Bonus Exercice

Find a package not yet available in nixpkgs and package it.


# Meetup future

- Any idea on how to improve the meetup?
- Better times, better places?
- 3 places: meetup, connpass, doorkeeper; Meetup currently as a the main place
- more activities like OSC and other groups
- evolve to a "NixOS user group"?



# Useful links

* [NixOS Manual](http://nixos.org/nixos/manual/)
* [Packages Search](http://nixos.org/nixos/packages.html)
* [Configuration Options Search](http://nixos.org/nixos/packages.html)
* [Contributor Guide](http://nixos.org/nixpkgs/manual/)
* [Wiki](https://nixos.org/wiki/Main_Page)
* [Install tutorial](http://nixos.org/nixos/manual/sec-installation.html)
* [Install in virtualbox](https://nixos.org/wiki/Installing_NixOS_in_a_VirtualBox_guest)
* [Japanese Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
