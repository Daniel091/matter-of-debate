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
    let image : String
    let description : String
    let categories : [String]
    
    let isActive: Bool = true
    
    init (name: String, description: String, categories: [String], image : String) {
        self.title = name
        self.description = description
        self.categories = categories
        self.image = image
    }
}
