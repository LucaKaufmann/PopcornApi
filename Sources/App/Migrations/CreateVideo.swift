import Fluent

struct CreateVideo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("videos")
            .id()
            .field("title", .string, .required)
            .field("url", .string, .required)
            .field("tags", .array(of: .string), .required)
            .field("description", .string, .required)
            .field("author", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("videos").delete()
    }
}
