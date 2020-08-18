module Percentage.Input exposing (PercentageInput, ValidationError, html, pristine, update, validate)

import Bootstrap
import Bootstrap.InputGroup as InputGroup exposing (inputGroup)
import Html exposing (Html, text)
import Percentage exposing (Percentage)


type PercentageInput
    = Pristine
    | Invalid String
    | Valid Percentage


pristine : PercentageInput
pristine =
    Pristine


type ValidationError
    = PercentageInputIsEmpty
    | PercentageInputNotNumber String


validate : PercentageInput -> Result ValidationError Percentage
validate pctInput =
    case pctInput of
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


update : String -> PercentageInput
update updatedPct =
    if String.isEmpty updatedPct then
        Pristine

    else
        Invalid updatedPct


html : (String -> msg) -> PercentageInput -> Html msg
html updateMsg pctInput =
    let
        val =
            case pctInput of
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
