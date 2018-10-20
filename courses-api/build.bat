IF NOT EXIST paket.lock (
    START /WAIT .paket/paket.exe install
)
dotnet restore src/courses_api
dotnet build src/courses_api

dotnet restore tests/courses_api.Tests
dotnet build tests/courses_api.Tests
dotnet test tests/courses_api.Tests
