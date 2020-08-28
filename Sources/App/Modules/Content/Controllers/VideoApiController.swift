//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 24.7.2020.
//

import Vapor
import Fluent
import ContentApi

struct VideoApiController: ApiController {
    typealias Model = VideoModel

    func setValidSubtopic(req: Request, model: Model, subtopicId: String) -> EventLoopFuture<Model> {
        guard let uuid = UUID(uuidString: subtopicId) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        return SubtopicModel.find(uuid, on: req.db)
            .unwrap(or: Abort(.badRequest))
            .map { subtopic  in
                model.$subtopic.id = subtopic.id!
                return model
            }
    }
    
    func beforeCreate(req: Request, model: Model, content: Model.CreateContent) -> EventLoopFuture<Model> {
        self.setValidSubtopic(req: req, model: model, subtopicId: content.subtopicId)
    }

    func beforeUpdate(req: Request, model: Model, content: Model.UpdateContent) -> EventLoopFuture<Model> {
        self.setValidSubtopic(req: req, model: model, subtopicId: content.subtopicId)
    }
}
