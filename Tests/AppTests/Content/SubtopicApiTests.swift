//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 28.8.2020.
//

@testable import App
import XCTVapor
import Spec
import Fluent

final class SubtopicApiTests: AppTestCase {

    func testGetSubtopics() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }

        try app
            .describe("Subtopic should return ok")
            .get("/api/content/subtopics")
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(Page<SubtopicModel.ListItem>.self) { content in
                print(content)
            }
            .test()
    }
    
    func testCreateSubtopics() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }
        
        let topic = try TopicModel.query(on: app.db).first().wait()
        guard let t = topic else {
            XCTFail("Missing default topic")
            throw Abort(.notFound)
        }


        let newSubtopic = SubtopicModel.CreateContent(title: "Test subtopic", filters: ["filter1", "filter2"], subfilters: ["subfilter1", "subfilter2"], topicId: t.id!.uuidString)

        var total = 1

        try app
            .describe("Get original subtopics count")
            .get("/api/content/subtopics")
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(Page<SubtopicModel.ListItem>.self) { content in
                total += content.metadata.total
            }
            .test()
        
        try app
            .describe("Create subtopic should return ok")
            .post("/api/content/subtopics")
            .body(newSubtopic)
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(SubtopicModel.GetContent.self) { content in
                XCTAssertEqual(content.title, newSubtopic.title)
        }
        .test()
        
        try app
             .describe("Subtopic count should be correct")
             .get("/api/content/subtopics")
             .bearerToken(token)
             .expect(.ok)
             .expect(.json)
             .expect(Page<SubtopicModel.ListItem>.self) { content in
                 XCTAssertEqual(content.metadata.total, total)
             }
             .test()
    }
        
    func testUpdateSubtopic() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }
        
        let topic = try TopicModel.query(on: app.db).first().wait()
        guard let t = topic else {
            XCTFail("Missing default subtopic")
            throw Abort(.notFound)
        }

        let subtopic = try SubtopicModel
            .query(on: app.db)
            .with(\.$topic)
            .first()
            .unwrap(or: Abort(.notFound))
            .wait()

        let suffix = " updated"

        let newSubtopic = SubtopicModel.UpdateContent(title: subtopic.title + suffix, filters: [subtopic.filters[0] + suffix, subtopic.filters[1] + suffix], subfilters: [subtopic.subfilters[0] + suffix, subtopic.subfilters[1] + suffix], topicId: t.id!.uuidString)
        
        try app
            .describe("Update subtopic should return ok")
            .put("/api/content/subtopics/\(subtopic.id!.uuidString)")
            .body(newSubtopic)
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(SubtopicModel.GetContent.self) { content in
                XCTAssertEqual(content.title, newSubtopic.title)
                XCTAssertEqual(content.filters, newSubtopic.filters)
                XCTAssertEqual(content.subfilters, newSubtopic.subfilters)
            }
            .test()
    }
}
