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
import SDWebImage
import FirebaseStorageUI

class CategoryViewModel : CategoryProtocol
    // https://krakendev.io/blog/the-right-way-to-write-a-singleton
    // nice website for singletons in a swifty way :D
{
    static let sharedInstance = CategoryViewModel()
    var ref = Database.database().reference()

    var categories = [Category]()
    
    // read from Database
    
    // Admin speciefied view of Categories
    func getCategories() {
        print("im starting my getCategories now")
        self.ref.child("categories")
            .observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, String>> ?? [String : [String : String]]()
            
            self.categories = categoriesFirebase.flatMap { category in
                Category(name: category.key, image: category.value["img-url"]!)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
        })
    }
    
    // User specified View of Categories
    func getThemeCategories() {
        
        var imageURLs = Dictionary<String, String>()
        Constants.refs.databaseCategories.observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, String>> ?? [String : [String : String]]()
            
            categoriesFirebase.forEach{category in
                imageURLs[category.key] = category.value["img-url"]
            }
        })
        
        Constants.refs.databaseThemes.observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
            
            for thisElement in categoriesFirebase {
                let themeData = thisElement.value
                let cat = themeData["categories"] as! [String:Bool]
                for categoryName in cat.keys {
                    if (!self.checkForDuplicates(categories: self.categories, categoryName: categoryName)) {
                        if let imageURL = imageURLs[categoryName] {
                            self.categories.append(Category(name: categoryName, image: imageURL))
                        }
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
        })
    }
    
    func checkForDuplicates(categories : [Category], categoryName : String) -> Bool {
        for everything in categories {
            if(everything.title == categoryName) {
                return true
            }
        }
        return false
    }
    
    // push to Database
    func pushCatToDatabase(category : Category) {
        // LATE TODO: name of category has to be unique
        let eventRefChild = self.ref.child("categories").child(category.title)
        eventRefChild.setValue(["img-url": category.image])
    }
}
