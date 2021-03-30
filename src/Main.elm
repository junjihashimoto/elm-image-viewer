
module Main exposing (..)
import Array as A
import ImageSets exposing (..)
import Browser
import Html exposing (Html, button, div, text, img, input, Attribute)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Json
import Debug
 

main =
    Browser.sandbox { init = init, update = update, view = view }

        
type alias Model = Int

type Msg
    = Increment Int
    | Decrement Int
    | Update String
    | KeyDown Int
    | Zero

    
init : Model
init = 0
      
update : Msg -> Model -> Model
update msg model =
  case msg of
      Increment v ->
          model + v
      Decrement v ->
          model - v
      Zero ->
          0
      Update v ->
          case String.toInt v of
              Nothing -> model
              Just v2 -> v2
      KeyDown v ->
          case v of
              106 -> model + 1
              107 -> model - 1
              74 -> model + 10
              75 -> model - 10
              _ -> Debug.log (String.fromInt v) model
              

view : Model -> Html Msg
view model =
  case A.get model imagePaths of
      Just imgId -> 
          div [ onKeyPress KeyDown ]
              [ div [] [ text imgId ] 
              , button [ onClick (Decrement 1) ] [ text "-" ]
              , button [ onClick (Decrement 10) ] [ text "-10" ]
              , button [ onClick (Decrement 100) ] [ text "-100" ]
              , button [ onClick (Decrement 1000) ] [ text "-1000" ]
              , button [ onClick (Increment 1000) ] [ text "+1000" ]
              , button [ onClick (Increment 100) ] [ text "+100" ]
              , button [ onClick (Increment 10) ] [ text "+10" ]
              , button [ onClick (Increment 1) ] [ text "+" ]
              , text ( "("  )
              , input [ onInput Update, value ((String.fromInt model)) ] []
              , text ("/" ++ (String.fromInt (A.length imagePaths)) ++ ")")
              , div [] [ img [ src imgId ] [] ]
              ]
      Nothing -> 
          div []
              [ button [ onClick Zero ] [ text "0" ]
              , text (String.fromInt model)
              ]

onKeyPress : (Int -> Msg) -> Attribute Msg
onKeyPress tagger =
    Html.Events.on "keypress" (Json.map tagger Html.Events.keyCode)

