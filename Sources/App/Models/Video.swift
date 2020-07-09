import Fluent
import Vapor

final class Video: Model, Content {
    static let schema = "videos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    @Field(key: "url")
    var url: String
    @Field(key: "tags")
    var tags: [String]
    @Field(key: "description")
    var description: String
    @Field(key: "author")
    var author: String

    init() { }

    init(id: UUID? = nil, title: String, url: String, tags: [String], description: String, author: String) {
        self.id = id
        self.title = title
        self.url = url
        self.tags = tags
        self.description = description
        self.author = author
    }
}
