//
//  CategoriesController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 24.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit

class CategoriesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var categories = [Category]()
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryGenerator = CategoryGeneratorMock()
        categories = categoryGenerator.generateCategories()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.row]
        cell.displayContent(image: UIImage(named: category.categoryImage)!, title: category.categoryName)
        
        return cell
    }
    
    
}
