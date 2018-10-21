module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Course as Course
import Url
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Route
    = Courses ( Course.Model, Cmd Course.Msg )
    | Tutorial


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Parser.map Tutorial Parser.top
        , Parser.map (Courses Course.init) (s "courses")
        ]


type alias Model =
    { key : Nav.Key
    , route : Maybe Route
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key (Parser.parse routeParser url) url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ viewBody model
        ]
    }


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        Just route ->
            case route of
                Tutorial ->
                    div []
                        [ text "The current URL is: "
                        , b [] [ text (Url.toString model.url) ]
                        , ul []
                            [ viewLink "/home"
                            , viewLink "/profile"
                            , viewLink "/reviews/the-century-of-the-self"
                            , viewLink "/reviews/public-opinion"
                            , viewLink "/reviews/shah-of-shahs"
                            ]
                        ]

                Courses courseModel ->
                    div [] [ text "hmmm" ]

        Nothing ->
            div [] [ text "Not FOund" ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
