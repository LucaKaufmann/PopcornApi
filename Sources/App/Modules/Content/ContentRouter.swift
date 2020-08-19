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
        
        let contentApi = routes.grouped([
            UserTokenModel.authenticator(),
            UserModel.guardMiddleware(),
        ]).grouped("api", "content")
        
        let topicsApiController = TopicApiController()
        topicsApiController.setupRoutes(routes: contentApi, on: "topics")
//        let subtopicsApiController = SubtopicApiController()
//        subtopicsApiController.setupRoutes(routes: contentApi, on: "subtopics")
        let videoApiController = VideoApiController()
        videoApiController.setupRoutes(routes: contentApi, on: "videos")
        
        app.crud("subtopics", model: SubtopicModel.self)
        }
    }
}
