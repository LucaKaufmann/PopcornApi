//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import ViewKit

final class VideoEditForm: Form {
    
    typealias Model = VideoModel

    struct Input: Decodable {
        var id: String
        var title: String
        var url: String
        var description: String
        var subtopicId: String
    }
    
    var id: String? = nil
    var title = BasicFormField()
    var url = BasicFormField()
    var description = BasicFormField()
    var subtopicId = SelectionFormField()

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        if !context.id.isEmpty {
            self.id = context.id
        }
        self.title.value = context.title
        self.url.value = context.url
        self.description.value = context.description
        self.subtopicId.value = context.subtopicId
    }
    
    func read(from model: VideoModel)  {
        self.id = String(model.id!)
        self.title.value = model.title
        self.url.value = model.url
        self.subtopicId.value = model.$subtopic.id.uuidString
    }

    func write(to model: VideoModel) {
        model.title = self.title.value
        model.url = self.url.value
        model.description = self.description.value
        model.$subtopic.id = UUID(uuidString: self.subtopicId.value)!
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
        
        if self.title.value.isEmpty {
            self.title.error = "Title is required"
            valid = false
        }
        if self.url.value.isEmpty {
            self.url.error = "URL is required"
            valid = false
        }
//        if DateFormatter.year.date(from: self.date.value) == nil {
//            self.date.error = "Invalid date"
//            valid = false
//        }
        let uuid = UUID(uuidString: self.subtopicId.value)
        return SubtopicModel.find(uuid, on: req.db)
        .map { model in
            if model == nil {
                self.subtopicId.error = "Subtopic identifier error"
                valid = false
            }
            return valid
        }
    }
}


