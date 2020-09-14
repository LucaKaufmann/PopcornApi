//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 14.9.2020.
//

import Vapor
import ViewKit

final class UserEditForm: Form {
    
    var id: String? = nil
    
    typealias Model = UserModel

    struct Input: Decodable {
        var id: String
        var email: String
        var password: String
    }
    
    var email = BasicFormField()
    var password = BasicFormField()

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        debugPrint(req)
        if !context.id.isEmpty {
            self.id = context.id
        }
        self.email.value = context.email
        self.password.value = context.password
    }
    
    func read(from model: UserModel)  {
        self.id = String(model.id!)
        self.email.value = model.email
        self.password.value = model.password
    }

    func write(to model: UserModel) {
        model.email = self.email.value
        model.password = try! Bcrypt.hash(self.password.value)
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
        
        if self.email.value.isEmpty {
            self.email.error = "Email is required"
            valid = false
        }
//        commenting out
        if self.password.value.isEmpty {
            self.password.error = "Password is required"
            valid = false
        }
        
        return req.eventLoop.future(valid)
    }
}


