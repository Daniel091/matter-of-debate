//
//  detailThemeCell.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 23.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit

class detailThemeCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
