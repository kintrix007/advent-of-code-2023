#!/usr/bin/env runhaskell
import           Control.Exception (assert)
import           Data.Char         (isDigit, isSymbol)
import           Data.Function     ((&))

data Pos = Pos !Int !Int deriving (Eq, Show)

data Symbol
  = Symbol
    !Pos -- ^ Position of the Symbol
    !Char -- ^ The symbol itself
  deriving (Eq, Show)

data Number
  = Number
    !Pos -- ^ Position of the number
    !Int -- ^ Width of the number
    !Int -- ^ The number itself
  deriving (Eq, Show)

data Schematic = Schematic [Symbol] [Number] deriving (Eq, Show)

instance Semigroup Schematic where
  Schematic ss1 ns1 <> Schematic ss2 ns2 = Schematic (ss1 <> ss2) (ns1 <> ns2)

instance Monoid Schematic where
  mempty = Schematic [] []

main = do
  ls <- lines <$> readFile "input"
  let schematic = parse ls
  -- print schematic

  putStr "Part 1: "
  print $ part1 schematic
  putStr "Part 2: "
  print $ part2 schematic

part1 :: Schematic -> Int
part1 (Schematic ss ns) = sum $ map (\(Number _ _ n) -> n) numbers
  where
    numbers = ns
            & filter (\(Number pos w n) -> any (\(Symbol p _) -> aabb p pos w) ss)

part2 :: Schematic -> Int
part2 (Schematic ss ns) = foo
  where
    foo = filter (\(Symbol _ c) -> c == '*') ss
        & map (\(Symbol p _) -> filter (\(Number pos w n) -> aabb p pos w) ns)
        & filter (\xs -> length xs == 2)
        & map (product . map (\(Number _ _ n) -> n))
        & sum

aabb :: Pos -> Pos -> Int -> Bool
aabb (Pos cx cy) (Pos nx ny) nw =
  cx >= tlx && cy >= tly && cx <= brx && cy <= bry
  where
    tlx = nx - 1
    tly = ny - 1
    brx = nx + nw
    bry = ny + 1

parse :: [String] -> Schematic
parse lines = mconcat $ zipWith parseLine [0..] $ map (zip [0..]) lines

parseLine :: Int -> [(Int, Char)] -> Schematic
parseLine y [] = mempty
parseLine y line = parseToken y token <> parseLine y rest
  where
    (token, rest) = span (cond . snd) thing
    thing = dropWhile ((== '.') . snd) line
    cond = case thing of
      [] -> const False
      (_, ch):_ -> if isDigit ch
        then isDigit
        else (\x -> x /= '.' && not (isDigit x))

parseToken :: Int -> [(Int, Char)] -> Schematic
parseToken y [] = Schematic [] []
parseToken y [(x, c)] | not $ isDigit c = Schematic [Symbol (Pos x y) c] []
parseToken y ss = Schematic [] [Number (Pos x y) (length cs) (read cs)]
  where
    (x:_, cs) = unzip ss
