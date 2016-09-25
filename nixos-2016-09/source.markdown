% Extended Types for NixOS Modules
% サニエ エリック
% 2016年9月29日 - Tokyo NixOS Meetup


# What are NixOS modules?

- Modules are the way to configure NixOS declaratively
    ```
    services.xserver.enable = true;
    ```
- NixOS is fully configured via the module system in `configuration.nix`
- Every module manage a particular functionality


# Option declaration - Option definition: Disambiguation

- Option declaration: option creation in the module file (`mkOption`)
- Option definition: setting the option a value in `configuration.nix`


# NixOS modules - Structure

- `options`: The options declared by the module that can be used in `configuration.nix`
- `config`: The module functionality, setup NixOS according to the option definitions


# NixOS modules - Options

- `options` is an attribute set of module options
- The options are declared with the `mkOption` function
- Options have a type set with the `type` key of the `mkOption` argument

    ```
    service.foo.port = mkOption {
      description = "The port that foo is listening";
      type = types.int;
      default = 80;
    };
    ```
- Options are defined in `configuration.nix`

    ```
    service.foo.port = 8080;
    ```

# Module Options - Types

- Types provide mainly 2 functionalities:
    - Type-check of definitions
    - A way to possibly merge multiple options definitions


# Categories of Modules Types

- Types can be separated in 3 categories:
    - simple types: `int`, `str`, ...
    - value types: `enum`
        - `enum [ 2 3 4 ]`, `enum [ "left" "right" ]`
    - composed types: `listOf`, `nullOr`, ...
        - `listOf int`, `nullOr (enum [ "left" "right" ])`


# Extended Option Types (EOT) in a Nutshell

- EOT is a value types only feature (`enum`)
- EOT provides declaration merging for value types
- EOT is a way to "extend" `enum` values through multiple modules


# How does it works

- A main type declaration
- Extended declarations in other module files
- Rules:
    - The main declaration is a normal one
    - Extended declarations **must** only define the `type` (no `description`, `check`, ...)


# Case Study - Without EOT

- A service `foo` support multiple backends, `bar` and `baz`
- `foo`, `bar` and `baz` are managed in different module files
- `foo` backend type declaration:

    ```
    services.foo.backend = mkOption {
      description = "used backend";
      type = types.enum [ "bar" "baz" ];
    };
    ```

- And in the `bar` backend module:

    ```
    config = mkIf (config.services.foo.backend == "bar") {
      ...
    };
    ```

- Potential problems:
    - if a backend is removed, or a new backend added `foo` type declaration must be updated
    - if `foo` and the backend maintainers are different and there are a lot of backends


# Case Study - With EOT

- EOT permits to define a "placeholder" `enum` option:
- `foo` backend type declaration:

    ```
    services.foo.backend = mkOption {
      description = "used backend";
      type = types.enum [ ];
    };
    ```

- and to "extend" it in other module files
- `bar` backend type extension:

    ```
    services.foo.backend = mkOption {
      type = types.enum [ "bar" ];
    };
    ```

- `baz` backend type extension:

    ```
    services.foo.backend = mkOption {
      type = types.enum [ "baz" ];
    };
    ```


# Benefits and use cases

- Improved maintainership
- Work with composed enum types, e.g. `nullOr (enum [])`, `listOf (enum [])`
- More "modular" modules
- Could simplify code using related `enable` options (Window managers, Display managers, ...)


# PR content [#18380](https://github.com/NixOS/nixpkgs/pull/18380)

- added code is relatively small (~100 lines with comments) and simple to understand
- `types.nix`
    - type `functor`
    - type `typeMerge` function
    - `defaultTypeMerge` function
- `module.nix`
    - type merge functionality in the `mergeOptionsDecls`
- some little cleanups


# What's next

- grouping related `enable` options into extended `enums` with backward compatibility (Input methods, Display managers, Window managers, ...)
- `mkChangedOptionModule` and `mkMergedOptionModule` [#18922](https://github.com/NixOS/nixpkgs/pull/18922)
