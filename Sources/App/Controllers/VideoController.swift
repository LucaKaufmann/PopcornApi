import Fluent
import Vapor

struct VideoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let videoss = routes.grouped("videos")
        videoss.get(use: index)
        videoss.post(use: create)
        videoss.group(":videoID") { video in
            video.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Video]> {
        return Video.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Video> {
        let video = try req.content.decode(Video.self)
        return video.save(on: req.db).map { video }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Video.find(req.parameters.get("videoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
