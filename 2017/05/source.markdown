% DevOps & Nix
% サニエ エリック
% 2017年5月29日 - Tokyo NixOS Meetup


# Agenda

- News
- DevOps & Nix
    - presentation of the Nix ecosystem
    - What are DevOps
    - Nix and DevOps
    - Pros / Cons
    - Real Life Examples
- Talk


# News

- [Hercules](https://github.com/hercules-ci/hercules): Hydra in Haskell
- [home-manager](https://github.com/rycee/home-manager): Manage home with nix
- [NixCon 2017](http://nixcon2017.org/): October in Munich
- Wiki is dead, new user managed [wiki](https://github.com/nixos-users/wiki/wiki)
- [Typing Nix](https://typing-nix.regnat.ovh/): Updates
- [Intro to Nix Channels](http://matrix.ai/2017/03/13/intro-to-nix-channels-and-reproducible-nixos-environment/)
- [Maven packages in Nix](https://ww.telent.net/2017/5/10/building_maven_packages_with_nix)
- [Journey into Nix](https://adelbertc.github.io/posts/2017-04-03-nix-journey.html)
- [Distrowatch new review](https://distrowatch.com/weekly.php?issue=20170515)
- [Falling in love with NixOS](https://medium.com/@GauthierPLM/falling-in-love-with-nixos-36db4e50171e)
- [GNU Guix and GuixSD 0.13.0 released](https://www.gnu.org/software/guix/news/gnu-guix-and-guixsd-0.13.0-released.html)


# Notable PR / Issues

- [elasticsearch 5.4.0](https://github.com/NixOS/nixpkgs/pull/25857)
- [openstack liberty -> ocata](https://github.com/NixOS/nixpkgs/issues/25752)
- [Services abstraction](https://github.com/NixOS/nixpkgs/pull/26075)


# DevOps & Nix

![](assets/nix-devops.png)


# Nix DevOps DNA

- First line of the Nix paper:

    > This thesis is about getting programs from one machine to another - and having them still work when they get there.


# Nix ecosystem Overview

- **Nix**:
    - Deterministic build system (`nix-build`)
    - Package manager (`nix-env`)
- **nixpkgs**: Collection of Nix package recipes
- **Hydra**: Continuous integration / build based on Nix
- **NixOS**: Linux distribution using Nix as package manager
    - with a **declarative configuration model** (NixOS modules)
- **NixOps**: Deployment tool for NixOS
- **DisNix**: Deployment tool for Nix
- **NixLang**: Functional domain specific language


# NixLang

- Domain specific language (DSL) to create build actions (derivations)
- Functional
- Untyped
- Lazy evaluated
- Powerful, turing complete
- Good templating language
- REPL available: `nix-repl`


# Nix - build system

- Transform NixLang expressions into universal build actions (derivations)
- Declarative approach
- deterministic & reproducible builds
- complete dependencies
- shareable dependencies


# Nix - package manager

- Install packages in a dedicated space, the **nix store**
- Dependecies are explicit and all in the **nix store**
- Multiple versions / variations of the same packiage can coexist
- multi-user support
- Simple deployment mechanism (`nix-pull` & `nix-push`)
- Rollback
- Atomic upgrades
- temporary environments (`nix-shell`)


# Nixpkgs - nix expressions collection

- Collection of NixLang expressions for many software
- Mainly managed in a [git repository on github](https://github.com/NixOS/nixpkgs)
- Very easy to participate
- Contains package language specific packages (pypi, hackage, ...)
- Easy to customize: clone and modify
- Packages are all in an attribute set (`pkgs`)


# Hydra - Continuous integration

- Nix + Web interface + α
- Jobs are defined in NixLang
- Can run tests
- Can generate channels
- Can generate custom products
- Intermediate products are reused
- Distributed builds + clusters


# NixOS - Linux distribution

- Fully declarative with many abstractions (**NixOS modules**)
- Modules are defined and created in NixLang
- Atomic upgrades
- Rollbacks
- Source code in nixpkgs, easy to customize


# NixOps - NixOS deployment

- Deploy NixOS infrastructures from NixLang expressions
    - Similar to NixOS module system
- Physical and logical separation
- Support multiple backends
    - VirtualBox, AWS, Hetzner, ...
- Rollbacks


# DisNix

- Deploy Nix infrastructures from NixLang expressions
- Microservices approach
- Heterogeneous setups


# DevOps

![](assets/dev-ops.png)


# What are DevOps

- Multiple visions:
   - Combination development and operations
   - Extension of the agile cycle to operations
   - Software lifecycle full iteration management process


# Basic DevOps

- Dev and Ops combination

    ![](assets/dev-ops.png)


# The DevOps infinite loop

- plan (計画)
- code (開発)
- build (ビルド)
- test (テスト)
- release (リリース)
- deploy (デプロイ)
- operate (運用)
- monitor (監視)
- -> plan (計画)
- ...


# The DevOps infinite loop

![](assets/devops-loop.png)


# The 5 continuous

- Continuous development
    - coding & building
- Continuous testing
- Continuous integration
    - producing builds
- Continuous deployment
    - deploying builds, automation of the infrastructure
- Continuous monitoring


# Continuous tools - Example

- Continuous development: **maven**, **ant**, **gradle**, ...
- Continous testing: **Selenium**, **JUnit**, ...
- Continuous integration: **Bamboo**, **Jenkins**, **Travis**, ...
- Continous deployment: **Puppet**, **Chef**, **Ansible**, **Salt**, ...
- COntinous monitoring: **Nagios**, **Splunk**, **Sensu**, **New relic**, ...


# Continuous tools - Nix ecosystem

- Continuous development: **Nix** (`nix-build`)
- Continous testing: **Nix** and **Hydra**
    - **Nix** can run a check phase upon builds
    - **Hydra** can run tests in virtual machines
- continuous integration: **Hydra**
- Continuous deployment: **NixOps** & **DisNix**
- Continous monitoring: 3rd party solutions
    - **NixOS** monitoring services modules can help
    - Modules for nagios, munin, prometheus and others


# Nix pros / cons

- Cons
    - Relatively high entry barrier (but still lower than combination of multiple technologies)
    - Has some weaker parts (tests)
    - Infrastructure as Code (NixOps) is still lacking

- Pros
    - Fix the problem at the base (Build model)
    - declarative model, high level of abstraction - say what, not how
    - minimal friction of technologies
    - Very powerful DSL (no more JSON/YAML soup)
    - relatively easy to host a full Nix stack
    - reproducibility brings lot of value (reusable products, faster CI cycles, no more "works here", ...)
    - Flexibility, easy to create custom NixOS modules and packages
    - complete dependencies
    - free rollbacks
    - DevOps at the OS level


# Real life Usage

- Mozilla: [release management](https://github.com/mozilla-releng/services)
- [Lumiguide](https://lumiguide.nl/): [Talk](https://www.youtube.com/watch?v=IKznN_TYjZk) - Nix, LumiOS (Custom NixOS), NixOps
- [Matador cloud](https://matador.cloud/): Cloud storage - 100% NixOS machines
- [RhodeCode](https://rhodecode.com/): SCM - use nix in CLI tool, CI - [Article](https://rhodecode.com/blog/61/rhodecode-and-nix-package-manager)
- [Fractalide](https://github.com/fractalide/fractalide/): Service programming platform - Nix, NixOS
- [Picus Security](https://www.picussecurity.com): Cyber security - NixOps, NixOS, Hydra
- [Tweag.io](http://www.tweag.io/): R&D - Nix
- [Evidentiae Technologies](http://www.evidentiaetechnologies.com/): Medical - NixOS
- [Best Mile](https://bestmile.com/): Autonomous vehicles cloud platform - NixOS, NixOps
- [Prime.vc](http://prime.vc/) (Hong-Kong): Nix, NixOS, DisNix
- [Human Brain Project](https://www.humanbrainproject.eu/en/) & [Blue Brain Project](http://bluebrain.epfl.ch/): Neurosciences - Nix (Deployment on supercomputers)
- [Circuit Hub](https://circuithub.com/): Hydra (deploy on Heroku)
- and [more](https://www.reddit.com/r/NixOS/comments/5dz8fp/list_of_companies_using_nixos/)


# Talk


