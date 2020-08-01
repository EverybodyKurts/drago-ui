module BodyComposition exposing (BodyComposition, basalMetabolicRate, bodyFatMass, leanMusclessMass)

import Calories exposing (Calories)
import Mass exposing (Mass)
import Percentage exposing (Percentage)


type alias BodyComposition =
    { weight : Mass
    , bodyFatPercentage : Percentage
    }


bodyFatMass : BodyComposition -> Mass
bodyFatMass { weight, bodyFatPercentage } =
    Mass.mapPercentage (*) weight bodyFatPercentage


leanMusclessMass : BodyComposition -> Mass
leanMusclessMass ({ weight } as bodyComposition) =
    Mass.map2 (-) weight (bodyFatMass bodyComposition)


{-| Calculate a person's basal metabolic rate based on their lean muscle mass. Uses the Katch-McCardle formula.
-}
basalMetabolicRate : BodyComposition -> Calories
basalMetabolicRate bodyComposition =
    let
        lmm =
            leanMusclessMass bodyComposition
    in
    if Mass.isKg lmm then
        Calories.fromFloat (370 + (21.6 * Mass.toFloat lmm))

    else
        Calories.fromFloat (370 + (9.7976 * Mass.toFloat lmm))
