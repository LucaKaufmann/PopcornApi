//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 9.7.2020.
//

import Fluent
import Vapor
import ContentApi
import ViewKit
import ViperKit


final class SubtopicModel: ViperModel, Codable {
    
    typealias Module = ContentModule
    
    static let name: String = "subtopics"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var filters: FieldKey { "filters" }
        static var subfilters: FieldKey { "subfilters" }
        static var topicId: FieldKey { "topic_id" }
        static var subtopicId: FieldKey { "subtopicId" }
    }
    
    
    @ID(key: .id)
    var id: UUID?
//    @ID(custom: FieldKeys.subtopicId, generatedBy: .user)
//    var id: UUID?

    @Field(key: FieldKeys.title)
    var title: String
    @Children(for: \.$subtopic) var videos: [VideoModel]
    @Field(key: FieldKeys.filters)
    var filters: [String]
    @Field(key: FieldKeys.subfilters)
    var subfilters: [String]
    @Parent(key: FieldKeys.topicId) var topic: TopicModel

    init() { }

    init(id: UUID? = nil, title: String, filters: [String], subfilters: [String], topicId: UUID) {
        self.id = id
        self.title = title
        self.filters = filters
        self.subfilters = subfilters
        self.$topic.id = topicId
    }
}

extension SubtopicModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var title: String

        init(model: SubtopicModel) {
            self.id = model.id!.uuidString
            self.title = model.title
        }
    }

    var viewContext: ViewContext { .init(model: self) }
    var viewIdentifier: String { self.id!.uuidString }
}

