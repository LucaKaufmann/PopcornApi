//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 22.7.2020.
//

import Vapor
import Fluent
import ContentApi

struct TopicApiController: ApiController {
    typealias Model = TopicModel
    
    func get(_ req: Request) throws -> EventLoopFuture<TopicModel.GetContent> {
        return try self.find(req).flatMap { topic in
            return SubtopicModel.query(on: req.db)
                .filter(\.$topic.$id == topic.id!)
                .all()
                .map { posts in
                    var details = topic.getContent
                    details.subtopics = posts.map(\.listContent)
                    return details
                }
        }
    }
}

