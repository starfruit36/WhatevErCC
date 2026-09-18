module Main (main) where

main :: IO ()
main = pure ()

{-Implicitly assume everything here has no malformed input. explicit check is done at i/o.
TODO: i/o + seperate module later + maybe test file + defense check when i feel like
SECDED-}


-- Bit / GF(2) operations

data Bit = B0|B1
    deriving (Eq, Show)

xor :: Bit -> Bit -> Bit
xor a b
    |a == b = B0
    |otherwise = B1

notBit :: Bit -> Bit
notBit B0 = B1
notBit B1 = B0

addBit :: Bit -> Bit -> Bit
addBit B0 x  = x
addBit B1 B0 = B1
addBit B1 B1 = B0

mulBit :: Bit -> Bit -> Bit
mulBit B1 B1 = B1
mulBit _  _  = B0


-- Bit-vector operations

parity :: [Bit] -> Bit
parity [x] = x
parity (x:y:xs) = parity (addBit x y : xs)

dot :: [Bit] -> [Bit] -> Bit
dot xs ys = parity([mulBit x y| (x,y) <- zip xs ys])

countOne :: [Bit] -> Integer -- find weight as well
countOne [] = 0
countOne (B1:xs) = 1 + countOne xs
countOne (B0:xs) = countOne xs

countZero :: [Bit] -> Integer
countZero [] = 0
countZero (B0:xs) = 1 + countZero xs
countZero (B1:xs) = countZero xs


-- Matrix helpers

getCol :: [[Bit]] -> Int -> [Bit]
getCol xs a = [row !! a | row <- xs]

fillZero :: Integer -> [Bit]
fillZero 0 = []
fillZero x = [B0] ++ fillZero (x -1)

makeBasisVec :: Integer -> Integer -> [Bit] -- x is dimension, y is position
makeBasisVec x y = fillZero y ++ [B1] ++ fillZero (x-y-1)

makeId :: Integer -> [[Bit]] -- dim
makeId x = [makeBasisVec x y| y <- [0 .. x-1]]


-- Matrix operations

matTrans :: [[Bit]] -> [[Bit]]
matTrans xs = [getCol xs a| a <- [0 .. length (head xs) - 1]]

vecMat :: [Bit]   -> [[Bit]] -> [Bit] -- implicit row
vecMat xs ys =
    [dot xs (getCol ys a) | a <- [0 .. length (head ys) - 1]]

matVec :: [[Bit]] -> [Bit]   -> [Bit] -- implicit col
matVec xs ys =
    [dot x ys|x <- xs]

matMul :: [[Bit]] -> [[Bit]] -> [[Bit]]
matMul xs ys =
    [[dot x (getCol ys a)| a <- [0 .. length (head ys) - 1]]
    |x<-xs]

matAug :: [[Bit]] -> [[Bit]] -> [[Bit]]
matAug xs ys = [x ++ y| (x,y) <- zip xs ys]


-- Binary / integer helpers

toInt :: [Bit] -> Integer
toInt [] = 0
toInt (B1:xs) = 1 + 2 * toInt xs
toInt (B0:xs) = 2 * toInt xs

toBin :: Integer -> [Bit]
toBin x
    | x == 0 = [B0]
    | x == 1 = [B1]
    | x `mod` 2 == 1  = [B1] ++ toBin (x `div` 2)
    | otherwise = [B0] ++ toBin (x `div` 2)

extendBin :: Integer -> [Bit] -> [Bit]
extendBin 0 xs = xs
extendBin x xs = extendBin (x-1) xs ++ [B0]

toLen :: Integer -> Integer -- should have call floor log but idc
toLen 0 = 1
toLen 1 = 1
toLen x = 1 + toLen (x `div` 2)

isPow2 :: Integer -> Bool
isPow2 1 = True
isPow2 x
    | x <= 0        = False
    | x `mod` 2 == 1 = False
    | otherwise     = isPow2 (x `div` 2)


-- Hamming code construction

findRedundancy :: Integer -> Integer -> Integer -- 2^r >= n + 1, n = m + p
findRedundancy m p
    |2^p >= m + p + 1 = p
    |otherwise = findRedundancy m (p+1)

makeHam :: Integer -> [[Bit]] -- n = num of received bit (or transmit?) eitherway
makeHam n =
    matTrans
        [   let x = toBin a
            in extendBin (toLen n - fromIntegral (length x)) x
            |a <- [1 .. n]
        ]

makeGenRow :: Integer -> Integer -> [Bit] -- n = yeah, c = col

makeGenRow n c =
    [fill p | p <- [1 .. n]]
    where
        ps = extendBin (toLen n - toLen c) (toBin c) -- parity pattern, 2^i of the hamming col

        fill p
            | p == c    = B1
            | isPow2 p  = ps !! fromIntegral (toLen p - 1)
            | otherwise = B0

makeGen :: Integer -> [[Bit]] -- n = yeah
makeGen n =
    [makeGenRow n d | d <- [1 .. n], not (isPow2 d)]


-- Error correction

fixMistake :: Int -> [Bit] -> [Bit] -- int = index
fixMistake 0 x = x
fixMistake a x = i ++ [notBit j] ++ k
    where
        i = fst (splitAt (a-1) x)
        j = x !! (a-1)
        k = snd (splitAt a x)