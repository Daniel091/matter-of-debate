//
//  CategoryCollectionViewCell.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 24.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cellTheme_1 : UIImageView!
    @IBOutlet var theme_1_label : UILabel!
    
    func displayContent(image: UIImage, title: String) {
        cellTheme_1.image = image
        theme_1_label.text = title
    }
}
