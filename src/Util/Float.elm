module Util.Float exposing (round)


round : Int -> Float -> Float
round precision number =
    let
        operand =
            (10 ^ precision)
                |> toFloat
    in
    (number * operand)
        |> Basics.round
        |> toFloat
        |> (\num -> num / operand)
