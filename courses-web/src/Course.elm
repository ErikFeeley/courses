module Course exposing (Course, coursesDecoder)

import Json.Decode as Decode exposing (Decoder, field, list)
import Json.Encode as Encode exposing (Value)


type alias Course =
    { courseId : Int, name : String }


coursesDecoder : Decoder (List Course)
coursesDecoder =
    list courseDecoder


courseDecoder : Decoder Course
courseDecoder =
    Decode.map2 Course
        (field "courseId" Decode.int)
        (field "name" Decode.string)


courseEncoder : Course -> Value
courseEncoder course =
    Encode.object
        [ ( "courseId", Encode.int course.courseId )
        , ( "name", Encode.string course.name )
        ]
