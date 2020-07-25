module Bootstrap.Form exposing (row)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


row : List (Html msg) -> Html msg
row =
    div [ class "form-row" ]
