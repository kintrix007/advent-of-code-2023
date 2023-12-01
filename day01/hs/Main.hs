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
convertLeadingDigit _                       = Nothing

digitsOnly :: String -> String
digitsOnly [] = []
digitsOnly (x:xs)
  | isDigit x = x : digitsOnly xs
  | otherwise = maybeToList (convertLeadingDigit (x:xs)) ++ digitsOnly xs

main = do
  ls <- lines <$> readFile "input"
  let vals = map digitsOnly ls
           & map (\xs -> [head xs, last xs])
  print $ sum . map read $ vals
