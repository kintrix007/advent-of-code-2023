import           Data.Function
import           Data.List.Split
import qualified Data.Text       as T

type Id = Int
type RangeStart = (Id, Id)
type Mapping = [(RangeStart, Int)]

main = do
  ls <- T.splitOn (T.pack "\n\n") . T.pack <$> readFile "input"
  let (seeds, mappings) = parse ls
  -- print seeds
  -- print mappings

  putStr "Part 1: "
  print $ part1 seeds mappings
  putStr "Part 2: "
  print $ part2 seeds mappings

part1 :: [Id] -> [Mapping] -> Id
part1 ids [] = minimum ids
part1 ids (mapping:xs) =
  let ids' = resolveMapping mapping <$> ids
  in part1 ids' xs

part2 :: [Id] -> [Mapping] -> Id
part2 ids = part1 ids'
  where
    ids' = concatMap (\[from, count] -> [from..from+count-1]) $ chunksOf 2 ids

resolveMapping :: Mapping -> Id -> Id
resolveMapping [] n = n
resolveMapping (((to, from), count) : ms) n =
  if from <= n && n <= from + count - 1
    then to + (n - from)
    else resolveMapping ms n

parse :: [T.Text] -> ([Id], [Mapping])
parse [] = error "Invalid data format"
parse (seedsTmp:mappingsTmp) =
  (seeds, foo)
  where
    seeds = seedsTmp
          & words . T.unpack . last . T.splitOn (T.pack ": ")
          & map read
    foo = mappingsTmp
        & map (\m -> m & T.lines & tail & map (parseRange . T.unpack))

parseRange :: String-> (RangeStart, Int)
parseRange txt = ((startA, startB), range)
  where
    [startA, startB, range] = words txt & map read
