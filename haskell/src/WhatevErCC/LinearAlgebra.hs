module WhatevErCC.LinearAlgebra where

import WhatevErCC.GF2

-- Matrix helpers

dot :: Vector -> Vector -> Bit
dot xs ys = parity([mulBit x y| (x,y) <- zip xs ys])

getCol :: Matrix -> Int -> Vector
getCol xs a = [row !! a | row <- xs]

makeBasisVec :: Int -> Int -> Vector -- x is dimension, y is position
makeBasisVec x y = fillZero y ++ (B1 : fillZero (x-y-1))

makeId :: Int -> Matrix -- dim
makeId x = [makeBasisVec x y| y <- [0 .. x-1]]

-- Matrix operations

matTrans :: Matrix -> Matrix
matTrans [] = []
matTrans ([]:_) = []
matTrans xs = [head x | x <- xs] : matTrans [tail x | x <- xs]

vecMat :: Vector -> Matrix -> Vector -- implicit row
vecMat xs ys =
    [dot xs y | y <- matTrans ys]

matVec :: Matrix -> Vector -> Vector -- implicit col
matVec xs ys =
    [dot x ys|x <- xs]

matMul :: Matrix -> Matrix -> Matrix
matMul xs ys =
    [[dot x y | y <- ysT] | x <- xs]
    where
        ysT = matTrans ys

matAug :: Matrix -> Matrix -> Matrix
matAug xs ys = zipWith (++) xs ys
