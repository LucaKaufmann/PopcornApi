//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 9.7.2020.
//

import Fluent
import Vapor

struct SubtopicController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let suptopics = routes.grouped("subtopics")
        suptopics.get(use: index)
        suptopics.post(use: create)
        suptopics.group(":subtopicID") { subtopic in
            subtopic.delete(use: delete)
        }
        Subtopics.get(":subtopicID", use: getSubtopic)
        
    }

    func index(req: Request) throws -> EventLoopFuture<[Subtopic]> {
        return Subtopic.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Subtopic> {
        let subtopic = try req.content.decode(Subtopic.self)
        return subtopic.save(on: req.db).map { subtopic }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Subtopic.find(req.parameters.get("subtopicID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getSubtopic(req: Request) throws -> EventLoopFuture<Subtopic> {
        return Subtopic.find(req.parameters.get("subtopicID"), on: req.db).unwrap(or: Abort(.notFound))
    }
}
