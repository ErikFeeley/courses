module Page.Course exposing (Model, Msg, init, view)

import Course exposing (Course)
import Html exposing (Html, text)
import Http
import Url.Builder



-- MODEL


type Status a
    = Loading
    | Loaded a
    | Failure


type alias Model =
    { courses : Status (List Course) }


coursesApi : String
coursesApi =
    Url.Builder.crossOrigin "https:localhost:5001" [ "api", "courses" ] []


getCourses : Cmd Msg
getCourses =
    Http.send CompletedLoadCourses (Http.get coursesApi Course.coursesDecoder)


init : ( Model, Cmd Msg )
init =
    ( { courses = Loading }, getCourses )



-- VIEW


view : Model -> Html Msg
view model =
    text "hi"



-- UPDATE


type Msg
    = CompletedLoadCourses (Result Http.Error (List Course))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadCourses (Ok courses) ->
            ( { model | courses = Loaded courses }, Cmd.none )

        CompletedLoadCourses (Err error) ->
            ( { model | courses = Failure }, Cmd.none )
