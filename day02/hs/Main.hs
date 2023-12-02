#!/usr/bin/env runhaskell

import           Data.Function
import           Data.Functor
import qualified Data.Text     as T

data CubeSet = CubeSet !Int !Int !Int
  deriving (Show, Eq, Bounded)

getPower :: CubeSet -> Int
getPower (CubeSet a b c) = a*b*c

isWithinLimit :: CubeSet -> Bool
isWithinLimit (CubeSet a b c) =
  let CubeSet x y z = cubesAvailable
  in a <= x && b <= y && c <= z

instance Semigroup CubeSet where
  (CubeSet a b c) <> (CubeSet x y z) = CubeSet (a+x) (b+y) (c+z)

instance Monoid CubeSet where
  mempty = CubeSet 0 0 0

cubesAvailable :: CubeSet
cubesAvailable = CubeSet 12 13 14

maxCubeSets :: CubeSet -> CubeSet -> CubeSet
maxCubeSets (CubeSet a b c) (CubeSet x y z) =
  CubeSet (max a x) (max b y) (max c z)

main = do
  ls <- lines <$> readFile "input"
  let games = map parse ls
  putStr "Part 1: "
  print $ solve1 games
  putStr "Part 2: "
  print $ solve2 games

solve1 :: [[CubeSet]] -> Int
solve1 cubes = zip [1..] sets
             & filter (isWithinLimit . snd)
             & map fst
             & sum
  where
    sets = map (foldl maxCubeSets mempty) cubes

solve2 :: [[CubeSet]] -> Int
solve2 cubes = sum $ map getPower sets
  where
    sets = map (foldl maxCubeSets mempty) cubes

parse :: String -> [CubeSet]
parse line = parseDraw . T.strip <$> T.splitOn (T.pack ";") usefulContent
  where
    usefulContent = T.strip $ T.pack $ tail $ dropWhile (/= ':') line

parseDraw :: T.Text -> CubeSet
parseDraw draw = cubeLists <&> parseCubeList <&> parseCube & mconcat
  where
    cubeLists = draw
          & T.splitOn (T.pack ",")
          <&> T.strip
          <&> T.unpack
    parseCubeList cube = case words cube of
      [num, color] -> (read num :: Int, color)
      _            -> error "Invalid format"

parseCube :: (Int, String) -> CubeSet
parseCube (n, "red")   = CubeSet n 0 0
parseCube (n, "green") = CubeSet 0 n 0
parseCube (n, "blue")  = CubeSet 0 0 n
parseCube _            = error "Invalid cube color"
