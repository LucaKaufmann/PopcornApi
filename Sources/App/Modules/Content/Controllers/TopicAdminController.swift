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

struct TopicAdminController: AdminViewController {
    
    typealias Model = TopicModel
    typealias Module = ContentModule
    typealias EditForm = TopicEditForm
    
    var listView: String = "Content/Admin/Topics/List"
    var editView: String = "Content/Admin/Topics/Edit"
}
