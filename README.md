# (What)e(ver)cc

An error-correcting-code project. How original.

## Run the Haskell starter

With GHC and Cabal installed:

```sh
cd haskell
cabal run
```

`cabal repl` opens its interactive environment.

## Files

- `haskell/whatevercc.cabal`: package and executable configuration.
- `haskell/cabal.project`: selects the local package.
- `haskell/app/Main.hs`: 1 giant monolith, split later.
- `.gitignore`: excludes Haskell and Python build output and local environments.
