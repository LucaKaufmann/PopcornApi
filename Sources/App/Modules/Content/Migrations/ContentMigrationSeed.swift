import Vapor
import Fluent
import PopcornCore

struct  ContentMigrationSeed: Migration {
    
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        
        
        let appData: AppData = load(workingDirectory!)
        var topicModels = [TopicModel]()
        var subtopicModels = [SubtopicModel]()
        var videoModels = [VideoModel]()
        
        for topic in appData.topics {
            let topicModel = TopicModel(id: topic.id, title: topic.title)
            let subtopics = topic.subTopics
            
            print("Creating topic \(topic.title)")

            for subtopic in subtopics {
                print("Creating subtopic \(subtopic.title)")
                let id = Int("\(topicModel.id!)\(subtopic.id)") ?? 0
                subtopicModels.append(SubtopicModel(id: id, title: subtopic.title, filters: subtopic.filters!, subfilters: subtopic.subfilters!, topicId: topicModel.id!))
                for video in subtopic.videos {
                    videoModels.append(VideoModel(title: video.title, url: video.url
                        , tags: video.tags, description: "", author: video.author, subtopicId: id))
                }
            }

            topicModels.append(topicModel)
        }
        
//        return topics.create(on: db).optionalFlatMapThrowing({ topic -> TopicModel in
//

//            return topic.$subtopics.create(subtopicModels, on: db)
//        })
        
        return topicModels.create(on: db).flatMap {
            return subtopicModels.create(on: db).flatMap({
                return videoModels.create(on: db)
            })
        }
        
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
