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

    typealias EditForm = SubtopicEditForm
    typealias Model = SubtopicModel
    
    var listView: String = "Content/Admin/Subtopics/List"
    var editView: String = "Content/Admin/Subtopics/Edit"
}
