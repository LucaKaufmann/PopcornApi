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

final class VideoApiTests: AppTestCase {

    func testGetVideos() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }

        try app
            .describe("Videos should return ok")
            .get("/api/content/videos")
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(Page<VideoModel.ListItem>.self) { content in
                print(content)
            }
            .test()
    }
    
    func testCreateVideos() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }
        
        let subtopic = try SubtopicModel.query(on: app.db).first().wait()
        guard let s = subtopic else {
            XCTFail("Missing default subtopic")
            throw Abort(.notFound)
        }


        let newVideo = VideoModel.CreateContent(title: "Test video", url: "https://youtube.com/test", tags: ["tag1", "tag2"], description: "Test description", author: "Test author", subtopicId: s.id!.uuidString)

        var total = 1

        try app
            .describe("Get original videos count")
            .get("/api/content/videos")
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(Page<VideoModel.ListItem>.self) { content in
                total += content.metadata.total
            }
            .test()
        
        try app
            .describe("Create video should return ok")
            .post("/api/content/videos")
            .body(newVideo)
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(VideoModel.GetContent.self) { content in
                XCTAssertEqual(content.title, newVideo.title)
        }
        .test()
        
        try app
             .describe("Subtopic count should be correct")
             .get("/api/content/videos")
             .bearerToken(token)
             .expect(.ok)
             .expect(.json)
             .expect(Page<VideoModel.ListItem>.self) { content in
                 XCTAssertEqual(content.metadata.total, total)
             }
             .test()
    }
    
    func testUpdateVideos() throws {
        let app = try self.createTestApp()
        let token = try self.getApiToken(app)
        defer { app.shutdown() }
        
        let subtopic = try SubtopicModel.query(on: app.db).first().wait()
        guard let s = subtopic else {
            XCTFail("Missing default subtopic")
            throw Abort(.notFound)
        }

        let video = try VideoModel
            .query(on: app.db)
            .with(\.$subtopic)
            .first()
            .unwrap(or: Abort(.notFound))
            .wait()

        let suffix = " updated"

        let newVideo = VideoModel.UpdateContent(title: video.title + suffix, url: video.url + suffix, tags: [video.tags[0] + suffix, video.tags[1] + suffix], description: video.description + suffix, author: video.author + suffix, subtopicId: s.id!.uuidString)
        
        try app
            .describe("Update video should return ok")
            .put("/api/content/videos/\(video.id!.uuidString)")
            .body(newVideo)
            .bearerToken(token)
            .expect(.ok)
            .expect(.json)
            .expect(VideoModel.GetContent.self) { content in
                XCTAssertEqual(content.title, newVideo.title)
                XCTAssertEqual(content.tags, newVideo.tags)
                XCTAssertEqual(content.description, newVideo.description)
                XCTAssertEqual(content.author, newVideo.author)
            }
            .test()
    }
}
