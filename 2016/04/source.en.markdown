% Nix Expression Language
% Eric Sagnes
% 2016, April 14 - Tokyo NixOS Meetup

# Agenda

- News
- Presentation of Nix language
- Builtins functions presentation
- Module system presentation
- Examples of Nix Expressions
- Interactive exercices


# This month in Nix - [News from the front](https://github.com/NixOS/nixpkgs)

- [NixOS 16.03 released!](http://nixos.org/nixos/manual/release-notes.html#sec-release-16.03)
- [multiple outputs / closure size PR merged!](https://github.com/NixOS/nixpkgs/pull/7701) 
- [RFC: remove node packages](https://github.com/NixOS/nixpkgs/issues/14532)
- [service hardening](https://github.com/NixOS/nixpkgs/issues/14645)
- ~~[Unstable channel hasn't updated for 2+ weeks](https://github.com/NixOS/nixpkgs/issues/14595)~~


# This month in Nix - [Reddit topics](https://www.reddit.com/r/NixOS/)

- [NeoVIM configuration example](https://github.com/seagreen/vivaine/blob/master/extended-config/vim/c.nix)
- [odroid xu4 with nixos](https://lastlog.de/blog/posts/odroid_xu4_with_nixos.html)
- [NixOS on a MacBook Pro](https://www.reddit.com/r/NixOS/comments/4d2dhq/nixos_on_a_macbook_pro/)
- [From Zero to Application Delivery with NixOS](http://www.slideshare.net/mbbx6spp/from-zero-to-application-delivery-with-nixos)


# This month in Nix - [ML topics](http://news.gmane.org/gmane.linux.distributions.nixos)

- [staging merged](http://article.gmane.org/gmane.linux.distributions.nixos/19964)
- [Status: Transparent Security Updates](http://article.gmane.org/gmane.linux.distributions.nixos/19965)
- [GNU Guix & GuixSD 0.10.0 released](https://www.gnu.org/software/guix/)
- [nix-1.11.2 on dockerTools.buildImage](https://gist.github.com/aespinosa/6c979bebfda9d78b181a95e08524ef72)
- [ Trying to implement quicksort in nix...](http://news.gmane.org/find-root.php?message_id=20160413123922.GH3592%40yuu)


# This month in Nix - [Tokyo NixOS](https://github.com/Tokyo-NixOS/)

- Presentation about Nix at [Wakame User Group](http://axsh.jp/community/wakame-users-group.html) on April 22
- [fcitx input method do not work on unstable and 16.03](https://github.com/NixOS/nixpkgs/issues/14019)
    - ~~[PR1](https://github.com/NixOS/nixpkgs/pull/14417)~~ [PR2](https://github.com/NixOS/nixpkgs/pull/14568)
- [Input methods manual](https://github.com/NixOS/nixpkgs/pull/14602)


# Nix Expression Language

- Nix Expression language != Nix 
    - Nix is a compiler for Nix expression language
- DSL for writing packages
- Pure
    - no side effects
- Lazy
    - evaluating only needed arguments
- Functional
    - functions are first class citizens
- Dynamic typing
- [Manual](http://nixos.org/nix/manual/#ch-expression-language)


# Nix Expression Language: Use cases

- Packages
- Modules
- Developement environment
- Configuration / Provisioning
- Containers
- Deployment (via NixOps)
- Continuous integration (via Hydra)
- tests
- docker images
- anything that can be done with `make` 


# Nix Expression language: Evaluation

- Using `nix-intantiate`
    - example

        ```
        nix-instantiate  --eval -E '1 + 3'
        ```

    - lazy evaluation is default

        ```
        nix-instantiate --eval -E 'rec { x = "foo"; y = x; }'
        ```

    - strict evaluation can be activated using `--strict` 

        ```
        nix-instantiate --eval -E --strict 'rec { x = "foo"; y = x; }'
        ```

- Using `nix-repl`


# Types: string

- Example

    ```
    "foo bar"
    ```

    ```
    "
    foo
    bar
    "
    ```

- Indented strings

    ```
    ''
      foo
      bar
    ''
    ```

- Expression that can be evaluated to strings can be inserted in other strings using `${}`

    ```
    "--with-freetype2-library=${freetype}/lib"
    ```

- URL that are conform to [RFC2396](http://www.ietf.org/rfc/rfc2396.txt) can be used without surrounding by `""` ([subject of debate](https://github.com/NixOS/nix/issues/836))

    ```
    http://example.org/foo.tar.bz2
    ```


# Other Types

- Integers
    - `123`
- Paths
    - `./builder.sh`
    - `../../foo.nix`
    - Paths are evaluated relatively from the the file they are wrote in
- Booleans
    - `true` | `false`
- null
    - `null`
- floats ([master](https://github.com/NixOS/nix/pull/762))


# Types: List

- List are enclosed in `[]`
- Item separator is whitespace
- Lists can hold differents types values

    ```
    [ 123 ./foo.nix "abc" (f { x = y; }) ]
    ```

- Lists evaluation is
    - lazy in value
    - strict in length (no infinite lists)


# Types: Sets

- Sets are central in Nix expressions
- Standard key/value type
- example

    ```
    { 
      x = 123;
      text = "Hello";
      y = f { bla = 456; };
    }
    ```

- Values can be accessed with `.`

    ```
    { a = "Foo"; b = "Bar"; }.a

    # => "Foo"
    ```

# Language construct: `rec`

- `rec` is used to create recursive sets

    ```
    rec {
      x = y;
      y = 123;
    }.x

    # => 123
    ```

- Use with care, it is possible to have infinite recursion

    ```
    rec {
      x = y;
      y = x;
    }.x

    # infinite recursion
    ```

- Example of usage: `name` and `version` in packages

    ```
    rec {
      name = "foo-${version}";
      version = "1.0.0";
    }
    ```


# Language construct: `let`

- `let` binds local variables

    ```
    let
      x = "foo";
      y = "bar";
    in x + y

    # => "foobar"
    ```


# Lanaguage construct: `inherit`

- `inherit` allows the usage of external scope variables

    ```
    let x = 123; in
    { 
      inherit x;
      y = 456;
    }
    
    # => { x = 123; y = 456; }
    ```

- `inherit a b` inherit `b` key from `a` set

    ```
    graphviz = (import ../tools/graphics/graphviz) {
      inherit fetchurl stdenv libpng libjpeg expat x11 yacc;
      inherit (xlibs) libXaw;
    };
    
    xlibs = {
      libX11 = ...;
      libXaw = ...;
      ...
    }
    
    libpng = ...;
    libjpg = ...;
    ...
    ```

# Functions

- Form

    ```
    pattern: body
    ```

    note: whitespace after the `:` is required

- Example:

    ```
    x: x
    ```

    ```
    x: y: x + y
    ```

- Currying:

    ```
    let add = (x: y: x + y); in add 3 4

    # => 7
    ```

    ```
    let add1 = (x: y: x + y) 1; in add1 2

    # => 3
    ```


# Functions: sets

- Sets can be used as function arguments

    ```
    let add = { x, y }: x + y; in add { x = 2; y = 2; }

    # => 4
    ```

- It is possible to set default values with `?`

    ```
    let add = { x ? 1, y }: x + y; in add { y = 2; }

    # => 3
    ```

- `@` can be used to match the whole set


    ```
    let foo = args@{ x, ... }: args.a; in add { x = 2; y = 2; a = 42; }

    # => 42
    ```

- functor (different from Haskell)

    ```
    let add = { __functor = self: x: x + self.x; };
    inc = add // { x = 1; };
    in inc 1

    # => 2
    ```


# Other constructs

- `if e1 then e2 else e3`: conditional

- `assert e1; e2`: assertions

    - if `e1` evaluate to `true` then `e2` is returned
    - if `e1` evaluate to `false` then evaluation is stopped and backtrace is printed


- `with e1; e2`: introduce set `e1` in `e2` scope

    ```
    let as = { x = "foo"; y = "bar"; };
    in with as; x + y
    ```

- Comments

    ```
    # single line

    /*
     multi
     line
    */
    ```


# Operators

- `s.a`: select `a` attribute form set `s`
- `e1 e2`: function call, calls function `e1` with argument `e2`
- `s ? a`: test if set `s` contains attribute `a`; returns `true` | `false`
    - Different from `?` in function head (default value)
- `e1 ++ e2`: list concatenation
- `e1 + e2`: string or path concatenation, integer addition
    - strings are not lists
- `! e1`: boolean negation
- `s1 // s2`: merge set `s1` and set `s2`
    - If there is the same key in both sets, set at the right of the operator one is used (`s2`)
- `e1 == e2`: equality
- `e1 != e2`: inequality
- `e1 && e2`: AND
- `e1 || e2`: OR
- `e1 -> e2`: logical implication, `!e1 || e2`


# Builtins functions (sample)

- `abort s`: stop evaluation and print error message `s`
- `builtins.all pred list`

    ```
    let even = (x: (x - 2 * (x / 2)) == 0); in builtins.all even [ 2 4 6 ]

    # => true
    ```

- `builtins.filter pred list`


    ```
    let even = (x: (x - 2 * (x / 2)) == 0); in builtins.filter even [ 1 2 3 4 5 6 ]

    # => [ 2 4 6 ]
    ```

- `import`: import some nix file

    ```
    import ./foo.nix
    ```

- `map f list`:

    ```
    let square = x: x*x; in map square [1 2 3 4]

    # => [ 1 4 9 16 ]
    ```

- `builtins.toFile name s`: generate file `name` with contents `s` in the Nix store
    
    ```
    builtins.toFile "hello.txt" "hello"

    # => /nix/store/q790zdjk75hm2cn42nh77pqw4gbv1b88-hello.txt
    ```


# Module system

- Nix Expression + types
- types are made with `mkOption`
- separated in interface (`options`) and implementation (`config`)
- examples
    - [tmux](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/tmux.nix)
    - [neo4j](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/databases/neo4j.nix)


# Examples of Nix Expressions

- [Package](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix)
- [External package](https://github.com/ericsagnes/binry/blob/master/release.nix)
- [External module](https://github.com/ericsagnes/binserver/blob/master/module.nix)
- [Development environment](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/tree/master/nix-shells)
- System configuration / Provisioning
- [Types declarations](https://github.com/NixOS/nixpkgs/blob/master/lib/types.nix)
- [List functions](https://github.com/NixOS/nixpkgs/blob/master/lib/lists.nix)
- [nixpkgs Hydra job](https://github.com/NixOS/nixpkgs/blob/master/nixos/release-combined.nix)
- [Deployments](https://github.com/NixOS/nixops/tree/master/examples)
- [Tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/containers.nix)
- [Manual generation](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/default.nix)
- [Slides generation](https://github.com/Tokyo-NixOS/presentations/blob/master/mkPresentation.nix)


# Interactive exercices

- Let's [Tour of Nix](https://nixcloud.io/tour/)


# Thank you!

- Questions?
- Any idea for next session topic?


# リンク

* [Nix manual](https://nixos.org/nix/manual/)
* [japanese Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
* [Previous slides](https://github.com/Tokyo-NixOS/presentations)
* [NixOS manual](http://nixos.org/nixos/manual/)
* [package search](http://nixos.org/nixos/packages.html)
* [Modules options search](http://nixos.org/nixos/packages.html)
* [Contributor Guide](http://nixos.org/nixpkgs/manual/)
