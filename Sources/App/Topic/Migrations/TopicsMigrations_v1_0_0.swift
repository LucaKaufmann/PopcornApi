//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 11.7.2020.
//

import Fluent

struct TopicsMigrations_v1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(TopicModel.schema)
            .field(TopicModel.FieldKeys.topicId, .int, .required)
            .field(TopicModel.FieldKeys.title, .string, .required)
            .unique(on: TopicModel.FieldKeys.topicId)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(TopicModel.schema).delete()
    }
}
