module Bootstrap.InputGroup exposing (append, inputGroup)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


inputGroup : List (Html msg) -> Html msg
inputGroup =
    div [ class "input-group" ]


append : List (Html msg) -> Html msg
append =
    div [ class "input-group-append" ]
