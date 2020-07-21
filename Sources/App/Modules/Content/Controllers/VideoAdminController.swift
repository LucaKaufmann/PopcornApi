//
//  File.swift
//  
//
//  Created by Luca Kaufmann on 21.7.2020.
//

import Vapor
import Fluent
import ViewKit

struct VideoAdminController: AdminViewController {

    typealias EditForm = VideoEditForm
    typealias Model = VideoModel
    
    var listView: String = "Content/Admin/Videos/List"
    var editView: String = "Content/Admin/Videos/Edit"
}

