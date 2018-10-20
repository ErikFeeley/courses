if [ ! -e "paket.lock" ]
then
    exec mono .paket/paket.exe install
fi
dotnet restore src/courses-api
dotnet build src/courses-api

dotnet restore tests/courses-api.Tests
dotnet build tests/courses-api.Tests
dotnet test tests/courses-api.Tests
