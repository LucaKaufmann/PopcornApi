import Vapor
import Fluent
import ContentApi
import ViewKit
import ViperKit

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
//    @Children(for: \.$topic) var subtopics: [SubtopicModel]
    
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
