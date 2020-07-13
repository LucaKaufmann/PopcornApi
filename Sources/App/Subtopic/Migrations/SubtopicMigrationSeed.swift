////
////  File.swift
////  
////
////  Created by Luca Kaufmann on 12.7.2020.
////
//
//import Foundation
//import Fluent
//import PopcornCore
//
//struct SubtopicMigrationSeed: Migration {
//        
//        func prepare(on db: Database) -> EventLoopFuture<Void> {
//            
//            
//            let appData: AppData = load(workingDirectory!)
//            
//            
//            for topic in appData.topics {
//                // if topic in database, create subtopics
//                let topicQuery = TopicModel.query(on: db)
//                    .filter(\.$title == topic.title)
//                    .first()
//                
//                topicQuery.whenSuccess({ result in
//                    if let topicModel = result {
//                        var subtopics = [SubtopicModel]()
//                        for subtopic in topic.subTopics {
//                            subtopics.append(SubtopicModel(title: subtopic.title, filters: subtopic.filters!, subfilters: subtopic.subfilters!))
//                        }
//                        return topicModel.$subtopics.create(subtopics, on: db)
//                    }
//                })
//
//            }
//            let future = EventLoopFuture<Void>()
//            return future
//        }
//        
//        func revert(on db: Database) -> EventLoopFuture<Void> {
//            db.eventLoop.flatten([
//                TopicModel.query(on: db).delete(),
//                SubtopicModel.query(on: db).delete(),
//                VideoModel.query(on: db).delete(),
//            ])
//        }
//    }
