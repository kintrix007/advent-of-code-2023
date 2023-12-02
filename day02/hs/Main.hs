#!/usr/bin/env runhaskell

import           Data.Function
import           Data.Functor
import qualified Data.Text      as T
import           Debug.Trace    (trace)

data CubeSet = CubeSet !Int !Int !Int
  deriving (Show, Eq, Bounded)

instance Semigroup CubeSet where
  (CubeSet n i j) <> (CubeSet x y z) = CubeSet (n+x) (i+y) (j+z)

instance Monoid CubeSet where
  mempty = CubeSet 0 0 0

cubesAvailable :: CubeSet
cubesAvailable = CubeSet 12 13 14

maxCubeSets :: CubeSet -> CubeSet -> CubeSet
maxCubeSets (CubeSet n i j) (CubeSet x y z) =
  CubeSet (max n x) (max i y) (max j z)

main = do
  ls <- lines <$> readFile "input"
  let games = map parse ls
  putStr "Part 1: "
  print $ solve1 games

solve1 :: [[CubeSet]] -> Int
solve1 cubes = sum . map fst . filter (\(i, s) -> isWithinLimit s) $ zip [1..] sets
  where
    sets = map (foldl maxCubeSets mempty) cubes

isWithinLimit :: CubeSet -> Bool
isWithinLimit (CubeSet a b c) =
  a <= x && b <= y && c <= z
  where
    CubeSet x y z = cubesAvailable

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
