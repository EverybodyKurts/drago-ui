module Bootstrap.InputGroup exposing (append)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


append : List (Html msg) -> Html msg
append =
    div [ class "input-group-append" ]
