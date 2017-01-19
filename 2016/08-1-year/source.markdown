% 1 Year Anniversary
% サニエ エリック
% 2016年8月24日 - Tokyo NixOS Meetup


# A bit of History

- Started 28th July, 2015
- First meetup on 7th September, 2015
- 12 meetups, almost once a month


# What we did!

- [Japanese Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
- [Presentations Slides](https://github.com/Tokyo-NixOS/presentations)
- Japanese input methods improvements


# Future

- Usual monthly events
- Special Events
    - Participation to OSC Tokyo in November
    - Open to propositions
- Hackathons?
- More casual meetups?


# Next Meetups Topics

- 16.09 release preview/review
- DisNix
- propositions?


# A few reminders

# Nix

- is a deterministic build system with a functional approach
- that happens to be a package manager
- build expressions are written in the Nix expression language
    - Nix is a "compiler" for Nix expression language
- interesting features:
    - can run on POSIX platforms (Linux-es and OSX supported)
    - multi-users
    - multi-versions
    - rollbacks
    - source & binary
    - multi environments
    - `nix-shell`!


# Nix Expression Language

- Pure, Lazy and Functional expression language ("Haskell-ish")
- not general purpose and has a quite uncommon syntax
- made to write build expressions
- playing with `nix-repl` is a interactive way to get used to it
    - [Tour of Nix](https://nixcloud.io/tour/) for some challenges!


# NixOS

- is a general purpose Linux distribution
- that use a declarative configuration for deterministic setups
- build on the base of Nix and systemd
- interesting features
    - full declarative setup (`configuration.nix`)
    - very customizable
    - atomic updates
    - rollbacks
    - updates can be tested in a VM


# nixpkgs

- nixpkgs is the package repository of Nix
- also contains all NixOS code (including unit tests)
- github repository
- interesting features
   - easy to participate, just make a PR!
   - can be customized and used locally


# Hydra

- Nix based buildfarm and continuous integration server
- build all the nixpkgs binaries
- interesting features
    - distributed builds
    - multiple architectures
    - easy to deploy on custom server


# NixOps Reminder

- NixOS based deployment tool
- support multiple backends


# Upcoming interesting features in Nix/NixOS

- [pure C++ Nix](https://github.com/NixOS/nix/issues/341)
- [NixUP](https://github.com/NixOS/nixpkgs/pull/9250)
- [NixOS netboot](https://github.com/NixOS/nixpkgs/pull/14740) via [netboot.xyz](https://github.com/antonym/netboot.xyz/issues/37)
- [IPFS](https://github.com/NixOS/nix/issues/859)
