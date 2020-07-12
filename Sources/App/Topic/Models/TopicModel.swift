import Vapor
import Fluent

final class TopicModel: Model, Codable {

    static let schema = "topics"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
    }
    
    @ID() var id: UUID?
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

extension TopicModel {

    struct ViewContext: Encodable {
        var id: String
        var title: String

        init(model: TopicModel) {
            self.id = model.id!.uuidString
            self.title = model.title
        }
    }

    var viewContext: ViewContext { .init(model: self) }
}
