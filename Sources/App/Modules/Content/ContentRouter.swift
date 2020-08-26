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
        ]).grouped("api")
        
//        let topicsApiController = TopicApiController()
//        topicsApiController.setupRoutes(routes: contentApi, on: "topics")
//        let subtopicsApiController = SubtopicApiController()
//        subtopicsApiController.setupRoutes(routes: contentApi, on: "subtopics")
//        let videoApiController = VideoApiController()
//        videoApiController.setupRoutes(routes: contentApi, on: "videos")
        contentApi.crud("topics", model: TopicModel.self)
        
        contentApi.crud("subtopics", model: SubtopicModel.self) { routes, parentController in
            routes.crud("videos", children: VideoModel.self, on: parentController, via: \.$videos)
        }
            
//        app.crud("topics", model: TopicModel.self) { contentApi, parentController in
//            contentApi.crud("subtopics", children: SubtopicModel.self, on: parentController, via: \.$subtopics) { contentApi, parentController in
//                contentApi.crud("videos", children: VideoModel.self, on: parentController, via: \.$videos)
//            }
//        }

    }
}
