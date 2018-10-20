namespace CoursesApi

module Course =
    open Microsoft.AspNetCore.Http
    open FSharp.Control.Tasks.V2.ContextInsensitive
    open Giraffe
    open CoursesApi.Models
    
    [<CLIMutable>]
    type Course =
        { CourseId : int
          Name : string }
    
    [<CLIMutable>]
    type NewCourse =
        { Name : string }
        member this.HasErrors() =
            if this.Name = null || this.Name = "" then Some "Name is a required field"
            else None
    
    let courses =
        [ { CourseId = 1
            Name = "Computer Psychology" }
          { CourseId = 2
            Name = "Philosophical Sammich Making" }
          { CourseId = 3
            Name = "Blow Off" } ]
    
    let handleGetCourses = fun (next : HttpFunc) (ctx : HttpContext) -> task { return! json courses next ctx }
    
    let handleGetCourse (courseId : int) =
        fun (next : HttpFunc) (ctx : HttpContext) -> 
            task { 
                let maybeCourse = List.tryFind (fun course -> course.CourseId = courseId) courses
                match maybeCourse with
                | Some course -> return! json course next ctx
                | None -> return! RequestErrors.notFound (json { Text = "Not Found" }) next ctx
            }
    
    let handlePostCourse =
        fun (next : HttpFunc) (ctx : HttpContext) -> 
            task { 
                let! newCourse = ctx.BindJsonAsync<NewCourse>()
                match newCourse.HasErrors() with
                | Some err -> return! RequestErrors.badRequest (json { Text = err }) next ctx
                | None -> 
                    return! Successful.created (json { CourseId = 4
                                                       Name = newCourse.Name }) next ctx
            }
