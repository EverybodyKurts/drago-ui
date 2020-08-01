port module Main exposing (Model, Msg(..), add1, init, main, toJs, update, view)

import Bootstrap exposing (col, col4, fluidContainer, row)
import Bootstrap.Card as Card exposing (card)
import Bootstrap.Form as Form
import Browser
import Html exposing (Html, text)
import Http exposing (Error(..))
import Json.Decode as Decode
import Mass.Input exposing (MassInput)
import Percentage.Input exposing (PercentageInput)



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { counter : Int
    , serverMessage : String
    , massInput : MassInput
    , bfInput : PercentageInput
    }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { counter = flags
      , serverMessage = ""
      , massInput = Mass.Input.pristine
      , bfInput = Percentage.Input.pristine
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
    | UpdateMassAmount String
    | ToggleMassUnit
    | UpdateBfPercentage String


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

        UpdateMassAmount updatedAmount ->
            let
                updatedMassInput =
                    model.massInput
                        |> Mass.Input.updateAmount updatedAmount
            in
            ( { model | massInput = updatedMassInput }, Cmd.none )

        ToggleMassUnit ->
            let
                updatedMassInput =
                    model.massInput
                        |> Mass.Input.toggleUnit
            in
            ( { model | massInput = updatedMassInput }, Cmd.none )

        UpdateBfPercentage bfInput ->
            let
                updatedBfInput =
                    bfInput
                        |> Percentage.Input.update
            in
            ( { model | bfInput = updatedBfInput }, Cmd.none )


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


view : Model -> Html Msg
view model =
    fluidContainer
        [ row
            [ col4
                [ card
                    [ Card.primaryHeader [ text "Body Composition" ]
                    , Card.body
                        [ Form.row
                            [ Bootstrap.col
                                [ Mass.Input.html
                                    ToggleMassUnit
                                    UpdateMassAmount
                                    model.massInput
                                ]
                            ]
                        , Form.row
                            [ Bootstrap.col
                                [ Percentage.Input.html
                                    UpdateBfPercentage
                                    model.bfInput
                                ]
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
