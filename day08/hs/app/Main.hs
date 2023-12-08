import           Data.Function
import           Data.List
import           Data.List.Split

type Node = (String, (String, String))
type Turn = (String, String) -> String

main = do
  cont <-  readFile "input"
  let (turns, nodes) = parse cont

  putStr "Part 1: "
  print $ solve turns nodes

solve :: [Turn] -> [Node] -> Int
solve turns nodes =
  length $ takeWhile (\(n, _) -> n /= "ZZZ") $ scanl (step nodes) start (cycle turns)
  where
    Just startDirs = lookup "AAA" nodes
    start = ("AAA", startDirs) :: Node

step :: [Node] -> Node -> Turn -> Node
step nodes (_, dirs) turn = (turn dirs, dirs')
  where
    Just dirs' = lookup (turn dirs) nodes

parse :: String -> ([Turn], [Node])
parse s = (map parseDir dirsTmp, map parseNode $ lines nodesTmp)
  where
    [dirsTmp, nodesTmp] = splitOn "\n\n" s

parseDir :: Char -> Turn
parseDir 'L' = fst
parseDir 'R' = snd
parseDir _   = error "Invalid direction"

parseNode :: String -> Node
parseNode s = (name, (l, r))
  where
    [name, destsTmp] = splitOn " = " s
    [l, r] = splitOn ", " $ tail . init $ destsTmp
