IF NOT EXIST paket.lock (
    START /WAIT .paket/paket.exe install
)
dotnet restore src/CoursesApi
dotnet build src/CoursesApi

dotnet restore tests/CoursesApi.Tests
dotnet build tests/CoursesApi.Tests
dotnet test tests/CoursesApi.Tests
