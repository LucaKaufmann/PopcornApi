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
        var topicTitle: String
        var filters: [String]
        var subfilters: [String]

        init(model: SubtopicModel) {
            self.id = model.id!.uuidString
            self.title = model.title
            self.topicTitle = model.topic.title
            self.filters = model.filters
            self.subfilters = model.subfilters
        }
    }

    var viewContext: ViewContext { .init(model: self) }
    var viewIdentifier: String { self.id!.uuidString }
}

extension SubtopicModel: FormFieldOptionRepresentable {
    var formFieldOption: FormFieldOption {
        .init(key: self.id!.uuidString, label: "\(self.topic.title) - \(self.title)")
    }
}

extension TopicModel: ApiRepresentable {

    struct ListItem: Content {
        var id: UUID
        var title: String
    }

    struct GetContent: Content {
        var id: UUID
        var title: String
        var filters: [String]
        var subfilters: [String]
        var topicId: UUID
    }
    
    struct UpsertContent: ValidatableContent {
        var id: UUID
        var title: String
        var filters: [String]
        var subfilters: [String]
        var topicId: UUID
    }

    struct PatchContent: ValidatableContent {
        var id: UUID
        var title: String
        var filters: [String]
        var subfilters: [String]
        var topicId: UUID
    }
    
    var listContent: ListItem {
        .init(id: self.id!,
              title: self.title,)
    }

    var getContent: GetContent {
        .init(id: self.id!,
              title: self.title, filters: self.filters, subfilters: self.subfilters)
    }
    
    private func upsert(_ content: UpsertContent) throws {
        self.title = content.title
    }

    func create(_ content: UpsertContent) throws {
        try self.upsert(content)
    }

    func update(_ content: UpsertContent) throws {
        try self.upsert(content)
    }

    func patch(_ content: PatchContent) throws {
        self.title = content.title ?? self.title
    }
}
