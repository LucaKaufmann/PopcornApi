//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 11.7.2020.
//

import Fluent

struct ContentMigrations_v1_0_0: Migration {
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(TopicModel.schema)
                .id()
                .field(TopicModel.FieldKeys.title, .string, .required)
//                .unique(on: TopicModel.FieldKeys.topicId)
                .create(),
            db.schema(SubtopicModel.schema)
                .id()
                .field(SubtopicModel.FieldKeys.title, .string, .required)
                .field(SubtopicModel.FieldKeys.filters, .array(of: .string), .required)
                .field(SubtopicModel.FieldKeys.subfilters, .array(of: .string), .required)
                .field(SubtopicModel.FieldKeys.topicId, .uuid, .required)
//                .unique(on: SubtopicModel.FieldKeys.subtopicId)
                .foreignKey(SubtopicModel.FieldKeys.topicId,
                            references: TopicModel.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade)
                .create(),
            db.schema(VideoModel.schema)
                .id()
                .field(VideoModel.FieldKeys.title, .string, .required)
                .field(VideoModel.FieldKeys.url, .string, .required)
                .field(VideoModel.FieldKeys.tags, .array(of: .string), .required)
                .field(VideoModel.FieldKeys.description, .string, .required)
                .field(VideoModel.FieldKeys.author, .string, .required)
                .field(VideoModel.FieldKeys.subtopicId, .uuid, .required)
                .foreignKey(VideoModel.FieldKeys.subtopicId,
                            references: SubtopicModel.schema, .id,
                        onDelete: .cascade,
                        onUpdate: .cascade)
                .create(),
        ])
        
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(TopicModel.schema).delete(),
            db.schema(SubtopicModel.schema).delete(),
            db.schema(VideoModel.schema).delete(),
        ])
    }
}
