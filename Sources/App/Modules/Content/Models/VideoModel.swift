import Fluent
import Vapor
import ViperKit
import ContentApi
import ViewKit
import ViperKit

final class VideoModel: ViperModel, Codable {
    
    
    
    typealias Module = ContentModule
    
    static var name: String = "videos"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var url: FieldKey { "url" }
        static var tags: FieldKey { "tags" }
        static var description: FieldKey { "description" }
        static var author: FieldKey { "author" }
        static var subtopicId: FieldKey { "subtopic_id" }
    }
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.title)
    var title: String
    @Field(key: FieldKeys.url)
    var url: String
    @Field(key: FieldKeys.tags)
    var tags: [String]
    @Field(key: FieldKeys.description)
    var description: String
    @Field(key: FieldKeys.author)
    var author: String
    @Parent(key: FieldKeys.subtopicId) var subtopic: SubtopicModel

    init() { }

    init(id: UUID? = nil, title: String, url: String, tags: [String], description: String, author: String, subtopicId: UUID) {
        self.id = id
        self.title = title
        self.url = url
        self.tags = tags
        self.description = description
        self.author = author
        self.$subtopic.id = subtopicId
    }
}

extension VideoModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var title: String
        var subtopicTitle: String
        var topicTitle: String

        init(model: VideoModel) {
            self.id = model.id!.uuidString
            self.title = model.title
            self.topicTitle = model.subtopic.topic.title
            self.subtopicTitle = model.subtopic.title
        }
    }

    var viewContext: ViewContext { .init(model: self) }
    var viewIdentifier: String { self.id!.uuidString }
}

extension VideoModel: FormFieldOptionRepresentable {
    var formFieldOption: FormFieldOption {
        .init(key: self.id!.uuidString, label: self.title)
    }
}

extension VideoModel: ApiRepresentable {

    struct ListItem: Content {
        var id: UUID
        var title: String
        var url: String
        var tags: [String]
        var description: String
        var author: String
    }

    struct GetContent: Content {
        var id: UUID
        var title: String
        var url: String
        var tags: [String]
        var description: String
        var author: String
    }
    
    struct UpsertContent: ValidatableContent {
        var id: UUID
        var title: String
        var url: String
        var tags: [String]
        var description: String
        var author: String
        var subtopicId: UUID
    }

    struct PatchContent: ValidatableContent {
        var id: UUID
        var title: String
        var url: String
        var tags: [String]
        var description: String
        var author: String
        var subtopicId: UUID
    }
    
    var listContent: ListItem {
        .init(id: self.id!,
              title: self.title,
              url: self.url, tags: self.tags,
              description: self.description,
              author: self.author)
    }

    var getContent: GetContent {
        .init(id: self.id!,
        title: self.title,
        url: self.url, tags: self.tags,
        description: self.description,
        author: self.author)
    }
    
    private func upsert(_ content: UpsertContent) throws {
        self.title = content.title
        self.description = content.description
        self.author = content.author
        self.url = content.url
        self.tags = content.tags
    }

    func create(_ content: UpsertContent) throws {
        try self.upsert(content)
    }

    func update(_ content: UpsertContent) throws {
        try self.upsert(content)
    }

    func patch(_ content: PatchContent) throws {
        self.title = content.title
        self.description = content.description
        self.author = content.author
        self.url = content.url
        self.tags = content.tags
    }
}

