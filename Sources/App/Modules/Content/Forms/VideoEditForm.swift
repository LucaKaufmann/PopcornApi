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
    }
    
    var id: String? = nil
    var title = BasicFormField()
    var url = BasicFormField()
    var description = BasicFormField()

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        if !context.id.isEmpty {
            self.id = context.id
        }
        self.title.value = context.title
        self.url.value = context.url
        self.description.value = context.description
    }
    
    func read(from model: VideoModel)  {
        self.id = String(model.id!)
        self.title.value = model.title
        self.url.value = model.url
    }

    func write(to model: VideoModel) {
        model.title = self.title.value
        model.url = self.url.value
        model.description = self.description.value
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
//        if self.content.value.isEmpty {
//            self.content.error = "Content is required"
//            valid = false
//        }
//
        return req.eventLoop.future(valid)
    }
}


