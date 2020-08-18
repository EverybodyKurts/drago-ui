module Mass.Input exposing (MassInput, ValidationError, amountInputHtml, html, pristine, toggleUnit, unitButton, updateAmount, updateAmountAndValidate, validate)

import Bootstrap exposing (TextInput)
import Bootstrap.Button as Button
import Bootstrap.InputGroup as InputGroup exposing (inputGroup)
import Html exposing (Html, text)
import Mass exposing (Mass)
import String


type Unit
    = Lb
    | Kg


type MassInput
    = Pristine Unit
    | Invalid { unit : Unit, amount : String }
    | Valid Mass


type ValidationError
    = MassInputIsEmpty
    | MassInputNotNumber String


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


validate : MassInput -> Result ValidationError Mass
validate massInput =
    case massInput of
        Pristine _ ->
            Err MassInputIsEmpty

        Invalid { unit, amount } ->
            if String.isEmpty amount then
                Err MassInputIsEmpty

            else
                case String.toFloat amount of
                    Just amt ->
                        Ok (toMass unit amt)

                    Nothing ->
                        Err (MassInputNotNumber amount)

        Valid mass ->
            Ok mass


updateAmount : String -> MassInput -> MassInput
updateAmount updatedAmount massInput =
    case massInput of
        Pristine unit ->
            Invalid { unit = unit, amount = updatedAmount }

        Invalid input ->
            Invalid { input | amount = updatedAmount }

        Valid mass ->
            Invalid { unit = unitFromMass mass, amount = updatedAmount }


updateAmountAndValidate : String -> MassInput -> Result ValidationError Mass
updateAmountAndValidate updatedAmount =
    updateAmount updatedAmount >> validate


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

        Invalid ({ unit } as input) ->
            Invalid { input | unit = toggle unit }

        Valid mass ->
            Valid (Mass.toggle mass)


unitButton : msg -> MassInput -> Html msg
unitButton toggleMsg massInput =
    let
        ( disabled, unitHtml ) =
            case massInput of
                Pristine unit ->
                    ( False, unitToHtml unit )

                Invalid { unit } ->
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


amountInputHtml : (String -> msg) -> MassInput -> Html msg
amountInputHtml inputMsg massInput =
    let
        val =
            case massInput of
                Pristine _ ->
                    ""

                Invalid { amount } ->
                    amount

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
        [ amountInputHtml updateAmountMsg massInput
        , InputGroup.append
            [ unitButton toggleUnitMsg massInput
            ]
        ]
