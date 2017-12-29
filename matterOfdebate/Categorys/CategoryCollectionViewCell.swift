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
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var themeLabel : UILabel!
    
    func displayContent(image: UIImage, title: String) {
        imageView.image = image
        themeLabel.text = title
    }
}
