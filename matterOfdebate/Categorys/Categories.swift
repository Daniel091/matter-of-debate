//
//  Categories.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

struct Category {
    let categoryName : String
    let categoryImage : String
    
    init (name: String, image : String) {
        self.categoryName = name
        self.categoryImage = image
    }
}
