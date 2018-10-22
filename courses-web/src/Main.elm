module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html
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


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ Parser.map (stepCourses model Courses.init) Parser.top
        ]


type alias Model =
    { key : Nav.Key
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    stepUrl url { key = key, page = NotFound }



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            { title = "Not found"
            , body = [ NotFound.view ]
            }

        Courses coursesModel ->
            { title = "Courses"
            , body = [ Html.map CoursesMsg (Courses.view coursesModel) ]
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
            stepUrl url model

        CoursesMsg msg ->
            case model.page of
                Courses courses ->
                    stepCourses model (Courses.update msg courses)

                _ ->
                    ( model, Cmd.none )


stepCourses : Model -> ( Courses.Model, Cmd Courses.Msg ) -> ( Model, Cmd Msg )
stepCourses model ( courseModel, courseCmds ) =
    ( { model | page = Courses courseModel }
    , Cmd.map CoursesMsg courseCmds
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
