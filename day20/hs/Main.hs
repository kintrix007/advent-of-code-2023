#!/usr/bin/env runhaskell

main = do
  ls <- lines <$> readFile "input"
  print ls

  -- putStr "Part 1: "
  -- print $ solve1 _
  -- putStr "Part 2: "
  -- print $ solve2 _
