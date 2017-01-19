
# Packaging examples


Normal building:

```
$ nix-build nixos-2017-01/examples/1-trivial.nix
```

Or steps can be decomposed:

```
$ nix-instantiate nixos-2017-01/examples/1-trivial.nix
$ nix-store -r /PATH/TO/DERIVATION
```
