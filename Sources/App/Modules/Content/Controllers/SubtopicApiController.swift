//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 24.7.2020.
//

import Vapor
import Fluent
import ContentApi

struct SubtopicApiController: ApiController {
    typealias Model = SubtopicModel

    func setValidTopic(req: Request, model: Model, topicId: String) -> EventLoopFuture<Model> {
        guard let uuid = UUID(uuidString: topicId) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        return TopicModel.find(uuid, on: req.db)
            .unwrap(or: Abort(.badRequest))
            .map { topic  in
                model.$topic.id = topic.id!
                return model
            }
    }
    
    func beforeCreate(req: Request, model: Model, content: Model.CreateContent) -> EventLoopFuture<Model> {
        self.setValidTopic(req: req, model: model, topicId: content.topicId)
    }

    func beforeUpdate(req: Request, model: Model, content: Model.UpdateContent) -> EventLoopFuture<Model> {
        self.setValidTopic(req: req, model: model, topicId: content.topicId)
    }
}
