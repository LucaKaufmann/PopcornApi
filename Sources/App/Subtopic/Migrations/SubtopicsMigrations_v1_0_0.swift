//
//  Subtopic.swift
//  
//
//  Created by Luca Kaufmann on 9.7.2020.
//

import Fluent

struct SubtopicsMigrations_v1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(SubtopicModel.schema)
            .id()
            .field(SubtopicModel.FieldKeys.title, .string, .required)
            .field(SubtopicModel.FieldKeys.filters, .array(of: .string), .required)
            .field(SubtopicModel.FieldKeys.subfilters, .array(of: .string), .required)
            .field(SubtopicModel.FieldKeys.topicId, .uuid)
            .foreignKey(SubtopicModel.FieldKeys.topicId, references: TopicModel.schema, .id)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(SubtopicModel.schema).delete()
    }
}
