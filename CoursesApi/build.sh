if [ ! -e "paket.lock" ]
then
    exec mono .paket/paket.exe install
fi
dotnet restore src/CoursesApi
dotnet build src/CoursesApi

dotnet restore tests/CoursesApi.Tests
dotnet build tests/CoursesApi.Tests
dotnet test tests/CoursesApi.Tests
