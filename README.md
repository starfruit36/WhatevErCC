# (What)e(ver)cc

An error-correcting-code project. How original.

## Run

With GHC and Cabal installed:

```sh
cd haskell
cabal build
cabal run
```

`cabal repl` opens the package in GHCi.

## Files

* `haskell/whatevercc.cabal`: package, library, and executable configuration.
* `haskell/cabal.project`: selects the local package.
* `haskell/app/Main.hs`: executable entry point; I/O will go here when it go here.
* `haskell/src/WhatevErCC/GF2.hs`: bit and GF(2) operations.
* `haskell/src/WhatevErCC/LinearAlgebra.hs`: vector and matrix operations.
* `haskell/src/WhatevErCC/DeliciousHam.hs`: Hamming code family.
* `.gitignore`: excludes build output and local environment files.

Functions assume well-formed input. If not, well. 
