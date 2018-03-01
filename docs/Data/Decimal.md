## Module Data.Decimal

This module defines a `Decimal` data type for arbitrary length integers.

#### `Decimal`

``` purescript
data Decimal :: Type
```

An arbitrary length integer.

##### Instances
``` purescript
Eq Decimal
Ord Decimal
Show Decimal
Semiring Decimal
Ring Decimal
CommutativeRing Decimal
EuclideanRing Decimal
```

#### `fromString`

``` purescript
fromString :: String -> Maybe Decimal
```

Parse a string into a `Decimal`, assuming a decimal representation. Returns
`Nothing` if the parse fails.

Examples:
```purescript
fromString "42"
fromString "857981209301293808359384092830482"
fromString "1e100"
```

#### `fromInt`

``` purescript
fromInt :: Int -> Decimal
```

Convert an integer to a Decimal.

#### `fromNumber`

``` purescript
fromNumber :: Number -> Decimal
```

Convert a number to a Decimal.

#### `toString`

``` purescript
toString :: Decimal -> String
```

A decimal representation of the `Decimal` as a `String`.

#### `abs`

``` purescript
abs :: Decimal -> Decimal
```

The absolute value.

#### `pow`

``` purescript
pow :: Decimal -> Decimal -> Decimal
```

Exponentiation for `Decimal`. If the exponent is less than 0, `pow`
returns 0. Also, `pow zero zero == one`.

#### `toNumber`

``` purescript
toNumber :: Decimal -> Number
```

Converts a Decimal to a Number. Loses precision for numbers which are too
large.

#### `intDiv`

``` purescript
intDiv :: Decimal -> Decimal -> Decimal
```

#### `floor`

``` purescript
floor :: Decimal -> Decimal
```

#### `ceil`

``` purescript
ceil :: Decimal -> Decimal
```

#### `toNearest`

``` purescript
toNearest :: Decimal -> Decimal
```

#### `truncated`

``` purescript
truncated :: Decimal -> Decimal
```

#### `isInteger`

``` purescript
isInteger :: Decimal -> Boolean
```


