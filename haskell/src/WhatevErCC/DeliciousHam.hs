module WhatevErCC.DeliciousHam where

import WhatevErCC.GF2
import WhatevErCC.LinearAlgebra

-- Hamming code construction

findRedundancy :: Int -> Int -> Int -- 2^p >= n + 1, n = m + p
findRedundancy m p
    |2^p >= m + p + 1 = p
    |otherwise = findRedundancy m (p+1)

makeHam :: Int -> Matrix -- n = num of received bit (or transmit?) eitherway
makeHam n =
    matTrans
        [   let x = toBin a
            in extendBin (toLen n - length x) x
            |a <- [1 .. n]
        ]

makeGenRow :: Int -> Int -> Vector -- n = yeah, c = col

makeGenRow n c =
    [fill p | p <- [1 .. n]]
    where
        ps = extendBin (toLen n - toLen c) (toBin c) -- parity pattern, 2^i of the hamming col

        fill p
            | p == c    = B1
            | isPow2 p  = ps !! (toLen p - 1)
            | otherwise = B0

makeGen :: Int -> Matrix -- n = yeah
makeGen n =
    [makeGenRow n d | d <- [1 .. n], not (isPow2 d)]

cutVec :: Vector -> Vector
cutVec [] = []
cutVec xs = init xs

-- Error correction

fixMistake :: Int -> Vector -> Vector -- int = index
fixMistake 0 x = x
fixMistake a x = i ++ (notBit j : k)
    where
        (i, j:k) = splitAt (a - 1) x

makeCode :: Int -> Vector -> Vector
makeCode x xs = c ++ [parity c]
    where  
        c = vecMat xs (makeGen (x+r))
        r = findRedundancy x 0

doubleDet :: Int -> Vector -> (Vector, Bool) -- int = message len
doubleDet x xs 
    |syndrome == zero && pari == B0 = (xs, True)
    |syndrome /= zero && pari == B1 = (fixMistake pos xs, True)
    |syndrome == zero && pari == B1 = (fixMistake (length xs) xs, True)
    |syndrome /= zero && pari == B0 = (xs, False) --double error
    where
        code = cutVec xs
        r = findRedundancy x 0
        n = x + r
        zero = fillZero (toLen n)
        syndrome = matVec (makeHam n) code
        pari = parity xs
        pos = toInt syndrome

findLen :: Int -> Int -> Int
findLen n p 
    |2^p >= n + 1 = (n - p)
    |otherwise = findLen n (p+1)

postProcess :: Int -> Vector -> Vector -- int = message len, not recieved len, aka k instead of n
postProcess _ [] = []
postProcess x xs = fst (splitAt x xs)