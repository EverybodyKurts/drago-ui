module Mass.Input exposing (MassInput, ValidationError, amountInputHtml, html, pristine, toggleUnit, unitButton, updateAmount, updateAmountAndValidate, validate)

import Bootstrap exposing (TextInput)
import Bootstrap.InputGroup as InputGroup exposing (inputGroup)
import Html exposing (Html)
import Mass exposing (Mass)
import Mass.Unit exposing (Unit(..))
import String


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
    = AmountEmpty
    | AmountNotNumber String


pristine : Events msg -> MassInput msg
pristine { updateAmountMsg, toggleUnitMsg } =
    { updateAmountMsg = updateAmountMsg
    , toggleUnitMsg = toggleUnitMsg
    , state = Pristine Lb
    }


validate : MassInput msg -> Result ValidationError Mass
validate { state } =
    case state of
        Pristine _ ->
            Err AmountEmpty

        Invalid { unit, amount } ->
            if String.isEmpty amount then
                Err AmountEmpty

            else
                case String.toFloat amount of
                    Just amt ->
                        Ok <| Mass.Unit.toMass unit amt

                    Nothing ->
                        Err <| AmountNotNumber amount

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
            { massInput | state = Invalid { unit = Mass.Unit.fromMass mass, amount = updatedAmount } }


updateAmountAndValidate : String -> MassInput msg -> Result ValidationError Mass
updateAmountAndValidate updatedAmount =
    updateAmount updatedAmount >> validate


toggleUnit : MassInput msg -> MassInput msg
toggleUnit ({ state } as massInput) =
    case state of
        Pristine unit ->
            { massInput | state = Pristine <| Mass.Unit.toggle unit }

        Invalid ({ unit } as input) ->
            { massInput | state = Invalid { input | unit = Mass.Unit.toggle unit } }

        Valid mass ->
            { massInput | state = Valid <| Mass.toggle mass }


unitButton : MassInput msg -> Html msg
unitButton { toggleUnitMsg, state } =
    let
        button : Mass.Unit.Button msg
        button =
            case state of
                Pristine unit ->
                    { toggleMsg = toggleUnitMsg
                    , disabled = True
                    , unit = unit
                    }

                Invalid { unit } ->
                    { toggleMsg = toggleUnitMsg
                    , disabled = True
                    , unit = unit
                    }

                Valid mass ->
                    { toggleMsg = toggleUnitMsg
                    , disabled = False
                    , unit = mass |> Mass.Unit.fromMass
                    }
    in
    Mass.Unit.button button


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
