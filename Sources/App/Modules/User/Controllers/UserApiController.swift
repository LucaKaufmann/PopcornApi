
//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 18.7.2020.
//

import Vapor
import Fluent
import ContentApi

struct UserApiController {
    
    func login(req: Request) throws -> EventLoopFuture<UserTokenModel.GetContent> {
        guard let user = req.auth.get(UserModel.self) else {
            throw Abort(.unauthorized)
        }
        let tokenValue = [UInt8].random(count: 16).base64
        let token = UserTokenModel(value: tokenValue, userId: user.id!)
        return token.create(on: req.db).map { token.getContent }
    }
}
