module Bootstrap.Button exposing (Button, outlineSecondary)

import Html exposing (Html, button)
import Html.Attributes exposing (class, id, type_)
import Html.Events exposing (onClick)


type alias Button msg =
    { id : String
    , value : Html msg
    , disabled : Bool
    , onClickMsg : msg
    }


outlineSecondary : Button msg -> Html msg
outlineSecondary { id, value, onClickMsg, disabled } =
    button
        [ class "btn btn-outline-secondary"
        , type_ "button"
        , Html.Attributes.id id
        , onClick onClickMsg
        , Html.Attributes.disabled disabled
        ]
        [ value ]
