//
//  CategoryGeneratorMock.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class CategoryGeneratorMock : CategoryProtocol {
    
    func getCategories() -> [Category] {
        var Categories = [Category]()
        
        let dummyCat = Category(name: "string", image: "Image")
        Categories.append(dummyCat)
        
        let dummyCat1 = Category(name: "string", image: "Image")
        Categories.append(dummyCat)
        return Categories
    }
}
