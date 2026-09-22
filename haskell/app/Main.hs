module Main (main) where

main :: IO ()
main = pure ()

{-Implicitly assume everything here has no malformed input. explicit check is done at i/o.
TODO: 
maybe test file + defense check when i feel like
Write I/O -> Vector for read operation, maybe read vector in a file, or a list of vectors, we will assume a jagged matrix
of col vector if multiple are represented, each are unique message
Return vector -> I/O vector using post process (or string? write a file? idk, maybe the point is not return, we'll see)
-}