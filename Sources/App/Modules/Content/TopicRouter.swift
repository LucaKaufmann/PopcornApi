import Vapor
import ViperKit

struct ContentRouter: ViperRouter {
    
    let topicAdminController = TopicAdminController()
    let subtopicAdminController = SubtopicAdminController()
    let videoAdminController = VideoAdminController()
    
    func boot(routes: RoutesBuilder, app: Application) throws {
        let protected = routes.grouped([
            UserModelSessionAuthenticator(),
            UserModel.redirectMiddleware(path: "/")
        ])
        let content = protected.grouped("admin", "content")
        self.topicAdminController.setupRoutes(routes: content, on: "topics")
        self.subtopicAdminController.setupRoutes(routes: content, on: "subtopics")
        self.videoAdminController.setupRoutes(routes: content, on: "videos")
    }
}
