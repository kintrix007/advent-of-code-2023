#!/usr/bin/env runhaskell
import           Data.Char     (isDigit)
import           Data.Function ((&))
import           Data.Maybe    (maybeToList)

convertLeadingDigit :: String -> Maybe Char
convertLeadingDigit ('o':'n':'e':_)         = Just '1'
convertLeadingDigit ('t':'w':'o':_)         = Just '2'
convertLeadingDigit ('t':'h':'r':'e':'e':_) = Just '3'
convertLeadingDigit ('f':'o':'u':'r':_)     = Just '4'
convertLeadingDigit ('f':'i':'v':'e':_)     = Just '5'
convertLeadingDigit ('s':'i':'x':_)         = Just '6'
convertLeadingDigit ('s':'e':'v':'e':'n':_) = Just '7'
convertLeadingDigit ('e':'i':'g':'h':'t':_) = Just '8'
convertLeadingDigit ('n':'i':'n':'e':_)     = Just '9'
convertLeadingDigit (x:_) | isDigit x       = Just x
convertLeadingDigit _                       = Nothing

digitsOnly :: String -> String
digitsOnly []     = []
digitsOnly (x:xs) = maybeToList (convertLeadingDigit (x:xs)) ++ digitsOnly xs

main = do
  ls <- lines <$> readFile "input"
  putStr "Part 1: "
  print $ solve1 ls
  putStr "Part 2: "
  print $ solve2 ls

solve1 :: [String] -> Int
solve1 ls = sum . map read $ digits
  where
    digits = map (filter isDigit) ls
           & map (\xs -> [head xs, last xs])

solve2 :: [String] -> Int
solve2 ls = sum . map read $ vals
  where
    vals = map digitsOnly ls
         & map (\xs -> [head xs, last xs])

