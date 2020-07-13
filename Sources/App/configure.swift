import Fluent
import FluentSQLiteDriver
import Vapor

var workingDirectory = URL(string: "")

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let directory = app.directory.workingDirectory
    let configDir = "Sources/App/Data"
    let fileUrl = URL(fileURLWithPath: directory)
    .appendingPathComponent(configDir, isDirectory: true)
    .appendingPathComponent("data.json", isDirectory: false)
    workingDirectory = fileUrl
    print("Directory: \(fileUrl)")
    
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    
    
    let modules: [Module] = [

        VideoModule(),
        SubtopicModule(),
        TopicModule(),
    ]
    
    for module in modules {
        try module.configure(app)
    }
}
