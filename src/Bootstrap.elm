module Bootstrap exposing (TextInput, col, col4, fluidContainer, row, textInput)

import Html exposing (Html, div, input)
import Html.Attributes exposing (attribute, class, type_)
import Html.Events exposing (onInput)


type alias TextInput msg =
    { placeholder : String
    , inputMsg : String -> msg
    , for : String
    , value : String
    }


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


textInput : TextInput msg -> Html msg
textInput { inputMsg, placeholder, for, value } =
    input
        [ type_ "text"
        , class "form-control"
        , Html.Attributes.placeholder placeholder
        , attribute "aria-label" placeholder
        , attribute "aria-describedby" for
        , onInput inputMsg
        , Html.Attributes.value value
        ]
        []
