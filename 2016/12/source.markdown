% NixOS First steps
% サニエ エリック
% 2016年12月07日 - Tokyo NixOS Meetup


# First Steps

- Understanding NixOS structure
- Get familiar with NixOS
    - Configuration File
    - Channels
- Maintenance


# NixOS Overview

- Uses [Nix](http://nixos.org/nix/) as a package manager
- Source and binary packages
- A single configuration file controls the OS
- System versioning and rollbacks
- Multi-user package management
- Separation of environments and filesystem (via profiles)


# NixOS Structure

- `configuration.nix`:
    - Configuration file that manage every aspect of the OS
- Nix Store:
    - Where all Nix products are stored
- nixpkgs:
    - Collection of Nix packages "recipes" and NixOS modules definitions
- Channels:
    - Way to synchronize nixpkgs
- Profiles:
    - Way to manage environments, per user, revisioned


# Configuration file

- Located `/etc/nixos/configuration.nix`
    - written in [Nix Expression Language](http://nixos.org/nix/manual/#ch-expression-language)
    - functional language, close to untyped lambda calculus
    - can be splitted in multiple files via `imports`
- NixOS modules
    - modules define options
    - options are used in `configuration.nix`
- [Thousands of options](http://nixos.org/nixos/options.html)
    - can even configure vim


# Configuration file

- Provisioning with `environment.systemPackages`
- services, programs, setting files, boot, kernel modules, users, ...
- Possible to import custom modules with `imports`
- `man configuration.nix`, `nixos-option`, `nixos-help` commands
- Links:
    - [NixOS manual - Configuration chapter](http://nixos.org/nixos/manual/index.html#ch-configuration)
    - [wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/configuration.nix)


# Configuration tricks

- Overriding packages dependencies:

    ```
    environment.systemPackages = with pkgs; [
      (nginx.override { openssl = libressl; })
    ];
    ```

- Using custom packages:

    ```
    environment.systemPackages = with pkgs; [
      (import ./my-pkg.nix)
      (pkgs.callPackage ./my-other-pkg.nix)
    ];
    ```


# Applying configuration

- `nixos-rebuild` command
    - `nixos-rebuild switch`: rebuild, activate the configuration and add it to the boot menu.
    - `nixos-rebuild test`: rebuild, activate the configuration but don't add it to the boot menu.
    - `nixos-rebuild build-vm`: create a QEMU virtual machine with the configuration.
    - `-I nixos-config=/etc/nixos/custom-configuration.nix` to use a different configuration file.
    - `-I nixpkgs=/path/to/nixpkgs` to use a custom version of [nixpkgs](https://github.com/NixOS/nixpkgs).


# Nix store

- Location `/nix/store/`
- Contains:
    - Every builded package
    - Every channel version
    - Every profile
- Every store item is compartimented in its own folder
- Example:
    
    ```
    $ nix-build -A hello '<nixpkgs>'
    $ ls result -dl
    $ tree result
    ```


# nixpkgs

- collection of
    - Nix packages "recipes"
    - NixOS modules
    - NixOS tests
    - and more
- Links:
    - [Github repository](https://github.com/NixOS/nixpkgs)
    - [nixpkgs manual](http://nixos.org/nixpkgs/manual/)


# Channels

- External point of view: Channels are a way to distribute specific versions of nixpkgs
- Internal point of view: Channels are a way to sync nixpkgs that meet some requirements
- Version of [nixpkgs](https://github.com/NixOS/nixpkgs) to use, [multiple variants](https://howoldis.herokuapp.com/):
    - `*-XX.XX`: stable channels, new one every 6 months
    - `*-unstable`: unstable channels, close to rolling release
    - `*-small`: small channels, good for servers


# nix-channel command

- `nix-channel` command to manipulate channels
    - `nix-channel --list` list used channels
    - `nix-channel --add` to add a channel
    - `nix-channel --update` to update the channels
- Example: using the unstable channel:

    ```
    $ nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    $ nix-channel --update
    ```

- Channels information is stored in `~/.nix-channels`
- Active channels are linked in `~/.nix-defexpr/`
- All channels and their versions are stored under `/nix/var/nix/profiles/per-user`
- `root` user channel is the system channel (used by `nixos-rebuild`)


# Channel tricks

- A remote nixpkgs archive can be used:

    ```
    $ nixos-rebuild switch -I nixpkgs=https://github.com/nixos/nixpkgs-channels/archive/nixos-16.09.tar.gz
    ```

- A local checkout of nixpkgs, useful for custom patches:

    ```
    $ nixos-rebuild switch -I nixpkgs=/path/to/my/nixpkgs
    ```


# Channel rollback

- User channels version can be checked with:

    ```
    $ nix-env -p /nix/var/nix/profiles/per-user/USER/channels --list-generations
    ```

- And their version changed with:

    ```
    $ nix-env -p /nix/var/nix/profiles/per-user/USER/channels --switch-generations GEN
    ```


# Profiles

- Profiles merge nix-store paths by symbolic links
- Active profile is in `~/.nix-profile`
    - Profiles are managed and versioned in `/nix/var/nix/profiles/per-user`
- configuration.nix `environment.systemPackages` profile is linked to `/run/current-system/sw`
- Links:
    - [Nix manual - profiles](http://nixos.org/nix/manual/#sec-profiles)


# Trying software

- `nix-shell` command to generate temporary environments:

    ```
    $ nix-shell -p hello
    $ hello
    ```

- can even run commands:

    ```
    $ nix-shell -p cowsay --run "cowsay hello nix"
    ```

- nix-shells can be declared in nix-files, handy for setting dev environments
- nix-shell can also be used as [shebang](https://gist.github.com/travisbhartwell/f972aab227306edfcfea)


# Finding software

- nix-env is complex, [nox](https://github.com/madjar/nox) is more user-friendly:

    ```
    $ nix-shell -p nox
    $ nox browser
    ```

# Maintenance

- Watch for the store size!
- Nix store all the packages in the nix store (`/nix/store`)
- Removing packages with `nix-env -e` or by removing them from `environment.systemPackages` dont remove them from the store
- Store can be cleaned by garbage-collecting it:

    ```
    # nix-collect-garbage --delete-older-than 14d
    ```

