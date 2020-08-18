port module Main exposing (Model, Msg(..), init, main, toJs, update, view)

import BodyComposition.Form exposing (BodyCompositionForm)
import Bootstrap exposing (col, col4, fluidContainer, row)
import Browser
import Html exposing (Html)
import Http exposing (Error(..))
import Json.Decode as Decode
import Mass.Input
import Percentage.Input



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
    , bodyCompositionForm : BodyCompositionForm Msg
    }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { counter = flags
      , serverMessage = ""
      , bodyCompositionForm =
            { massInput = Mass.Input.pristine { updateAmountMsg = UpdateMassAmount, toggleUnitMsg = ToggleMassUnit }
            , bodyFatInput = Percentage.Input.pristine { updateMsg = UpdateBfPercentage }
            }
      }
    , Cmd.none
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Set Int
    | TestServer
    | OnServerResponse (Result Http.Error String)
    | UpdateMassAmount String
    | ToggleMassUnit
    | UpdateBfPercentage String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
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
                updatedForm =
                    model.bodyCompositionForm
                        |> BodyComposition.Form.updateMassAmount updatedAmount
            in
            ( { model | bodyCompositionForm = updatedForm }, Cmd.none )

        ToggleMassUnit ->
            let
                updatedForm =
                    model.bodyCompositionForm
                        |> BodyComposition.Form.toggleMassUnit
            in
            ( { model | bodyCompositionForm = updatedForm }, Cmd.none )

        UpdateBfPercentage bfInput ->
            let
                updatedForm =
                    model.bodyCompositionForm
                        |> BodyComposition.Form.updateBodyFat bfInput
            in
            ( { model | bodyCompositionForm = updatedForm }, Cmd.none )


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



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    fluidContainer
        [ row
            [ col4
                [ BodyComposition.Form.card model.bodyCompositionForm ]
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
