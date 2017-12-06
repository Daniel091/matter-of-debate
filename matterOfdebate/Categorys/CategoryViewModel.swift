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

    var categories = [Category]()
    
    // read from Database
    
    // Admin speciefied view of Categories
    func getCategories() {
        print("im starting my getCategories now")
        self.ref.child("categories").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, String>> ?? [String : [String : String]]()
            
            self.categories = categoriesFirebase.flatMap { Category(name: $0.key, image: $0.value["img-url"]!) }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
        })
    }
    
    // User specified View of Categories
    func getTopicCategories() {
        self.ref.child("themes").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()

            guard let categoryArray = categoriesFirebase.first(where: { $0.key == "categories"})?.value else { return }
            categoryArray.forEach { category in
                guard let castedCategory = category as? [String] else { return }
                for element in castedCategory {
                    // TODO: save a new CategoriesList, get image from getCategories
                    self.categories.append(Category(name: element, image: "Image"))
                }
            }
        })
    }
    
    // push to Database
    func pushCatToDatabase(category : Category) {
        // TODO: name of category has to be unique
        let eventRefChild = self.ref.child("categories").child(category.title)
        eventRefChild.setValue(["img-url": category.image])
        
    }
}
