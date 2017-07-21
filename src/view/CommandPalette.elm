module CommandPalette exposing (view)

import Html exposing (..)
import Html.Attributes exposing (style)

import Model exposing (CommandPalette)
import Types exposing (..)

view : CommandPalette -> Html Msg
view {dimensions, isActive, activeCommand, candidateCommand, activationTimeInMillis} =
  let
    x = dimensions.x
    y = dimensions.y
    sideLength = dimensions.sideLength
    left = toPixels (x - sideLength)
    top = toPixels (y - sideLength)
    len = toPixels (sideLength * 2)
    color = case isActive of
      True ->
        "rgba(25,25,75,0.5)"
      False ->
        "rgba(25,25,75,0.2)"
    progressDot =
      case activeCommand of
        Nothing -> div [] []
        Just command -> commandProgressDot command x y sideLength
    progressBar =
      case activeCommand of
        Nothing -> div [] []
        Just command -> commandProgressBar command
    candidateBar =
      case candidateCommand of
        Nothing -> div [] []
        Just command -> commandProgressBar command
    fullscreenStyle =
      style
        [ ("position", "absolute")
        , ("width", "100%")
        , ("height", "100%")
        , ("left", "0")
        , ("top", "0")
        ]
    myStyle =
      style
        [ ("position", "fixed")
        , ("left", left)
        , ("top", top)
        , ("width", len)
        , ("height", len)
        , ("background-color", color)
        ]
    westStyle =
      style
        [ ("position", "fixed")
        , ("left", toPixels (x - sideLength - 170))
        , ("top", toPixels (y - 12))
        , ("font-size", toPixels 48 )
        ]
    northStyle =
      style
        [ ("position", "fixed")
        , ("left", toPixels (x - 24))
        , ("top", toPixels (y - sideLength - 70))
        , ("font-size", toPixels 48 )
        ]
    eastStyle =
      style
        [ ("position", "fixed")
        , ("left", toPixels (x + sideLength))
        , ("top", toPixels (y - 12))
        , ("font-size", toPixels 48 )
        ]
    southStyle =
      style
        [ ("position", "fixed")
        , ("left", toPixels (x - 24))
        , ("top", toPixels (y + sideLength))
        , ("font-size", toPixels 48 )
        ]
  in
  div []
    [ div [myStyle] []
    -- , progressDot
    , progressBar
    , candidateBar
    , div [westStyle] [text "Previous"]
    , div [northStyle] [text "Up"]
    , div [eastStyle] [text "Next"]
    , div [southStyle] [text "Select"]
    ]

commandProgressDot : DwellCommand -> Int -> Int -> Int -> Html Msg
commandProgressDot command x y halfSideLength =
  let
    dotRadius = 20
    distanceToEdge = halfSideLength - dotRadius
    left = progressDotLeft command x dotRadius distanceToEdge
    top = progressDotTop command y dotRadius distanceToEdge
    progressDotStyle =
      style
        [ ("position", "fixed")
        , ("left", toPixels left)
        , ("top", toPixels top)
        , ("width", toPixels <| dotRadius * 2)
        , ("height", toPixels <| dotRadius * 2)
        , ("background-color", "rgba(224, 255, 255, 0.8)")
        , ("border-radius", toPixels dotRadius)
        ]
  in
  div [progressDotStyle] []

progressDotLeft : DwellCommand -> Int -> Int -> Int -> Int
progressDotLeft {direction, progress} x dotRadius distanceToEdge =
  case direction of
    North -> x - dotRadius
    South -> x - dotRadius
    East  -> x - dotRadius + ((distanceToEdge // 10 ) * progress)
    Northeast  -> x - dotRadius + ((distanceToEdge // 10 ) * progress)
    Southeast  -> x - dotRadius + ((distanceToEdge // 10 ) * progress)
    West  -> x - dotRadius - ((distanceToEdge // 10 ) * progress)
    Northwest  -> x - dotRadius - ((distanceToEdge // 10 ) * progress)
    Southwest  -> x - dotRadius - ((distanceToEdge // 10 ) * progress)

progressDotTop : DwellCommand -> Int -> Int -> Int -> Int
progressDotTop {direction, progress} y dotRadius distanceToEdge =
  case direction of
    North -> y - dotRadius - ((distanceToEdge // 10 ) * progress)
    Northwest  -> y - dotRadius - ((distanceToEdge // 10 ) * progress)
    Northeast  -> y - dotRadius - ((distanceToEdge // 10 ) * progress)
    South -> y - dotRadius + ((distanceToEdge // 10 ) * progress)
    Southeast  -> y - dotRadius + ((distanceToEdge // 10 ) * progress)
    Southwest  -> y - dotRadius + ((distanceToEdge // 10 ) * progress)
    East  -> y - dotRadius
    West  -> y - dotRadius

commandProgressBar : DwellCommand -> Html Msg
commandProgressBar {direction, progress} =
  let
    anchor = progressBarAnchor direction
    width = progressBarWidth direction progress
    height = progressBarHeight direction progress
    progressBarStyle =
      style
        [ ("background-color", "rgba(25,25,25, 0.2)")
        , ("position", "fixed")
        , anchor
        , width
        , height
        ]
  in
  div [progressBarStyle] []

progressBarAnchor : Direction -> (String, String)
progressBarAnchor direction =
  case direction of
    Northwest -> ("bottom", "0")
    North -> ("bottom", "0")
    Northeast -> ("bottom", "0")
    Southeast -> ("top", "0")
    South -> ("top", "0")
    Southwest -> ("top", "0")
    East -> ("left", "0")
    West -> ("right", "0")

progressBarWidth : Direction -> Int -> (String, String)
progressBarWidth direction progress =
  let progressPercent = toString ((progress+1) * 10)  ++ "%"
  in
  case direction of
    Northwest -> ("width", "100%")
    North -> ("width", "100%")
    Northeast -> ("width", "100%")
    Southeast -> ("width", "100%")
    South -> ("width", "100%")
    Southwest -> ("width", "100%")
    East -> ("width", progressPercent)
    West -> ("width", progressPercent)

progressBarHeight : Direction -> Int -> (String, String)
progressBarHeight direction progress =
  let progressPercent = toString ((progress+1) * 10)  ++ "%"
  in
  case direction of
    Northwest -> ("height", progressPercent)
    North -> ("height", progressPercent)
    Northeast -> ("height", progressPercent)
    Southeast -> ("height", progressPercent)
    South -> ("height", progressPercent)
    Southwest -> ("height", progressPercent)
    East -> ("height", "100%")
    West -> ("height", "100%")

toPixels : Int -> String
toPixels int =
  (toString int) ++ "px"
