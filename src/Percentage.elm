module Percentage exposing (Percentage, fromFloat, map2)


type Percentage
    = Percentage Float


{-| Create a percentage from a float. 0 is the lowes allowed value.
-}
fromFloat : Float -> Percentage
fromFloat =
    max 0 >> Percentage


map2 : (Float -> Float -> Float) -> Percentage -> Percentage -> Percentage
map2 fn (Percentage pct1) (Percentage pct2) =
    Percentage (fn pct1 pct2)
