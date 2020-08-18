module BodyComposition.Form exposing (Form, ValidationError, toggleMassUnit, updateMassAmount, updatePercentage, validate)

import BodyComposition exposing (BodyComposition)
import Mass.Input exposing (MassInput)
import Percentage.Input exposing (PercentageInput)


type alias Form =
    { massInput : MassInput
    , percentageInput : PercentageInput
    }


type ValidationError
    = MassValidationError Mass.Input.ValidationError
    | PctValidationError Percentage.Input.ValidationError


updateMassAmount : String -> Form -> Form
updateMassAmount updatedAmount ({ massInput } as form) =
    { form
        | massInput = massInput |> Mass.Input.updateAmount updatedAmount
    }


toggleMassUnit : Form -> Form
toggleMassUnit ({ massInput } as form) =
    { form
        | massInput = massInput |> Mass.Input.toggleUnit
    }


updatePercentage : String -> Form -> Form
updatePercentage updatedPct form =
    { form
        | percentageInput = Percentage.Input.update updatedPct
    }


validate : Form -> Result (List ValidationError) BodyComposition
validate { massInput, percentageInput } =
    case ( Mass.Input.validate massInput, Percentage.Input.validate percentageInput ) of
        ( Ok mass, Ok pct ) ->
            Ok (BodyComposition mass pct)

        ( Err massError, Err pctError ) ->
            Err [ MassValidationError massError, PctValidationError pctError ]

        ( Err massError, _ ) ->
            Err [ MassValidationError massError ]

        ( _, Err pctError ) ->
            Err [ PctValidationError pctError ]
