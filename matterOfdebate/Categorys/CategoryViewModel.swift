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
        self.ref.child("categories").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, String>> ?? [String : [String : String]]()
            
            self.categories = categoriesFirebase.flatMap { Category(name: $0.key, image: $0.value["img-url"]!) }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
        })
    }
    
    // User specified View of Categories
    func getTopicCategories() {
        
//        var themesRef = Constants.refs.databaseThemes
//        var themesHandle = themesRef.queryOrdered(byChild: "categories/")
//                .queryEqual(toValue: true)
//                .observe(.childAdded, with: { (snapshot) -> Void in
        //)
        
        
        
        self.ref.child("themes").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value
            let categoriesFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
            
            for thisElement in categoriesFirebase {
                let valuesToWant = thisElement.value
                let cat = valuesToWant["categories"] as! [String:Bool]
                for element in cat.keys {
                    // TODO: save a new CategoriesList, get image from getCategories
                    
                    //let reference = Storage.storage().reference(forURL: )
                    
                    // TODO: Controller und Entity umbauen, dass sie eine reference bekommen und kein Bild mehr
                    //cell.cellTheme_1.sd_setImage(with: reference)

                    
                    if (!self.checkForDuplicates(categories: self.categories, element: element)) {
                        // TODO get image from category and storage
                        
                        self.categories.append(Category(name: element, image: "Image"))
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
        })
    }
    
    func checkForDuplicates(categories : [Category], element : String) -> Bool {
        for everything in categories {
            if(everything.title == element) {
                return true
            }
        }
        return false
    }
    
    // push to Database
    func pushCatToDatabase(category : Category) {
        // TODO: name of category has to be unique
        let eventRefChild = self.ref.child("categories").child(category.title)
        eventRefChild.setValue(["img-url": category.image])
        
    }
}
