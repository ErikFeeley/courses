IF NOT EXIST paket.lock (
    START /WAIT .paket/paket.exe install
)
dotnet restore src/CoursesApi
dotnet build src/CoursesApi

