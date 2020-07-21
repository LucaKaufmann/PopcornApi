//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 20.7.2020.
//

import Vapor
import Fluent

struct TopicFrontendController {
    
    func topicView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            struct TopicViewContext: Encodable {
                var subtopic : TopicModel.ViewContext
            }
            let title: String
            let items: [TopicViewContext]
        }

        return TopicModel.query(on: req.db)
            .sort(\.$title, .descending)
            .all()
            .mapEach { Context.TopicViewContext(subtopic: $0.viewContext) }
            .flatMap {
                let context = Context(title: "Topics", items: $0)
                return req.view.render("Blog/Frontend/Blog", context)
            }
    }
}
