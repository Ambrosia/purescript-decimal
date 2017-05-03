module Test.Main where

import Prelude
import Data.Int as Int
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Random (RANDOM)
import Data.Decimal (Decimal, abs, fromInt, fromString, pow, toNumber, toString, intDiv)
import Data.Foldable (fold)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.NonEmpty ((:|))
import Test.Assert (ASSERT, assert)
import Test.QuickCheck (QC, quickCheck)
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Gen (Gen, chooseInt, arrayOf, elements)

-- | Newtype with an Arbitrary instance that generates only small integers
newtype SmallInt = SmallInt Int

instance arbitrarySmallInt :: Arbitrary SmallInt where
  arbitrary = SmallInt <$> chooseInt (-5) 5

runSmallInt :: SmallInt -> Int
runSmallInt (SmallInt n) = n

-- | Arbitrary instance for Decimal
newtype TestDecimal = TestDecimal Decimal

instance arbitraryDecimal :: Arbitrary TestDecimal where
  arbitrary = do
    n <- (fromMaybe zero <<< fromString) <$> digitString
    op <- elements (id :| [negate])
    pure (TestDecimal (op n))
    where digits :: Gen Int
          digits = chooseInt 0 9
          digitString :: Gen String
          digitString = (fold <<< map show) <$> arrayOf digits

-- | Convert SmallInt to Decimal
fromSmallInt :: SmallInt -> Decimal
fromSmallInt = fromInt <<< runSmallInt

-- | Test if a binary relation holds before and after converting to BigInt.
testBinary :: forall eff. (Decimal -> Decimal -> Decimal)
           -> (Int -> Int -> Int)
           -> QC eff Unit
testBinary f g = quickCheck (\x y -> (fromInt x) `f` (fromInt y) == fromInt (x `g` y))

main :: forall eff. Eff (console :: CONSOLE, assert :: ASSERT, random :: RANDOM, exception :: EXCEPTION | eff) Unit
main = do
  log "Simple arithmetic operations and conversions from Int"
  let two = one + one
  let three = two + one
  let four = three + one
  assert $ fromInt 3 == three
  assert $ two * two == four
  assert $ two * three * (three + four) == fromInt 42
  assert $ two - three == fromInt (-1)

  log "Parsing strings"
  assert $ fromString "2" == Just two
  assert $ fromString "a" == Nothing
  assert $ fromString "2.1" == Just (two + (one / fromInt 10))
  assert $ fromString "123456789" == Just (fromInt 123456789)
  assert $ fromString "1e7" == Just (fromInt 10000000)
  quickCheck $ \(TestDecimal a) -> (fromString <<< toString) a == Just a

  log "Conversions between String, Int and Decimal should not lose precision"
  quickCheck (\n -> fromString (show n) == Just (fromInt n))
  quickCheck (\n -> Int.toNumber n == toNumber (fromInt n))

  log "Binary relations between integers should hold before and after converting to BigInt"
  testBinary (+) (+)
  testBinary (-) (-)
  testBinary intDiv (/)
  testBinary mod mod
  testBinary intDiv div

  -- To test the multiplication, we need to make sure that Int does not overflow
  quickCheck (\x y -> fromSmallInt x * fromSmallInt y == fromInt (runSmallInt x * runSmallInt y))

  log "It should perform multiplications which would lead to imprecise results using Number"
  assert $ Just (fromInt 333190782 * fromInt 1103515245) == fromString "367681107430471590"

  log "compare, (==), even, odd should be the same before and after converting to Decimal"
  quickCheck (\x y -> compare x y == compare (fromInt x) (fromInt y))
  quickCheck (\x y -> (fromSmallInt x == fromSmallInt y) == (runSmallInt x == runSmallInt y))

  log "pow should perform integer exponentiation"
  assert $ three `pow` four == fromInt 81
  assert $ three `pow` zero == one
  assert $ zero `pow` zero == one

  log "Absolute value"
  quickCheck $ \(TestDecimal x) -> abs x == if x > zero then x else (-x)
