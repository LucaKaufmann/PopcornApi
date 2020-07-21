//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import Fluent
import Liquid
import ViewKit

struct VideoAdminController: AdminViewController {
    
    typealias Model = VideoModel
    typealias Module = ContentModule
    typealias EditForm = TopicEditForm
    
    var listView: String = "Blog/Admin/Categories/List"
    var editView: String = "Blog/Admin/Categories/Edit"
}
