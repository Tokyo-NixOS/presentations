% Managing Projects with Nix
% サニエ エリック
% 2017年2月24日 - Tokyo NixOS Meetup


# Foreword

- Get a copy of the presentation repo to play with the code:

    ```
    $ git clone https://github.com/Tokyo-NixOS/presentations.git
    ```

# Agenda

- News
- Managing Projects with Nix


# News

- [Docker Nix Builder](https://github.com/numtide/docker-nix-builder)
- [Nix Bundle](https://github.com/matthewbauer/nix-bundle)
- [OSC 2017 Tokyo Spring](https://www.ospn.jp/osc2017-spring/)
- Haskell -> 8.0.2
- Python 3 as default?
- 17.03


# Managing projects with Nix

- Overview
    - Preparing a dev environment
    - Building with Nix
    - Build web projects
    - Making tests


# Dev environments

- `nix-shell` can be used create custom environments


# Nix-shell

- Nix shell is a tool to enter in a nix build environment
- Can be used to create ad-hoc environments with custom packages

    ```
    $ nix-shell -p elixir
    ```

- Clean shells can spawned by using the `--pure` flag


# Nix-shell expressions

- A `shell.nix` can be used to provide an environment
- Declares build dependencies
- Can provide other programs (editors, tools, ...)


# Example

- `2017/02/examples/binserver/shell.nix`


# Building a project

- Derivation files are used for building projects
- See last month slides and examples for more details
    - `2017/01/source.markdown` 


# Example

- `2017/02/examples/binserver/default.nix`
- `2017/02/examples/binserver/derivation.nix`


# Derivations limitations

- Derivations build packages
- ... but cannot manage global state (host configuration, ports, hosts, ...)


# Containers

- NixOS + Nix containers can manage global state in a deterministic way
- Containers require to use modules, so ...


# Modules

- Modules are the foundation of NixOS
- They are a declarative and determistic wa to manage OS configuration
- Easy to write and manage


# Example

- `2017/02/examples/binserver/module.nix`


# Nix tests

- Nix tests are the way NixOS modules are tested
- [Example](http://hydra.nixos.org/job/nixos/release-16.09/tested#tabs-constituents)
- Nix tests are:
    - Logical definition of machine(s)
    - Test script
- Nix tests are run in a clean virtual environment


# Example

- `2017/02/examples/binserver/test.nix`


# Next meetup

- Hydra


