//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 11.7.2020.
//

import Vapor
import Fluent
import ViperKit

struct SubtopicModule: ViperModule {
    
    static var name: String = "subtopic"
    
    var router: ViperRouter? { SubtopicRouter() }

    var migrations: [Migration] {
        [
            SubtopicsMigrations_v1_0_0(),
        ]
    }
}

