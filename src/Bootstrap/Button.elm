module Bootstrap.Button exposing (outlineSecondary)

import Html exposing (Html, button)
import Html.Attributes exposing (class, id, type_)
import Html.Events exposing (onClick)


outlineSecondary : msg -> String -> List (Html msg) -> Html msg
outlineSecondary clickMsg htmlId =
    button
        [ class "btn btn-outline-secondary"
        , type_ "button"
        , id htmlId
        , onClick clickMsg
        ]
