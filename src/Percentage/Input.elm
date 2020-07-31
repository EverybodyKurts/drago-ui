module Percentage.Input exposing (PercentageInput, html, pristine, update)

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


update : String -> PercentageInput
update updatedPercentage =
    case String.toFloat updatedPercentage of
        Just pct ->
            Valid (Percentage.fromFloat pct)

        Nothing ->
            Invalid updatedPercentage


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
