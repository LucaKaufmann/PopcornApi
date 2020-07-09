//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 9.7.2020.
//

import Fluent
import Vapor

final class Subtopic: Model, Content {
    static let schema = "subtopics"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    @Children(for: \.$subtopic) var videos: [Video]
    @Field(key: "filters")
    var filters: [String]
    @Field(key: "subfilters")
    var subfilters: [String]

    init() { }

    init(id: UUID? = nil, title: String, videos: [Video], filters: [String], subfilters: [String]) {
        self.id = id
        self.title = title
        self.videos = videos
        self.filters = filters
        self.subfilters = subfilters
    }
}
