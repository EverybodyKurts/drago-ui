port module Main exposing (Model, Msg(..), add1, init, main, toJs, update, view)

import Bootstrap exposing (col, col4, fluidContainer, row)
import Bootstrap.Button as Button
import Bootstrap.Card as Card exposing (card)
import Bootstrap.Form as Form
import Bootstrap.InputGroup as InputGroup exposing (inputGroup)
import Browser
import Html exposing (Html, text)
import Http exposing (Error(..))
import Json.Decode as Decode



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


type MassUnit
    = Lb
    | Kg


type alias Model =
    { counter : Int
    , serverMessage : String
    , massInput : Maybe String
    , massUnit : MassUnit
    , bfInput : Maybe String
    }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { counter = flags
      , serverMessage = ""
      , massInput = Nothing
      , massUnit = Lb
      , bfInput = Nothing
      }
    , Cmd.none
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Inc
    | Set Int
    | TestServer
    | OnServerResponse (Result Http.Error String)
    | InputMass String
    | ToggleMassUnit
    | InputBodyFatPercentage String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Inc ->
            ( add1 model, toJs "Hello Js" )

        Set m ->
            ( { model | counter = m }, toJs "Hello Js" )

        TestServer ->
            let
                expect =
                    Http.expectJson OnServerResponse (Decode.field "result" Decode.string)
            in
            ( model
            , Http.get { url = "/test", expect = expect }
            )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )

        InputMass massInput ->
            ( model, Cmd.none )

        ToggleMassUnit ->
            ( model, Cmd.none )

        InputBodyFatPercentage percentageInput ->
            ( model, Cmd.none )


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        BadUrl url ->
            "BadUrl: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus _ ->
            "BadStatus"

        BadBody s ->
            "BadBody: " ++ s


{-| increments the counter

    add1 5 --> 6

-}
add1 : Model -> Model
add1 model =
    { model | counter = model.counter + 1 }



-- ---------------------------
-- VIEW
-- ---------------------------


massUnitToString : MassUnit -> String
massUnitToString massUnit =
    case massUnit of
        Lb ->
            "lb"

        Kg ->
            "kg"


massUnitToText : MassUnit -> Html msg
massUnitToText =
    massUnitToString >> text


massInputs : Model -> Html Msg
massInputs model =
    inputGroup
        [ Bootstrap.textInput InputMass "Weight" "mass"
        , InputGroup.append
            [ Button.outlineSecondary ToggleMassUnit "mass" (massUnitToText model.massUnit)
            ]
        ]


bfPercentageInput : Model -> Html Msg
bfPercentageInput model =
    inputGroup
        [ Bootstrap.textInput InputMass "Body Fat %" "bodyfat-percentage"
        , InputGroup.append
            [ InputGroup.text "bodyfat-percentage" [ text "%" ]
            ]
        ]


view : Model -> Html Msg
view model =
    fluidContainer
        [ row
            [ col4
                [ card
                    [ Card.primaryHeader [ text "Body Composition" ]
                    , Card.body
                        [ Form.row
                            [ Bootstrap.col [ massInputs model ]
                            ]
                        , Form.row
                            [ Bootstrap.col [ bfPercentageInput model ]
                            ]
                        ]
                    ]
                ]
            , Bootstrap.col []
            ]
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Body Metrics"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
