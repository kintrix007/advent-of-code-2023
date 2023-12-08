import           Data.Function   ((&))
import           Data.List       (isSuffixOf)
import           Data.List.Split (splitOn)
import qualified Data.Map        as M

type Nodes = M.Map String (String, String)
type Turn = (String, String) -> String

main = do
  cont <-  readFile "input"
  let (turns, nodes) = parse cont

  putStr "Part 2: "
  print $ solve turns nodes

solve :: [Turn] -> Nodes -> Int
solve turns nodes =
  foldl lcm 1 $ map stepsNeeded startDirs
  where
    startDirs = filter (\(n, _) -> "A" `isSuffixOf` n) $ M.toList nodes
    stepsNeeded start = scanl (step nodes) start (cycle turns)
      & takeWhile (\(n, _) -> not $ "Z" `isSuffixOf` n)
      & length

step :: Nodes -> (String, (String, String)) -> Turn -> (String, (String, String))
step nodes (_, dirs) turn = (turn dirs, dirs')
  where
    Just dirs' = M.lookup (turn dirs) nodes

parse :: String -> ([Turn], Nodes)
parse s = (map parseDir dirsTmp, M.fromList $ map parseNode $ lines nodesTmp)
  where
    [dirsTmp, nodesTmp] = splitOn "\n\n" s

parseDir :: Char -> Turn
parseDir 'L' = fst
parseDir 'R' = snd
parseDir _   = error "Invalid direction"

parseNode :: String -> (String, (String, String))
parseNode s = (name, (l, r))
  where
    [name, destsTmp] = splitOn " = " s
    [l, r] = splitOn ", " $ tail . init $ destsTmp
