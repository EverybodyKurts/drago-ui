module Main exposing (Model, Msg(..), init, main, update, view)

import BodyComposition.Form exposing (BodyCompositionForm)
import Bootstrap exposing (col, col4, fluidContainer, row)
import Browser
import Html exposing (Html)



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
            BodyComposition.Form.pristine
                { updateMassAmountMsg = UpdateMassAmount
                , toggleMassUnitMsg = ToggleMassUnit
                , updateBodyFatMsg = UpdateBfPercentage
                }
      }
    , Cmd.none
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = UpdateMassAmount String
    | ToggleMassUnit
    | UpdateBfPercentage String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
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
