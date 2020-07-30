module Mass exposing (Mass, isKg, isLb, kg, lb, map, map2, mapPercentage, toFloat, toKg, toLb, toggle, update)

import Percentage exposing (Percentage)
import Util.Float


type Mass
    = Kg Float
    | Lb Float


kg : Float -> Mass
kg =
    abs >> Util.Float.round 2 >> Kg


lb : Float -> Mass
lb =
    abs >> Util.Float.round 2 >> Lb


update : Float -> Mass -> Mass
update amt mass =
    case mass of
        Lb _ ->
            lb amt

        Kg _ ->
            kg amt


isKg : Mass -> Bool
isKg mass =
    case mass of
        Kg _ ->
            True

        _ ->
            False


isLb : Mass -> Bool
isLb mass =
    case mass of
        Lb _ ->
            True

        _ ->
            False


toFloat : Mass -> Float
toFloat mass =
    case mass of
        Lb l ->
            l

        Kg k ->
            k


{-| Convert from lb to kg
-}
toKg : Mass -> Mass
toKg mass =
    case mass of
        Lb float ->
            kg (float / 2.20462262185)

        _ ->
            mass


{-| Convert from kg to lb
-}
toLb : Mass -> Mass
toLb mass =
    case mass of
        Kg float ->
            lb (float * 2.20462262185)

        _ ->
            mass


toggle : Mass -> Mass
toggle mass =
    case mass of
        Lb _ ->
            toKg mass

        _ ->
            toLb mass


map : (Float -> Float) -> Mass -> Mass
map fn mass =
    case mass of
        Lb float ->
            Lb (fn float)

        Kg float ->
            Kg (fn float)


{-| Map 2 argument float functions into mass.

    map2 (*) (Lb 1.0) (Kg 2.2) == Kg 4.4

-}
map2 : (Float -> Float -> Float) -> Mass -> Mass -> Mass
map2 fn mass1 mass2 =
    case mass2 of
        Lb m ->
            Lb (fn (mass1 |> toLb |> toFloat) m)

        Kg m ->
            Kg (fn (mass1 |> toKg |> toFloat) m)


mapPercentage : (Float -> Float -> Float) -> Mass -> Percentage -> Mass
mapPercentage fn mass percentage =
    case mass of
        Lb l ->
            Lb (fn l (Percentage.toDecimal percentage))

        Kg k ->
            Kg (fn k (Percentage.toDecimal percentage))
