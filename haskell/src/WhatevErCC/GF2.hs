module WhatevErCC.GF2 where
    
-- Bit / GF(2) operations

data Bit = B0|B1
    deriving (Eq, Show)

type Vector = [Bit]
type Matrix = [[Bit]]

notBit :: Bit -> Bit
notBit B0 = B1
notBit B1 = B0

addBit :: Bit -> Bit -> Bit
addBit B0 x  = x
addBit B1 B0 = B1
addBit B1 B1 = B0

xor :: Bit -> Bit -> Bit
xor = addBit

mulBit :: Bit -> Bit -> Bit
mulBit B1 B1 = B1
mulBit _  _  = B0

-- Bit-vector operations

parity :: Vector -> Bit
parity [] = B0
parity [x] = x
parity (x:xs) = addBit x (parity xs)

countOne :: Vector -> Int -- find weight as well
countOne [] = 0
countOne (B1:xs) = 1 + countOne xs
countOne (B0:xs) = countOne xs

countZero :: Vector -> Int
countZero [] = 0
countZero (B0:xs) = 1 + countZero xs
countZero (B1:xs) = countZero xs

-- Binary / integer helpers

toInt :: Vector -> Int
toInt [] = 0
toInt (B1:xs) = 1 + 2 * toInt xs
toInt (B0:xs) = 2 * toInt xs

toBin :: Int -> Vector
toBin x
    | x == 0 = [B0]
    | x == 1 = [B1]
    | x `mod` 2 == 1  = B1 : toBin (x `div` 2)
    | otherwise = B0 : toBin (x `div` 2)

extendBin :: Int -> Vector -> Vector
extendBin x xs = xs ++ fillZero x

toLen :: Int -> Int -- should have call floor log but idc
toLen 0 = 1
toLen 1 = 1
toLen x = 1 + toLen (x `div` 2)

isPow2 :: Int -> Bool
isPow2 1 = True
isPow2 x
    | x <= 0        = False
    | x `mod` 2 == 1 = False
    | otherwise     = isPow2 (x `div` 2)

fillZero :: Int -> Vector
fillZero x = replicate x B0