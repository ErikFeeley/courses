namespace CoursesApi

module Course =

  open Microsoft.AspNetCore.Http
  open FSharp.Control.Tasks.V2.ContextInsensitive
  open Giraffe
  open CoursesApi.Models

  [<CLIMutable>]
  type Course = 
    {
      CourseId : int
      Name : string
    }

  let courses = [
    {
      CourseId = 1 
      Name = "Computer Psychology"
    }
    {
      CourseId = 2
      Name = "Philosophical Sammich Making"
    }
    {
      CourseId = 3
      Name = "Blow Off"
    }
  ]

  let handleGetCourses =
    fun (next : HttpFunc) (ctx : HttpContext) ->
         task {
             return! json courses next ctx
         }

  let handleGetCourse (courseId : int) =
    fun (next : HttpFunc) (ctx : HttpContext) ->
      task {
        let maybeCourse = List.tryFind (fun course -> course.CourseId = courseId) courses

        match maybeCourse with
        | Some course ->
          return! json course next ctx
        | None ->
          return! RequestErrors.notFound (json { Text = "Not Found" }) next ctx
      }