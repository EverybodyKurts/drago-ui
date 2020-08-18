module Percentage.Input exposing (Events, PercentageInput, ValidationError, html, pristine, update, validate)

import Bootstrap
import Bootstrap.InputGroup as InputGroup exposing (inputGroup)
import Html exposing (Html, text)
import Percentage exposing (Percentage)


type alias Events msg =
    { updateMsg : String -> msg
    }


type State
    = Pristine
    | Invalid String
    | Valid Percentage


type alias PercentageInput msg =
    { updateMsg : String -> msg
    , state : State
    }


pristine : Events msg -> PercentageInput msg
pristine { updateMsg } =
    { updateMsg = updateMsg, state = Pristine }


type ValidationError
    = PercentageInputIsEmpty
    | PercentageInputNotNumber String


validate : PercentageInput msg -> Result ValidationError Percentage
validate { state } =
    case state of
        Pristine ->
            Err PercentageInputIsEmpty

        Invalid pctString ->
            case String.toFloat pctString of
                Just pct ->
                    Ok (Percentage.fromFloat pct)

                Nothing ->
                    Err (PercentageInputNotNumber pctString)

        Valid pct ->
            Ok pct


update : String -> PercentageInput msg -> PercentageInput msg
update updatedPct input =
    if String.isEmpty updatedPct then
        { input | state = Pristine }

    else
        { input | state = Invalid updatedPct }


html : PercentageInput msg -> Html msg
html { updateMsg, state } =
    let
        val =
            case state of
                Invalid str ->
                    str

                Valid pct ->
                    pct |> Percentage.toString

                Pristine ->
                    ""

        bfInput =
            { inputMsg = updateMsg
            , placeholder = "Bodyfat %"
            , for = "bodyfat-percentage"
            , value = val
            }
    in
    inputGroup
        [ Bootstrap.textInput bfInput
        , InputGroup.append
            [ InputGroup.text "bodyfat-percentage" [ text "%" ]
            ]
        ]
