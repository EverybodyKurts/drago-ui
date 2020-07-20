module Bootstrap exposing (col, col4, fluidContainer, inputGroup, inputGroupAppend, row)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


fluidContainer : List (Html msg) -> Html msg
fluidContainer =
    div [ class "container-fluid" ]


row : List (Html msg) -> Html msg
row =
    div [ class "row" ]


col : List (Html msg) -> Html msg
col =
    div [ class "col" ]


col4 : List (Html msg) -> Html msg
col4 =
    div [ class "col-4" ]


inputGroup : List (Html msg) -> Html msg
inputGroup =
    div [ class "input-group" ]


inputGroupAppend : List (Html msg) -> Html msg
inputGroupAppend =
    div [ class "input-group-append" ]
