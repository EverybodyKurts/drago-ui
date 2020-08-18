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


type State
    = Pristine Unit
    | Invalid { unit : Unit, amount : String }
    | Valid Mass


type alias Events msg =
    { updateAmountMsg : String -> msg
    , toggleUnitMsg : msg
    }


type alias MassInput msg =
    { updateAmountMsg : String -> msg
    , toggleUnitMsg : msg
    , state : State
    }


type ValidationError
    = MassInputIsEmpty
    | MassInputNotNumber String


pristine : Events msg -> MassInput msg
pristine { updateAmountMsg, toggleUnitMsg } =
    { updateAmountMsg = updateAmountMsg
    , toggleUnitMsg = toggleUnitMsg
    , state = Pristine Lb
    }


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


validate : MassInput msg -> Result ValidationError Mass
validate { state } =
    case state of
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


updateAmount : String -> MassInput msg -> MassInput msg
updateAmount updatedAmount ({ state } as massInput) =
    case state of
        Pristine unit ->
            { massInput | state = Invalid { unit = unit, amount = updatedAmount } }

        Invalid input ->
            { massInput | state = Invalid { input | amount = updatedAmount } }

        Valid mass ->
            { massInput | state = Invalid { unit = unitFromMass mass, amount = updatedAmount } }


updateAmountAndValidate : String -> MassInput msg -> Result ValidationError Mass
updateAmountAndValidate updatedAmount =
    updateAmount updatedAmount >> validate


toggleUnit : MassInput msg -> MassInput msg
toggleUnit ({ state } as massInput) =
    let
        toggle unit =
            case unit of
                Lb ->
                    Kg

                Kg ->
                    Lb
    in
    case state of
        Pristine unit ->
            { massInput | state = Pristine (toggle unit) }

        Invalid ({ unit } as input) ->
            { massInput | state = Invalid { input | unit = toggle unit } }

        Valid mass ->
            { massInput | state = Valid (Mass.toggle mass) }


unitButton : MassInput msg -> Html msg
unitButton { toggleUnitMsg, state } =
    let
        ( disabled, unitHtml ) =
            case state of
                Pristine unit ->
                    ( False, unitToHtml unit )

                Invalid { unit } ->
                    ( True, unitToHtml unit )

                Valid mass ->
                    ( False, mass |> unitFromMass |> unitToHtml )
    in
    Button.outlineSecondary
        { id = "mass"
        , onClickMsg = toggleUnitMsg
        , value = unitHtml
        , disabled = disabled
        }


amountInputHtml : MassInput msg -> Html msg
amountInputHtml { updateAmountMsg, state } =
    let
        val =
            case state of
                Pristine _ ->
                    ""

                Invalid { amount } ->
                    amount

                Valid mass ->
                    mass |> Mass.toFloat |> String.fromFloat

        textInput : TextInput msg
        textInput =
            { inputMsg = updateAmountMsg
            , placeholder = "Weight"
            , for = "mass"
            , value = val
            }
    in
    Bootstrap.textInput textInput


html : MassInput msg -> Html msg
html massInput =
    inputGroup
        [ amountInputHtml massInput
        , InputGroup.append
            [ unitButton massInput
            ]
        ]
