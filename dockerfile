FROM microsoft/aspnetcore-build:2 as build-env
WORKDIR /docker
COPY /api/api.csproj ./api/
run dotnet restore api/api.csproj
COPY /tests/tests.csproj ./tests/
run dotnet restore tests/tests.csproj
copy . .
run dotnet test tests/tests.csproj

RUN dotnet publish -o /publish

# Runtime Image Stage
FROM microsoft/aspnetcore:2
WORKDIR /publish
COPY --from=build-env /publish .
ENTRYPOINT ["dotnet", "api.dll"]