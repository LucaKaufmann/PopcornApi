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
    typealias IDValue = Int
    
    static let name: String = "subtopics"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var filters: FieldKey { "filters" }
        static var subfilters: FieldKey { "subfilters" }
        static var topicId: FieldKey { "topic_id" }
        static var subtopicId: FieldKey { "subtopicId" }
    }
    
    @ID(custom: FieldKeys.subtopicId, generatedBy: .user)
    var id: Int?

    @Field(key: FieldKeys.title)
    var title: String
    @Children(for: \.$subtopic) var videos: [VideoModel]
    @Field(key: FieldKeys.filters)
    var filters: [String]
    @Field(key: FieldKeys.subfilters)
    var subfilters: [String]
    @Parent(key: FieldKeys.topicId) var topic: TopicModel

    init() { }

    init(id: Int, title: String, filters: [String], subfilters: [String], topicId: Int) {
        self.id = id
        self.title = title
        self.filters = filters
        self.subfilters = subfilters
        self.$topic.id = topicId
    }
}

extension SubtopicModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: Int
        var title: String

        init(model: SubtopicModel) {
            self.id = model.id!
            self.title = model.title
        }
    }

    var viewContext: ViewContext { .init(model: self) }
    var viewIdentifier: String { String(self.id!) }
}

