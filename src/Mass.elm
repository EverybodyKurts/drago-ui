module Mass exposing (kg, kgToLb, lb, lbToKg, map)

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


{-| Convert from lb to kg
-}
lbToKg : Mass -> Mass
lbToKg mass =
    case mass of
        Lb float ->
            kg (float / 2.20462262185)

        _ ->
            mass


{-| Convert from kg to lb
-}
kgToLb : Mass -> Mass
kgToLb mass =
    case mass of
        Kg float ->
            lb (float * 2.20462262185)

        _ ->
            mass


map : (Float -> Float) -> Mass -> Mass
map fn mass =
    case mass of
        Lb float ->
            Lb (fn float)

        Kg float ->
            Kg (fn float)
