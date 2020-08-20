module Mass.Unit exposing (Button, Unit(..), button, fromMass, fromMassToHtml, toHtml, toMass, toString, toggle)

import Bootstrap.Button as Button
import Html exposing (Html, text)
import Mass exposing (Mass)


type Unit
    = Lb
    | Kg


type alias Button msg =
    { toggleMsg : msg
    , disabled : Bool
    , unit : Unit
    }


button : Button msg -> Html msg
button { toggleMsg, disabled, unit } =
    Button.outlineSecondary
        { id = "mass"
        , onClickMsg = toggleMsg
        , value = unit |> toHtml
        , disabled = disabled
        }


fromMass : Mass -> Unit
fromMass mass =
    if Mass.isKg mass then
        Kg

    else
        Lb


toggle : Unit -> Unit
toggle unit =
    case unit of
        Lb ->
            Kg

        Kg ->
            Lb


toString : Unit -> String
toString unit =
    case unit of
        Lb ->
            "lb"

        Kg ->
            "kg"


toHtml : Unit -> Html msg
toHtml =
    toString >> text


fromMassToHtml : Mass -> Html msg
fromMassToHtml =
    fromMass >> toHtml


toMass : Unit -> Float -> Mass
toMass unit =
    case unit of
        Lb ->
            Mass.lb

        Kg ->
            Mass.kg
