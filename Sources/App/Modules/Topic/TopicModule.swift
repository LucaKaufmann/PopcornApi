import Vapor
import Fluent
import ViperKit

struct TopicModule: ViperModule {
    
    static var name: String = "topic"
    
    var router: ViperRouter? { TopicRouter() }

    var migrations: [Migration] {
        [
            TopicsMigrations_v1_0_0(),
            TopicMigrationSeed(),
        ]
    }
}
