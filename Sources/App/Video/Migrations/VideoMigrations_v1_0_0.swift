import Fluent

struct VideoMigrations_v1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(VideoModel.schema)
            .id()
            .field(VideoModel.FieldKeys.title, .string, .required)
            .field(VideoModel.FieldKeys.url, .string, .required)
            .field(VideoModel.FieldKeys.tags, .array(of: .string), .required)
            .field(VideoModel.FieldKeys.description, .string, .required)
            .field(VideoModel.FieldKeys.author, .string, .required)
            .field(VideoModel.FieldKeys.subtopicId, .uuid, .required)
            .foreignKey(VideoModel.FieldKeys.subtopicId, references: SubtopicModel.schema, .id)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("videos").delete()
    }
}
