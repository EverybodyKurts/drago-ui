module Bootstrap.InputGroup exposing (append, inputGroup, text)

import Html exposing (Html, div, span)
import Html.Attributes exposing (class, id)


inputGroup : List (Html msg) -> Html msg
inputGroup =
    div [ class "input-group" ]


append : List (Html msg) -> Html msg
append =
    div [ class "input-group-append" ]


text : String -> List (Html msg) -> Html msg
text htmlId =
    span [ class "input-group-text", id htmlId ]
