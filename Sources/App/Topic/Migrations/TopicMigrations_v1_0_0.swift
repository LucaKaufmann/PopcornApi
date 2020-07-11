import Fluent

struct TopicMigrations_v1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("videos")
            .id()
            .field("title", .string, .required)
            .field("url", .string, .required)
            .field("tags", .array(of: .string), .required)
            .field("description", .string, .required)
            .field("author", .string, .required)
            .field("subtopic_id", .uuid, .required)
            .foreignKey("subtopic_id", references: SubtopicModel.schema, .id)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("videos").delete()
    }
}
