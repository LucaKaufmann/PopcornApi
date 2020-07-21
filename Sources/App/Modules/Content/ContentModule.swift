import Vapor
import Fluent
import ViperKit

struct ContentModule: ViperModule {
    
    static var name: String = "content"
    
    var router: ViperRouter? { ContentRouter() }

    var migrations: [Migration] {
        [
            ContentMigrations_v1_0_0(),
            ContentMigrationSeed(),
        ]
    }
}
