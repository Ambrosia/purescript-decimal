-- | This module defines a `Decimal` data type for arbitrary length integers.
module Data.Decimal
  ( Decimal(..)
  , fromString
  , fromInt
  , fromNumber
  , toString
  , abs
  , pow
  , toNumber
  , intDiv
  ) where

import Prelude

import Data.Maybe (Maybe(..))

-- | An arbitrary length integer.
foreign import data Decimal :: Type

-- | FFI wrapper to parse a String into a Decimal.
foreign import construct :: forall a. (a -> Maybe a)
                         -> Maybe a
                         -> String
                         -> Maybe Decimal

-- | Convert an integer to a Decimal.
foreign import fromInt :: Int -> Decimal

-- | Convert a number to a Decimal.
foreign import fromNumber :: Number -> Decimal

-- | Converts a Decimal to a Number. Loses precision for numbers which are too
-- | large.
foreign import toNumber :: Decimal -> Number

-- | Exponentiation for `Decimal`. If the exponent is less than 0, `pow`
-- | returns 0. Also, `pow zero zero == one`.
foreign import pow :: Decimal -> Decimal -> Decimal

-- | The absolute value.
foreign import abs :: Decimal -> Decimal

-- | Parse a string into a `Decimal`, assuming a decimal representation. Returns
-- | `Nothing` if the parse fails.
-- |
-- | Examples:
-- | ```purescript
-- | fromString "42"
-- | fromString "857981209301293808359384092830482"
-- | fromString "1e100"
-- | ```
fromString :: String -> Maybe Decimal
fromString = construct Just Nothing

foreign import dEquals :: Decimal -> Decimal -> Boolean

instance eqDecimal :: Eq Decimal where
  eq = dEquals

foreign import dCompare :: Decimal -> Decimal -> Int

instance ordDecimal :: Ord Decimal where
  compare x y = case dCompare x y of
                  1 -> GT
                  0 -> EQ
                  _ -> LT

-- | A decimal representation of the `Decimal` as a `String`.
foreign import toString :: Decimal -> String

instance showDecimal :: Show Decimal where
  show x = "fromString \"" <> toString x <> "\""

foreign import dAdd :: Decimal -> Decimal -> Decimal
foreign import dMul :: Decimal -> Decimal -> Decimal

instance semiringDecimal :: Semiring Decimal where
  add  = dAdd
  zero = fromInt 0
  mul  = dMul
  one  = fromInt 1

foreign import dSub :: Decimal -> Decimal -> Decimal

instance ringDecimal :: Ring Decimal where
  sub = dSub

foreign import dDiv :: Decimal -> Decimal -> Decimal
foreign import dMod :: Decimal -> Decimal -> Decimal

instance commutativeRingDecimal :: CommutativeRing Decimal

instance euclideanRingDecimal :: EuclideanRing Decimal where
  div = dDiv
  mod = dMod
  degree = degree <<< toNumber

foreign import intDiv :: Decimal -> Decimal -> Decimal
