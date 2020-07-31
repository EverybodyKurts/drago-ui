module Percentage exposing (Percentage, fromFloat, map2, toDecimal, toFloat, toString)


type Percentage
    = Percentage Float


{-| Create a percentage from a float. 0 is the lowest allowed value.
-}
fromFloat : Float -> Percentage
fromFloat =
    clamp 0 100 >> Percentage


map2 : (Float -> Float -> Float) -> Percentage -> Percentage -> Percentage
map2 fn (Percentage pct1) (Percentage pct2) =
    Percentage (fn pct1 pct2)


{-| Convert a percentage to decimal.

    toDecimal (Percentage 30.0) == 0.3

-}
toDecimal : Percentage -> Float
toDecimal (Percentage pct) =
    pct * 0.01


toFloat : Percentage -> Float
toFloat (Percentage flt) =
    flt


toString : Percentage -> String
toString (Percentage flt) =
    flt |> String.fromFloat
