import Fluent
import Vapor
import Liquid
import LiquidLocalDriver
import FluentPostgresDriver
import ViperKit
import ViewKit

var workingDirectory = URL(string: "")

extension Environment {
    static let dbHost = Self.get("DB_HOST") ?? ""
    static let dbUser = Self.get("DB_USER") ?? ""
    static let dbPass = Self.get("DB_PASS") ?? ""
    static let dbName = Self.get("DB_NAME") ?? ""
//
//    static let fsName = Self.get("FS_NAME") ?? ""
//    static let fsRegion = Self.get("FS_REGION") ?? ""
//
//    static let awsKey = Self.get("AWS_KEY") ?? ""
//    static let awsSecret = Self.get("AWS_SECRET") ?? ""
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
    
    let configuration = PostgresConfiguration(
        hostname: Environment.dbHost,
        port: 5432,
        username: Environment.dbUser,
        password: Environment.dbPass,
        database: Environment.dbName
    )
    
    app.databases.use(.postgres(configuration: configuration), as: .psql)
        
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
        ContentModule(),
        UserModule(),
        FrontendModule(),
        AdminModule()
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

extension Fluent.Model where IDValue == Int {
    var viewIdentifier: String { String(self.id!) }
}
