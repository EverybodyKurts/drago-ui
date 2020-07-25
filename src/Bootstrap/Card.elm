module Bootstrap.Card exposing (body, card, header, primaryHeader)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


card : List (Html msg) -> Html msg
card =
    div [ class "card" ]


header : List (Html msg) -> Html msg
header =
    div [ class "card-header" ]


primaryHeader : List (Html msg) -> Html msg
primaryHeader =
    div [ class "card-header text-white bg-primary" ]


body : List (Html msg) -> Html msg
body =
    div [ class "card-body" ]
