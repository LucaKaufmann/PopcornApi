import Fluent
import Vapor

func routes(_ app: Application) throws {

    let apiRoutes = app.grouped("api", "v1")
    
    try apiRoutes.register(collection: VideoController())
    try apiRoutes.register(collection: SubtopicController())
}
