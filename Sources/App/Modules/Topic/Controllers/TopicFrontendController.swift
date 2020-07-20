//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 20.7.2020.
//

import Vapor
import Fluent

struct TopicFrontendController {
    
    func blogView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            struct PostWithCategory: Encodable {
                var category: BlogCategoryModel.ViewContext
                var post: BlogPostModel.ViewContext
            }
            let title: String
            let items: [PostWithCategory]
        }

        return BlogPostModel.query(on: req.db)
            .sort(\.$date, .descending)
            .with(\.$category)
            .all()
            .mapEach { Context.PostWithCategory(category: $0.category.viewContext,
                                                post: $0.viewContext) }
            .flatMap {
                let context = Context(title: "Topic", items: $0)
                return req.view.render("Topic/Frontend/Topics", context)
            }
    }
}
