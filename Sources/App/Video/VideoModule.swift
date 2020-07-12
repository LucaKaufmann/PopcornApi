//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 11.7.2020.
//

import Vapor
import Fluent

struct VideoModule: Module {
    
    var router: RouteCollection? { VideoRouter() }

    var migrations: [Migration] {
        [
            VideoMigrations_v1_0_0(),
        ]
    }
}

