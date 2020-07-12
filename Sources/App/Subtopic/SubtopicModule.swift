//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 11.7.2020.
//

import Vapor
import Fluent

struct SubtopicModule: Module {
    
    var router: RouteCollection? { SubtopicRouter() }

    var migrations: [Migration] {
        [
            SubtopicsMigrations_v1_0_0(),
        ]
    }
}

