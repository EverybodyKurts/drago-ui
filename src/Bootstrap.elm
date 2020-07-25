module Bootstrap exposing (col, col4, fluidContainer, row, textInput)

import Html exposing (Html, div, input)
import Html.Attributes exposing (attribute, class, placeholder, type_)
import Html.Events exposing (onInput)


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


textInput : (String -> msg) -> String -> String -> Html msg
textInput inputMsg placeholderText for =
    input
        [ type_ "text"
        , class "form-control"
        , placeholder placeholderText
        , attribute "aria-label" placeholderText
        , attribute "aria-describedby" for
        , onInput inputMsg
        ]
        []
