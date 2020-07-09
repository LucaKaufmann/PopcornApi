//
//  Subtopic.swift
//  
//
//  Created by Luca Kaufmann on 9.7.2020.
//

import Fluent

struct CreateSubtopic: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("subtopics")
            .id()
            .field("title", .string, .required)
            .field("filters", .array(of: .string), .required)
            .field("subfilters", .array(of: .string), .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("subtopics").delete()
    }
}
