import Vapor
import Fluent
import ContentApi
import ViewKit
import ViperKit
import CRUDKit

final class TopicModel: ViperModel, Codable {
    
    typealias Module = ContentModule
    
    static let name = "topics"
    
    struct FieldKeys {
        static var topicId: FieldKey { "topicId" }
        static var title: FieldKey { "title" }
    }
    
    @ID(key: .id)
    var id: UUID?
//    @ID(custom: FieldKeys.topicId, generatedBy: .user) var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Children(for: \.$topic) var subtopics: [SubtopicModel]
    
    init() { }
    
    init(id: UUID? = nil,
         title: String)
    {
        self.id = id
        self.title = title
    }
}

extension TopicModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var title: String

        init(model: TopicModel) {
            self.id = model.id!.uuidString
            self.title = model.title
        }
    }

    var viewContext: ViewContext { .init(model: self) }
    var viewIdentifier: String { self.id!.uuidString }
}

extension TopicModel: FormFieldOptionRepresentable {
    var formFieldOption: FormFieldOption {
        .init(key: self.id!.uuidString, label: self.title)
    }
}

extension TopicModel: CRUDModel {
    
}

//extension TopicModel: ApiRepresentable {
//
//    struct ListItem: Content {
//        var id: UUID
//        var title: String
//    }
//
//    struct GetContent: Content {
//        var id: UUID
//        var title: String
//    }
//
//    struct UpsertContent: ValidatableContent {
//        var title: String
//    }
//
//    struct PatchContent: ValidatableContent {
//        var title: String?
//        var slug: String?
//    }
//
//    var listContent: ListItem {
//        .init(id: self.id!,
//              title: self.title)
//    }
//
//    var getContent: GetContent {
//        .init(id: self.id!,
//              title: self.title)
//    }
//
//    private func upsert(_ content: UpsertContent) throws {
//        self.title = content.title
//    }
//
//    func create(_ content: UpsertContent) throws {
//        try self.upsert(content)
//    }
//
//    func update(_ content: UpsertContent) throws {
//        try self.upsert(content)
//    }
//
//    func patch(_ content: PatchContent) throws {
//        self.title = content.title ?? self.title
//    }
//}

