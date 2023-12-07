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
  case maximum counts of
    1 -> HighCard
    2 -> if isTwoPairs then TwoPairs else OnePair
    3 -> if isFullHouse then FullHouse else ThreeOfAKind
    4 -> FourOfAKind
    5 -> FiveOfAKind
    _ -> error "Invalid hand"
  where
    counts = h & map (\c -> h & filter (== c) & length)
    isFullHouse = sort counts == [2,2,3,3,3]
    isTwoPairs = sort counts == [1,2,2,2,2]

main = do
  cont <- lines <$> readFile "input"
  let games = map parse cont

  putStr "Part 1: "
  print $ part1 games

part1 :: [(Hand, Int)] -> Int
part1 games = sum $ zipWith (\i (_, b) -> i * b) [1..] ordered
  where
    ordered = sortOn fst games

parse :: String -> (Hand, Int)
parse line =
  let [cardsTmp, bidTmp] = words line
  in (Hand $ map parseCard cardsTmp, read bidTmp)

parseCard :: Char -> Card
parseCard ch | isDigit ch = read [ch]
parseCard 'T' = 10
parseCard 'J' = 11
parseCard 'Q' = 12
parseCard 'K' = 13
parseCard 'A' = 14
parseCard _ = error "Invalid card"
