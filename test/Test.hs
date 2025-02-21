{-# LANGUAGE OverloadedStrings #-}
import Test.Tasty

-- import Data.Equality.Utils
import Invariants
import Sym
import Lambda
import SimpleSym

tests :: TestTree
tests = testGroup "Tests"
  [ symTests
  , lambdaTests
  , simpleSymTests
  , invariants
  ]

main :: IO ()
main = defaultMain tests

-- main :: IO ()
-- main = do
--     print $ Sym.rewrite (Fix $ BinOp Integral (Fix $ BinOp Pow "x" 1) "x")

-- main :: IO ()
-- main = do
--   print $ Sym.rewrite (_i (_ln "x") "x")
--   putStrLn "Expecting: x*ln(x) + (-1)"
