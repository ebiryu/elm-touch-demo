module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Svg exposing (svg, polygon, rect, g)
import Svg.Attributes exposing (viewBox, height, fill, points, transform, width, x, y)


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Your Elm App is working!" ]
        , objects model
        ]


objects : Model -> Html Msg
objects model =
    svg [ height "400px", width "400px", viewBox "0 0 323.141 322.95" ]
        [ g []
            [ polygon [ fill "#34495E", points "161.649,152.782 231.514,82.916 91.783,82.916" ]
                []
            , polygon [ fill "#34495E", points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ]
                []
            , rect [ fill "#34495E", height "108.167", transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)", width "107.676", x "192.99", y "107.392" ]
                []
            , polygon [ fill "#34495E", points "323.298,143.724 323.298,0 179.573,0" ]
                []
            , polygon [ fill "#34495E", points "152.781,161.649 0,8.868 0,314.432" ]
                []
            , polygon [ fill "#34495E", points "255.522,246.655 323.298,314.432 323.298,178.879" ]
                []
            , polygon [ fill "#34495E", points "161.649,170.517 8.869,323.298 314.43,323.298" ]
                []
            ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
