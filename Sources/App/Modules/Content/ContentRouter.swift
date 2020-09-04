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
        
        let publicApi = routes.grouped("api", "content")
        
        let privateApi = publicApi.grouped([
            UserTokenModel.authenticator(),
            UserModel.guardMiddleware(),
        ])
        
        let publicTopics = publicApi.grouped("topics")
        let privateTopics = privateApi.grouped("topics")
        let publicSubtopics = publicApi.grouped("subtopics")
        let privateSubtopics = privateApi.grouped("subtopics")
        let publicVideos = publicApi.grouped("videos")
        let privateVideos = privateApi.grouped("videos")
        
        let topicsApiController = TopicApiController()
        topicsApiController.setupListRoute(routes: publicTopics)
        topicsApiController.setupGetRoute(routes: publicTopics)
        
        topicsApiController.setupCreateRoute(routes: privateTopics)
        topicsApiController.setupUpdateRoute(routes: privateTopics)
        topicsApiController.setupPatchRoute(routes: privateTopics)
        topicsApiController.setupDeleteRoute(routes: privateTopics)

        let subtopicsApiController = SubtopicApiController()
        subtopicsApiController.setupListRoute(routes: publicSubtopics)
        subtopicsApiController.setupGetRoute(routes: publicSubtopics)
        
        subtopicsApiController.setupCreateRoute(routes: privateSubtopics)
        subtopicsApiController.setupUpdateRoute(routes: privateSubtopics)
        subtopicsApiController.setupPatchRoute(routes: privateSubtopics)
        subtopicsApiController.setupDeleteRoute(routes: privateSubtopics)
        
        let videoApiController = VideoApiController()
        videoApiController.setupListRoute(routes: publicVideos)
        videoApiController.setupGetRoute(routes: publicVideos)
        
        videoApiController.setupCreateRoute(routes: privateVideos)
        videoApiController.setupUpdateRoute(routes: privateVideos)
        videoApiController.setupPatchRoute(routes: privateVideos)
        videoApiController.setupDeleteRoute(routes: privateVideos)
    }
}
