//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 11.7.2020.
//

import Vapor
import Fluent
import ViperKit

struct VideoModule: ViperModule {
    
    static var name: String = "video"
    
    var router: ViperRouter? { VideoRouter() }

    var migrations: [Migration] {
        [
            VideoMigrations_v1_0_0(),
        ]
    }
}

