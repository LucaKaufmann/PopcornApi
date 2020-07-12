//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 9.7.2020.
//

import Fluent
import Vapor

final class SubtopicModel: Model, Content, Codable {
    static let schema = "subtopics"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var filters: FieldKey { "filters" }
        static var subfilters: FieldKey { "subfilters" }
        static var topicId: FieldKey { "topic_id" }
    }
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.title)
    var title: String
    @Children(for: \.$subtopic) var videos: [VideoModel]
    @Field(key: FieldKeys.filters)
    var filters: [String]
    @Field(key: FieldKeys.subfilters)
    var subfilters: [String]
    @Parent(key: FieldKeys.topicId) var topic: TopicModel

    init() { }

    init(id: UUID? = nil, title: String, filters: [String], subfilters: [String]) {
        self.id = id
        self.title = title
        self.filters = filters
        self.subfilters = subfilters
    }
}
