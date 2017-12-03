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
    let categoryVM = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoriesUpdated), name: NSNotification.Name(rawValue: "categoriesUpdated"), object: nil)
    
        categoryVM.getCategories()
        
        //let categoryGenerator = CategoryGeneratorMock()
        //categories = categoryGenerator.getCategories()
    }
    
    @objc private func categoriesUpdated () {
        categoriesCollectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryVM.categories.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < categoryVM.categories.count else {
            print("foobar add element")
            let catVM = CategoryViewModel()
            // TODO: dummy = userIput(AdminView)
            catVM.pushCatToDatabase(category: Category(name: "dummy2", image: "Image"))
            return
        }
        
        print("foobar \(indexPath.row)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.row < categoryVM.categories.count else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            // TODO: plus icon
            if let image = UIImage(named: "Image")?.withHorizontallyFlippedOrientation() {
                cell.displayContent(image: image, title: "+")
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categoryVM.categories[indexPath.row]
        
        if let image = UIImage(named: category.image) {
            cell.displayContent(image: image, title: category.title)
        } else {
            // TODO: actual dummy image
            cell.displayContent(image: UIImage(named: "Image")!, title: category.title)
        }
        
        return cell
    }
    
    
}
