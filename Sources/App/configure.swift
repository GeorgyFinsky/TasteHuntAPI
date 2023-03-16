import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "tasteHunt_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "tasteHunt_password",
        database: Environment.get("DATABASE_NAME") ?? "tasteHunt_database"
    ), as: .psql)
    
    
    app.migrations.add(CreateCafe())
    app.migrations.add(CreareGuest())
    app.migrations.add(CreateVisit())
    app.migrations.add(CreateDiches())
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
