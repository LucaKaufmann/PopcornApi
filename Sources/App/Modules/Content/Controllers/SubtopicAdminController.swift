//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import Fluent
import ViewKit

struct SubtopicAdminController: AdminViewController {

    typealias EditForm = TopicEditForm
    typealias Model = SubtopicModel
    
    var listView: String = "Blog/Admin/Categories/List"
    var editView: String = "Blog/Admin/Categories/Edit"
}
