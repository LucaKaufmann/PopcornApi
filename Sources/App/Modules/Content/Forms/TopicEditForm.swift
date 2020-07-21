import Vapor
import ViewKit

final class TopicEditForm: Form {
    
    typealias Model = TopicModel

    struct Input: Decodable {
        var id: String
        var title: String
    }
    
    var id: String? = nil
    var title = BasicFormField()

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        if !context.id.isEmpty {
            self.id = context.id
        }
        self.title.value = context.title
    }
    
    func read(from model: TopicModel)  {
        self.id = String(model.id!)
        self.title.value = model.title
    }

    func write(to model: TopicModel) {
        model.title = self.title.value
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
        
        if self.title.value.isEmpty {
            self.title.error = "Title is required"
            valid = false
        }
//        if self.slug.value.isEmpty {
//            self.slug.error = "Slug is required"
//            valid = false
//        }
//        if self.excerpt.value.isEmpty {
//            self.excerpt.error = "Excerpt is required"
//            valid = false
//        }
//        if DateFormatter.year.date(from: self.date.value) == nil {
//            self.date.error = "Invalid date"
//            valid = false
//        }
//        if self.content.value.isEmpty {
//            self.content.error = "Content is required"
//            valid = false
//        }
//
        return req.eventLoop.future(valid)
    }
}
