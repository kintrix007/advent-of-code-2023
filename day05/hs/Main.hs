#!/usr/bin/env runhaskell
import           Data.Function
import qualified Data.Text     as T

type Id = Int
type RangeStart = (Int, Int)
type Mapping = [(RangeStart, Int)]

main = do
  ls <- T.splitOn (T.pack "\n\n") . T.pack <$> readFile "input"
  let (seeds, mappings) = parse ls
  -- print seeds
  -- print mappings

  putStr "Part 1: "
  print $ part1 seeds mappings
  -- putStr "Part 2: "
  -- print $ solve2 _

part1 :: [Id] -> [Mapping] -> Int
part1 ids [] = minimum ids
part1 ids (mapping:xs) =
  let ids' = resolveMapping mapping <$> ids
  in part1 ids' xs

resolveMapping :: Mapping -> Id -> Id
resolveMapping [] n = n
resolveMapping (((to, from), count) : ms) n =
  if from <= n && n <= from + count - 1
    then to + (n - from)
    else resolveMapping ms n

parse :: [T.Text] -> ([Id], [Mapping])
parse [] = error "Invalid data format"
parse (seedsTmp:mappingsTmp) = do
  let seeds = read <$> (words . T.unpack . last . T.splitOn (T.pack ": ") $ seedsTmp)
  let foo = mappingsTmp & map (\m -> do
                              m & T.lines & tail & map (parseRange . T.unpack))
  (seeds, foo)

parseRange :: String-> (RangeStart, Int)
parseRange txt = ((startA, startB), range)
  where
    [startA, startB, range] = words txt & map read
