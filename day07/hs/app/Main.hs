import           Data.Char     (isDigit)
import           Data.Function
import           Data.List

data Kind
  = HighCard
  | OnePair
  | TwoPairs
  | ThreeOfAKind
  | FullHouse
  | FourOfAKind
  | FiveOfAKind
  deriving (Eq, Ord, Enum, Show)

type Card = Int

newtype Hand = Hand [Card]
  deriving (Eq, Show)

instance Ord Hand where
  compare h1@(Hand a) h2@(Hand b) =
    (compare `on` getKind) h1 h2 <> compare a b

getKind :: Hand -> Kind
getKind (Hand h) =
  case maximum (0:counts) + j of
    1 -> HighCard
    2 -> if isTwoPairs then TwoPairs else OnePair
    3 -> if isFullHouse then FullHouse else ThreeOfAKind
    4 -> FourOfAKind
    5 -> FiveOfAKind
    _ -> error "Invalid hand"
  where
    counts = nonJoker & map (\c -> nonJoker & filter (== c) & length)
    isFullHouse = nub (sort counts) == [2,3]
      || nub (sort counts) == [2] && j == 1
    isTwoPairs = length (filter (== 2) counts) == 4
    (nonJoker, jokerCards) = partition (/= 1) h
    j = length jokerCards


main = do
  cont <- lines <$> readFile "input"
  let games = map parse cont

  -- putStrLn $ unlines $ map show $ zip (map fst games) (map (getKind . fst) games)
  putStr "Part 2: "
  print $ solve games

solve :: [(Hand, Int)] -> Int
solve games = sum $ zipWith (\i (_, b) -> i * b) [1..] ordered
  where
    ordered = sortOn fst games

parse :: String -> (Hand, Int)
parse line =
  let [cardsTmp, bidTmp] = words line
  in (Hand $ map parseCard cardsTmp, read bidTmp)

parseCard :: Char -> Card
parseCard 'J' = 1
parseCard ch | isDigit ch = read [ch]
parseCard 'T' = 10
parseCard 'Q' = 12
parseCard 'K' = 13
parseCard 'A' = 14
parseCard _ = error "Invalid card"
