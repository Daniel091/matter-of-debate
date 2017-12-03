//
//  CategoryViewModel.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 03.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CategoryViewModel
: CategoryProtocol
{
    var ref = Database.database().reference()

    // read from Database
    
    func getCategories() -> [Category] {
        var categories = [Category]()
        self.ref.child("categories").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let dummyBE = postDict as? Dictionary<String, Dictionary<String, String>> ?? NSDictionary() as! Dictionary<String, Dictionary<String, String>>
            
            for categoryElement in dummyBE {
               categories.append(Category(name: categoryElement.key, image: categoryElement.value["img-url"]!))
            }
            
        })
        
        return categories
    }
    
    // get key and value from subtree in categoryname (ID)
//    func getCategories() -> [Category] {
//        var categories = [Category]()
//        self.ref.child("categories").observe(.childAdded, with: { (snapshot) in
//            let postDict = snapshot.value
//                let dummyBE = postDict as? [String : String] ?? [:]
//
//            for categoryElement in dummyBE {
//                categories.append(Category(name: categoryElement.key, image: categoryElement.value))
//            }
//        })
//
//        return categories
//    }
    
    // push to Database
    func pushCatToDatabase(category : Category) {
        
        
        // TODO: name of category has to be unique
        let eventRefChild = self.ref.child("categories").child(category.title)
        eventRefChild.setValue(["img-url": category.image])
        
    }
}
