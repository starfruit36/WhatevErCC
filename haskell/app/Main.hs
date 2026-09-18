module Main (main) where

main :: IO ()
main = pure ()

data Bit = B0|B1
    deriving (Eq, Show)

xor :: Bit -> Bit -> Bit
xor a b
    |a == b = B0
    |otherwise = B1

not :: Bit -> Bit
not B0 = B1
not B1 = B0

addBit :: Bit -> Bit -> Bit
addBit B0 x  = x
addBit B1 B0 = B1
addBit B1 B1 = B0

mulBit :: Bit -> Bit -> Bit
mulBit B1 B1 = B1
mulBit _  _  = B0

countOne :: [Bit] -> Integer -- find weight as well
countOne [] = 0
countOne (B1:xs) = 1 + countOne xs
countOne (B0:xs) = countOne xs

countZero :: [Bit] -> Integer
countZero [] = 0
countZero (B0:xs) = 1 + countZero xs
countZero (B1:xs) = countZero xs

majority :: [Bit] -> Maybe Bit
majority [] = Nothing
majority xs 
    |countZero xs > countOne xs = B0
    |otherwise = Nothing

findRedundancy :: Integer -> Integer -> Integer --2^r >= n + 1, n = m + p
findRedundancy m p
    |2^p >= m + p + 1 = p   
    |otherwise = findRedundancy m (p+1)

{-Todo: SEC edition
 matrix mul use list comprehension.
In fact, maybe matrix data, though pretty useless with [[Bit]]
matrix augmentation needed using list operation
construct hamming matrix k*n, where position 2^i = p diagonal of I, the rest are lexical order.
construct the generator matrix I|P (for consistency, the hamming matrix might be A|I*P,so use that A to derive G using I|A^TP)
transpose needed, using list comprehension
construct code word, using xG = c, for all x span 2^k
maybe implement bsc ish error simulation, not too sure
map a mapping on what to do (aka, the inverse of hamming matrix construction to find index using symptom and flip). 
So prlly binary expansion needed, bin to int and int to bin
-}

