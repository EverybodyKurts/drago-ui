module Bootstrap.Button exposing (outlineSecondary)

import Html exposing (Html, button)
import Html.Attributes exposing (class, id, type_, value)
import Html.Events exposing (onClick)


outlineSecondary : msg -> String -> Html msg -> Html msg
outlineSecondary clickMsg htmlId buttonValue =
    button
        [ class "btn btn-outline-secondary"
        , type_ "button"
        , id htmlId
        , onClick clickMsg
        ]
        [ buttonValue ]
