module Mass.Input exposing (MassInput, amountInput, html, pristine, toggleUnit, unitButton, updateAmount)

import Bootstrap exposing (TextInput)
import Bootstrap.Button as Button
import Bootstrap.InputGroup as InputGroup exposing (inputGroup)
import Html exposing (Html, text)
import Mass exposing (Mass)


type Unit
    = Lb
    | Kg


type MassInput
    = Pristine Unit
    | Invalid Unit String
    | Valid Mass


pristine : MassInput
pristine =
    Pristine Lb


unitFromMass : Mass -> Unit
unitFromMass mass =
    if Mass.isKg mass then
        Kg

    else
        Lb


unitToString : Unit -> String
unitToString unit =
    case unit of
        Lb ->
            "lb"

        Kg ->
            "kg"


unitToHtml : Unit -> Html msg
unitToHtml =
    unitToString >> text


toMass : Unit -> Float -> Mass
toMass unit =
    case unit of
        Lb ->
            Mass.lb

        Kg ->
            Mass.kg


updateAmount : String -> MassInput -> MassInput
updateAmount updatedAmount massInput =
    case ( String.isEmpty updatedAmount, massInput ) of
        ( True, Pristine unit ) ->
            Pristine unit

        ( True, Invalid unit _ ) ->
            Pristine unit

        ( True, Valid mass ) ->
            Pristine (mass |> unitFromMass)

        ( False, Pristine unit ) ->
            case String.toFloat updatedAmount of
                Just amt ->
                    Valid (toMass unit amt)

                Nothing ->
                    Invalid unit updatedAmount

        ( False, Invalid unit _ ) ->
            case String.toFloat updatedAmount of
                Just amt ->
                    Valid (toMass unit amt)

                Nothing ->
                    Invalid unit updatedAmount

        ( False, Valid mass ) ->
            case String.toFloat updatedAmount of
                Just amt ->
                    Valid (Mass.update amt mass)

                Nothing ->
                    Invalid (unitFromMass mass) updatedAmount


toggleUnit : MassInput -> MassInput
toggleUnit massInput =
    let
        toggle unit =
            case unit of
                Lb ->
                    Kg

                Kg ->
                    Lb
    in
    case massInput of
        Pristine unit ->
            Pristine (toggle unit)

        Invalid unit amt ->
            Invalid (toggle unit) amt

        Valid mass ->
            Valid (Mass.toggle mass)


unitButton : msg -> MassInput -> Html msg
unitButton toggleMsg massInput =
    let
        ( disabled, unitHtml ) =
            case massInput of
                Pristine unit ->
                    ( False, unitToHtml unit )

                Invalid unit _ ->
                    ( True, unitToHtml unit )

                Valid mass ->
                    ( False, mass |> unitFromMass |> unitToHtml )
    in
    Button.outlineSecondary
        { id = "mass"
        , onClickMsg = toggleMsg
        , value = unitHtml
        , disabled = disabled
        }


amountInput : (String -> msg) -> MassInput -> Html msg
amountInput inputMsg massInput =
    let
        val =
            case massInput of
                Pristine _ ->
                    ""

                Invalid _ invalidValue ->
                    invalidValue

                Valid mass ->
                    mass |> Mass.toFloat |> String.fromFloat

        textInput : TextInput msg
        textInput =
            { inputMsg = inputMsg
            , placeholder = "Weight"
            , for = "mass"
            , value = val
            }
    in
    Bootstrap.textInput textInput


html : msg -> (String -> msg) -> MassInput -> Html msg
html toggleUnitMsg updateAmountMsg massInput =
    inputGroup
        [ amountInput updateAmountMsg massInput
        , InputGroup.append
            [ unitButton toggleUnitMsg massInput
            ]
        ]
