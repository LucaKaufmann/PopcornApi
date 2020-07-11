//
//  AppData.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 4.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

struct AppData: Codable {
    static func == (lhs: AppData, rhs: AppData) -> Bool {
        return lhs.title == rhs.title
    }
    
    var title: String
    var mainColor: String
    var accentColor: String
    var backgroundColor: String
    var font: String
    var url: String
    var aboutUrl: String
    var topics: [TopicModel]
}
