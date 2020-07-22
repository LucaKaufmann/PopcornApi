//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import ViewKit

final class SubtopicEditForm: Form {
    
    typealias Model = SubtopicModel

    struct Input: Decodable {
        var id: String
        var title: String
        var topicId: String
        var filters: [String]
        var subfilters: [String]
    }
    
    var id: String? = nil
    var title = BasicFormField()
    var topicId = SelectionFormField()
    var filters = ArrayFormField()
    var subfilters = ArrayFormField()

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        debugPrint(req)
        if !context.id.isEmpty {
            self.id = context.id
        }
        self.title.value = context.title
        self.topicId.value = context.topicId
        self.filters.values = context.filters
        self.subfilters.values = context.subfilters
    }
    
    func read(from model: SubtopicModel)  {
        self.id = String(model.id!)
        self.title.value = model.title
        self.topicId.value = model.$topic.id.uuidString
        self.filters.values = model.filters
        self.subfilters.values = model.subfilters
    }

    func write(to model: SubtopicModel) {
        model.title = self.title.value
        model.$topic.id = UUID(uuidString: self.topicId.value)!
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
        
        if self.title.value.isEmpty {
            self.title.error = "Title is required"
            valid = false
        }
        
        let uuid = UUID(uuidString: self.topicId.value)
        return TopicModel.find(uuid, on: req.db)
        .map { model in
            if model == nil {
                self.topicId.error = "Topic identifier error"
                valid = false
            }
            return valid
        }
    }
}

