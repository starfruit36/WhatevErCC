module Main (main) where

main :: IO ()
main = pure ()

data Bit = B0|B1
    deriving (Eq, Show)

xor :: Bit -> Bit -> Bit
xor a b
    |a == b = B0
    |otherwise = B1

countOne :: [Bit] -> Integer
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

findRedundancy :: Integer -> Integer -> Integer
findRedundancy m p
    |2^p >= m + p + 1 = p
    |otherwise = findRedundancy m (p+1)

-- hamming :: Integer -> Integer -> [Bit]
