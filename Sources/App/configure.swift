import Fluent
import FluentSQLiteDriver
import Vapor

var workingDirectory = URL(string: "")

extension Environment {
    static let pgUrl = URL(string: Self.get("DB_URL")!)!
    
}

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
    
    try app.databases.use(.postgres(url: Environment.pgUrl), as: .psql)
        
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.routes.defaultMaxBodySize = "10mb"
    app.fileStorages.use(.local(publicUrl: "http://localhost:8080",
                                publicPath: app.directory.publicDirectory,
                                workDirectory: "assets"), as: .local)
     
    
    app.views.use(.leaf)
    if !app.environment.isRelease {
        app.leaf.cache.isEnabled = false
        app.leaf.useViperViews()
    }


//    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    

    app.sessions.use(.fluent)
    app.migrations.add(SessionRecord.migration)
    app.middleware.use(app.sessions.middleware)

    let modules: [ViperModule] = [
        UserModule(),
        FrontendModule(),
        AdminModule(),
        BlogModule(),
        UtilityModule()
    ]

    try app.viper.use(modules)
}

protocol ViperAdminViewController: AdminViewController where Model: ViperModel  {
    associatedtype Module: ViperModule
}

extension ViperAdminViewController {

    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }
    var editView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }
}

extension Fluent.Model where IDValue == UUID {
    var viewIdentifier: String { self.id!.uuidString }
}
