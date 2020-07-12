import Vapor
import Fluent
import PopcornCore

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
        var topics = [TopicModel]()
        for topic in appData.topics {
            let topicModel = TopicModel(title: topic.title)
//            topicModel.create(on: db)
//
//            var subtopics = [SubtopicModel]()
//            for subtopic in topic.subTopics {
//                subtopics.append(SubtopicModel(title: subtopic.title, filters: subtopic.filters!, subfilters: subtopic.subfilters!))
//            }
//            print(subtopics)
//            topicModel.$subtopics.create(subtopics, on: db)
            topics.append(topicModel)
        }
        
//        return topics.create(on: db).map({
//            let title = $0.title
//            let topicData = appData.topics.first(where: { $0.title == topic.title })
//            let subtopics = topicData.subtopics
//
//            var subtopicModels = [SubtopicModel]()
//            for subtopic in subtopics {
//                subtopics.append(SubtopicModel(title: subtopic.title, filters: subtopic.filters!, subfilters: subtopic.subfilters!))
//            }
//            print(subtopicModels)
//            return topic.$subtopics.create(subtopicModels, on: db)
//        })
        
        return topics.create(on: db)
        
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
