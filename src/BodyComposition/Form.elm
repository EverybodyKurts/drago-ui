module BodyComposition.Form exposing (BodyCompositionForm, Events, ValidationError, card, pristine, toggleMassUnit, updateBodyFat, updateMassAmount, validate)

import BodyComposition exposing (BodyComposition)
import Bootstrap
import Bootstrap.Card as Card
import Bootstrap.Form as Form
import Html exposing (Html, text)
import Mass.Input exposing (MassInput)
import Percentage.Input exposing (PercentageInput)


type alias Events msg =
    { updateMassAmountMsg : String -> msg
    , toggleMassUnitMsg : msg
    , updateBodyFatMsg : String -> msg
    }


type alias BodyCompositionForm msg =
    { massInput : MassInput msg
    , bodyFatInput : PercentageInput msg
    }


type ValidationError
    = MassValidationError Mass.Input.ValidationError
    | PctValidationError Percentage.Input.ValidationError


pristine : Events msg -> BodyCompositionForm msg
pristine { updateMassAmountMsg, toggleMassUnitMsg, updateBodyFatMsg } =
    { massInput = Mass.Input.pristine { updateAmountMsg = updateMassAmountMsg, toggleUnitMsg = toggleMassUnitMsg }
    , bodyFatInput = Percentage.Input.pristine { updateMsg = updateBodyFatMsg }
    }


updateMassAmount : String -> BodyCompositionForm msg -> BodyCompositionForm msg
updateMassAmount updatedAmount ({ massInput } as form) =
    { form
        | massInput = massInput |> Mass.Input.updateAmount updatedAmount
    }


toggleMassUnit : BodyCompositionForm msg -> BodyCompositionForm msg
toggleMassUnit ({ massInput } as form) =
    { form
        | massInput = Mass.Input.toggleUnit massInput
    }


updateBodyFat : String -> BodyCompositionForm msg -> BodyCompositionForm msg
updateBodyFat updatedPct ({ bodyFatInput } as form) =
    { form
        | bodyFatInput = bodyFatInput |> Percentage.Input.update updatedPct
    }


validate : BodyCompositionForm msg -> Result (List ValidationError) BodyComposition
validate { massInput, bodyFatInput } =
    case ( Mass.Input.validate massInput, Percentage.Input.validate bodyFatInput ) of
        ( Ok mass, Ok pct ) ->
            Ok (BodyComposition mass pct)

        ( Err massError, Err pctError ) ->
            Err [ MassValidationError massError, PctValidationError pctError ]

        ( Err massError, _ ) ->
            Err [ MassValidationError massError ]

        ( _, Err pctError ) ->
            Err [ PctValidationError pctError ]


card : BodyCompositionForm msg -> Html msg
card { massInput, bodyFatInput } =
    Card.card
        [ Card.primaryHeader [ text "Body Composition" ]
        , Card.body
            [ Form.row
                [ Bootstrap.col
                    [ Mass.Input.html
                        massInput
                    ]
                ]
            , Form.row
                [ Bootstrap.col
                    [ Percentage.Input.html
                        bodyFatInput
                    ]
                ]
            ]
        ]
