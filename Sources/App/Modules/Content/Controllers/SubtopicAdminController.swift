//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import Fluent
import ViewKit

struct SubtopicAdminController: ViperAdminViewController {
    
    typealias Module = ContentModule
    typealias EditForm = SubtopicEditForm
    typealias Model = SubtopicModel
    
    var listView: String = "Content/Admin/Subtopics/List"
    var editView: String = "Content/Admin/Subtopics/Edit"
    
    func beforeRender(req: Request, form: SubtopicEditForm) -> EventLoopFuture<Void> {
        TopicModel.query(on: req.db).all()
        .mapEach(\.formFieldOption)
        .map { form.topicId.options = $0 }
    }
    
    func listView(req: Request) throws -> EventLoopFuture<View> {
//        
//        return Model.query(on: req.db).with(\.$topic).all()
//            .mapEach(\.viewContext)
//            .flatMap { return req.view.render(self.listView, ListContext($0)) }
        return try self.beforeList(req: req, queryBuilder: Model.query(on: req.db).with(\.$topic)).all()
            .mapEach(\.viewContext)
            .flatMap { req.view.render(self.listView, ListContext($0)) }
    }
    
}
