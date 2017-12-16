module Main exposing (..)

import Dict
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import MultiTouch
import SingleTouch
import Svg exposing (Svg, svg, polygon, rect, g)
import Svg.Attributes exposing (viewBox, height, fill, points, transform, width, x, y)
import Touch


---- MODEL ----


type alias Model =
    { touchedCoordinate : Touch.Coordinates
    , coordinate1 : Touch.Coordinates
    , distance : Float
    , scale : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { touchedCoordinate = { clientX = 0, clientY = 0 }
      , coordinate1 = { clientX = 0, clientY = 0 }
      , distance = 0
      , scale = 1
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | SingleStart Touch.Coordinates
    | SingleMove Touch.Coordinates
    | MultiStart Touch.Event
    | MultiMove Touch.Event


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SingleStart coordinate ->
            ( { model | touchedCoordinate = coordinate }, Cmd.none )

        SingleMove coordinate ->
            let
                oldCoordinate =
                    model.touchedCoordinate

                ( dx, dy ) =
                    ( coordinate.clientX - oldCoordinate.clientX, coordinate.clientY - oldCoordinate.clientY )

                ( newX, newY ) =
                    ( model.coordinate1.clientX + dx, model.coordinate1.clientY + dy )
            in
                ( { model | touchedCoordinate = coordinate, coordinate1 = { clientX = newX, clientY = newY } }, Cmd.none )

        MultiStart event ->
            let
                oldDistance =
                    model.distance

                eventPositions =
                    Dict.values <| Touch.touches event

                newDistance =
                    case eventPositions of
                        [ c1, c2 ] ->
                            sqrt ((c2.clientX - c1.clientX) ^ 2 + (c2.clientY - c1.clientY) ^ 2)

                        _ ->
                            oldDistance
            in
                ( { model | distance = newDistance }, Cmd.none )

        MultiMove event ->
            let
                oldDistance =
                    model.distance

                eventPositions =
                    Dict.values <| Touch.changedTouches event

                newDistance =
                    case eventPositions of
                        [ c1, c2 ] ->
                            sqrt ((c2.clientX - c1.clientX) ^ 2 + (c2.clientY - c1.clientY) ^ 2)

                        _ ->
                            oldDistance

                newScale =
                    ((oldDistance - newDistance) * 0.005)
                        |> (-) model.scale
                        |> clamp 0.1 2
            in
                ( { model | distance = newDistance, scale = newScale }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div
        [ class "full"
        , MultiTouch.onStart MultiStart
        , MultiTouch.onMove MultiMove
        ]
        [ div [ class "centerize" ]
            [ svg [ height "320px", width "320px", viewBox "0 0 323.141 322.95" ]
                [ g
                    [ transform ("translate(160, 160)scale(" ++ (toString model.scale) ++ ")translate(-160, -160)")
                    ]
                    (objects model)
                ]
            ]
        ]


objects : Model -> List (Svg Msg)
objects model =
    [ polygon [ fill "#34495E", points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ]
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
    , polygon
        [ SingleTouch.onStart SingleStart
        , SingleTouch.onMove SingleMove
        , transform ("translate(" ++ (toString model.coordinate1.clientX) ++ " " ++ (toString model.coordinate1.clientY) ++ ")")
        , fill "#60B5CC"
        , points "161.649,152.782 231.514,82.916 91.783,82.916"
        ]
        []
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
