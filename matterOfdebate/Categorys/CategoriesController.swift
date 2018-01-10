//
//  CategoriesController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 24.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI

class CategoriesController: UICollectionViewController {
    
    private let storage = Storage.storage()
    private var selectedCategory: Category?
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoriesUpdated), name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
    
        // check if current user is Admin or not and set IF to true if finished
        let user_obj = SingletonUser.sharedInstance.user
        if (user_obj.isAdmin) {
            CategoryViewModel.sharedInstance.getCategories()
        } else {
            CategoryViewModel.sharedInstance.getThemeCategories()
        }
    }
    
    @objc private func categoriesUpdated () {
        categoriesCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? OpinionController {
            viewController.delegate = self
        }
        if let viewController = segue.destination as? SwipeViewController {
            viewController.selectedCat = selectedCategory?.title
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (SingletonUser.sharedInstance.user.isAdmin) {
            return CategoryViewModel.sharedInstance.categories.count + 1
        }
        return CategoryViewModel.sharedInstance.categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // trigger Seque showCreateCategoryView when user clicks on last element in collection
        guard indexPath.row < CategoryViewModel.sharedInstance.categories.count else {
            self.performSegue(withIdentifier: "showCreateCategoryView", sender: self)
            return
        }
        
        print("foobar \(indexPath.row)")
        let categories: [Category] = CategoryViewModel.sharedInstance.categories
        selectedCategory = categories[indexPath.item]
        
        self.performSegue(withIdentifier: "toSwipe", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.row < CategoryViewModel.sharedInstance.categories.count else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            if let image = UIImage(named: "PlusCategory")?.withHorizontallyFlippedOrientation() {
                cell.displayContent(image: image, title: "")
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = CategoryViewModel.sharedInstance.categories[indexPath.row]
        
        let reference = storage.reference(forURL: category.image)
        cell.imageView.sd_setImage(with: reference, placeholderImage: UIImage(named: "Image"))
        cell.themeLabel.text = category.title
        
        return cell
    }
}

extension CategoriesController: TabBarDelegate {
    
    func switchToTab(_ index: Int) {
        tabBarController?.selectedIndex = index
    }
}
