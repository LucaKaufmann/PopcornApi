//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 28.8.2020.
//

@testable import App
import Spec
import Fluent

final class TopicApiTests: AppTestCase {

    func testGetTopics() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }

        try app
            .describe("Topic should return ok")
            .get("/api/content/topics")
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(Page<TopicModel.ListItem>.self) { content in
                print(content)
            }
            .test()
    }
    
    func testCreateTopics() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }


        let newTopic = TopicModel.CreateContent(title: "Test topic")

        var total = 1

        try app
            .describe("Get original topics count")
            .get("/api/content/topics")
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(Page<TopicModel.ListItem>.self) { content in
                total += content.metadata.total
            }
            .test()
        
        try app
            .describe("Create topic should return ok")
            .post("/api/content/topics")
            .body(newTopic)
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(TopicModel.GetContent.self) { content in
                XCTAssertEqual(content.title, newTopic.title)
        }
        .test()
        
        try app
             .describe("Topic count should be correct")
             .get("/api/content/topics")
             .bearerToken(token)
             .expect(.ok)
             .expect(.json)
             .expect(Page<TopicModel.ListItem>.self) { content in
                 XCTAssertEqual(content.metadata.total, total)
             }
             .test()
    }
    
    func testUpdateTopic() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }

        let topic = try TopicModel
            .query(on: app.db)
            .first()
            .unwrap(or: Abort(.notFound))
            .wait()

        let suffix = " updated"

        let newTopic = TopicModel.UpdateContent(title: topic.title + suffix)
        
        try app
            .describe("Update topic should return ok")
            .put("/api/content/topics/\(topic.id!.uuidString)")
            .body(newTopic)
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(TopicModel.GetContent.self) { content in
                XCTAssertEqual(content.id, topic.id?.uuidString)
                XCTAssertEqual(content.title, newTopic.title)
            }
            .test()
    }
}

