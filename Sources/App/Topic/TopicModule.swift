import Vapor
import Fluent

struct TopicModule: Module {
    
    var router: RouteCollection? { TopicRouter() }

    var migrations: [Migration] {
        [
            TopicsMigrations_v1_0_0(),
            TopicMigrationSeed(),
        ]
    }
}
