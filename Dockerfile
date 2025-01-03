# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy everything and restore dependencies
COPY . ./
RUN dotnet restore

# Publish the application
RUN dotnet publish -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Install any required runtime dependencies (optional)
RUN apt-get update && apt-get install -y libicu libssl-dev

# Copy the published application from the build stage
COPY --from=build /app/out .

# Expose the application port (if applicable)
EXPOSE 5000

# Set the entry point to the app
ENTRYPOINT ["dotnet", "Calendar.dll"]
