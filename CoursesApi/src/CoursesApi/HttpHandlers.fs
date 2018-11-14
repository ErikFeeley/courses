namespace CoursesApi

module HttpHandlers =
    open Microsoft.AspNetCore.Http
    open FSharp.Control.Tasks.V2.ContextInsensitive
    open Giraffe
    open CoursesApi.Models
    
    let handleGetHelloAlt (next: HttpFunc) (ctx: HttpContext) =
        task {
            let response = {Text = "Hello world"}
            return! json response next ctx
        }
