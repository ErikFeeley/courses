module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Courses as Courses
import Page.NotFound as NotFound
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


type Page
    = NotFound
    | Courses Courses.Model


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    case Parser.parse (routeParser model) url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser


stepCourses : Model -> ( Courses.Model, Cmd Courses.Msg ) -> ( Model, Cmd Msg )
stepCourses model ( courseModel, cmds ) =
    ( { model | page = Courses courseModel }
    , Cmd.map CoursesMsg cmds
    )


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ route Parser.top (stepCourses model Courses.init)
        ]


type alias Model =
    { key : Nav.Key
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    stepUrl url
        { key = key
        , page = NotFound
        }



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            { title = "Not found"
            , body = [ NotFound.view ]
            }

        Courses courses ->
            { title = "Courses"
            , body = [ Html.map CoursesMsg (Courses.view courses) ]
            }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CoursesMsg Courses.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( model
            , Cmd.none
            )

        CoursesMsg msg ->
            case model.page of
                Courses courses ->
                    stepCourses model (Courses.update msg courses)

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
