//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import Fluent
import ViewKit

struct VideoAdminController: ViperAdminViewController {

    typealias Module = ContentModule
    typealias EditForm = VideoEditForm
    typealias Model = VideoModel
    
    var listView: String = "Content/Admin/Videos/List"
    var editView: String = "Content/Admin/Videos/Edit"
    
    func beforeRender(req: Request, form: VideoEditForm) -> EventLoopFuture<Void> {
        SubtopicModel.query(on: req.db).with(\.$topic).all()
        .mapEach(\.formFieldOption)
        .map { form.subtopicId.options = $0 }
    }
    
        func listView(req: Request) throws -> EventLoopFuture<View> {
            return try self.beforeList(req: req, queryBuilder: Model.query(on: req.db).with(\.$subtopic) { subtopic in
                subtopic.with(\.$topic)
            }).all()
                .mapEach(\.viewContext)
                .flatMap { req.view.render(self.listView, ListContext($0)) }
        }
}

