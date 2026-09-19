module Main (main) where

main :: IO ()
main = pure ()

{-Implicitly assume everything here has no malformed input. explicit check is done at i/o.
TODO: i/o + seperate module later + maybe test file + defense check when i feel like
SECDED-}


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
parity [] = []
parity [x] = x
parity (x:xs) = addBit x (parity xs)

dot :: Vector -> Vector -> Bit
dot xs ys = parity([mulBit x y| (x,y) <- zip xs ys])

countOne :: Vector -> Int -- find weight as well
countOne [] = 0
countOne (B1:xs) = 1 + countOne xs
countOne (B0:xs) = countOne xs

countZero :: Vector -> Int
countZero [] = 0
countZero (B0:xs) = 1 + countZero xs
countZero (B1:xs) = countZero xs


-- Matrix helpers

getCol :: Matrix -> Int -> Vector
getCol xs a = [row !! a | row <- xs]

fillZero :: Int -> Vector
fillZero x = replicate x B0

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


-- Hamming code construction

findRedundancy :: Int -> Int -> Int -- 2^r >= n + 1, n = m + p
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


-- Error correction

fixMistake :: Int -> Vector -> Vector -- int = index
fixMistake 0 x = x
fixMistake a x = i ++ (notBit j : k)
    where
        (i, j:k) = splitAt (a - 1) x