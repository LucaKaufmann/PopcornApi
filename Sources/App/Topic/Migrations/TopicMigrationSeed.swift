import Vapor
import Fluent

struct TopicMigrationSeed: Migration {
    
//    private func uncategorizedPosts(for category: BlogCategoryModel) -> [BlogPostModel] {
//        [
//            .init(title: "California",
//                  slug: "california",
//                  image: "/images/posts/03.jpg",
//                  excerpt: "Voluptates ipsa eos sit distinctio",
//                  date: DateFormatter.year.date(from: "2015")!,
//                  content: "Et non reiciendis et illum corrupti...",
//                  categoryId: category.id!),
//        ]
//    }
    
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        
        
        let appData: AppData = load(workingDirectory!)
        
        return appData.topics.create(on: db)
//        return [defaultCategory, islandsCategory].create(on: db)
//            .flatMap {
//                let posts = self.uncategorizedPosts(for: defaultCategory) + self.islandPosts(for: islandsCategory)
//                return posts.create(on: db)
//            }
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            TopicModel.query(on: db).delete(),
            SubtopicModel.query(on: db).delete(),
            VideoModel.query(on: db).delete(),
        ])
    }
}
