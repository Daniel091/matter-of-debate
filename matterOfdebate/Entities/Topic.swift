//
//  Topic.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 03.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

struct Topic {
    
    let title : String
    let imageUrl : String
    let description : String
    let categories : [String]
    let id : String
    let isActive: Bool = true
    
    init (name: String, description: String, categories: [String], imageUrl : String, id : String = "not_set") {
        self.title = name
        self.description = description
        self.categories = categories
        self.imageUrl = imageUrl
        self.id = id
    }
}
