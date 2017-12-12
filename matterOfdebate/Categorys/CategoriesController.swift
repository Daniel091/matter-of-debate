//
//  CategoriesController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 24.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit

class CategoriesController: UICollectionViewController {
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoriesUpdated), name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
    
        // check if current user is Admin or not and set IF to true if finished
        let user_obj = SingletonUser.sharedInstance.user
        if (user_obj.isAdmin) {
            CategoryViewModel.sharedInstance.getCategories()
        } else {
            CategoryViewModel.sharedInstance.getTopicCategories()
        }
        
        //let categoryGenerator = CategoryGeneratorMock()
        //categories = categoryGenerator.getCategories()
    }
    
    @objc private func categoriesUpdated () {
        categoriesCollectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (SingletonUser.sharedInstance.user.isAdmin) {
            return CategoryViewModel.sharedInstance.categories.count + 1
        }
        return CategoryViewModel.sharedInstance.categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < CategoryViewModel.sharedInstance.categories.count else {
            print("foobar add element")
            let catVM = CategoryViewModel()
            // TODO: dummy = userIput(AdminView)
            catVM.pushCatToDatabase(category: Category(name: "test301", image: "Image"))
            return
        }
        
        print("foobar \(indexPath.row)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.row < CategoryViewModel.sharedInstance.categories.count else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            // TODO: plus icon
            if let image = UIImage(named: "Image")?.withHorizontallyFlippedOrientation() {
                cell.displayContent(image: image, title: "+")
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = CategoryViewModel.sharedInstance.categories[indexPath.row]
        
        if let image = UIImage(named: category.image) {
            cell.displayContent(image: image, title: category.title)
        } else {
            // TODO: actual dummy image
            cell.displayContent(image: UIImage(named: "Image")!, title: category.title)
        }
        
        return cell
    }
    
    
}
