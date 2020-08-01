module Calories exposing (Calories, fromFloat)


type Calories
    = Calories Float


fromFloat : Float -> Calories
fromFloat =
    Calories << max 0
