module BodyComposition exposing (BodyMeasurement, bodyFatMass, leanMusclessMass)

import Mass exposing (Mass)
import Percentage exposing (Percentage)


type alias BodyMeasurement =
    { weight : Mass
    , bodyFatPercentage : Percentage
    }


bodyFatMass : BodyMeasurement -> Mass
bodyFatMass { weight, bodyFatPercentage } =
    Mass.mapPercentage (*) weight bodyFatPercentage


leanMusclessMass : BodyMeasurement -> Mass
leanMusclessMass ({ weight } as bodyMeasurement) =
    Mass.map2 (-) weight (bodyFatMass bodyMeasurement)
