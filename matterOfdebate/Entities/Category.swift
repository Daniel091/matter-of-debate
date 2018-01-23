//
//  Category.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 03.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

struct Category {
    
    let title : String
    let image : String
    let isAddButton: Bool = false
    
    init (name: String, image : String) {
        self.title = name
        self.image = image
    }
}
