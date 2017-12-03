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
    var categories = [Category]() {
        didSet {
            
        }
    }
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryVM = CategoryViewModel()
        categories = categoryVM.getCategories()
        
        //let categoryGenerator = CategoryGeneratorMock()
        //categories = categoryGenerator.getCategories()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < categories.count else {
            print("foobar add element")
            let catVM = CategoryViewModel()
            // TODO: dummy = userIput(AdminView)
            catVM.pushCatToDatabase(category: Category(name: "dummy2", image: "dummyimg2"))
            return
        }
        
        print("foobar \(indexPath.row)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.row < categories.count else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            if let image = UIImage(named: "Image")?.withHorizontallyFlippedOrientation() {
                cell.displayContent(image: image, title: "+")
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.row]
        
        if let image = UIImage(named: category.image) {
            cell.displayContent(image: image, title: category.title)
        }
        
        return cell
    }
    
    
}
