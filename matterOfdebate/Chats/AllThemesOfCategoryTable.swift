//
//  AllThemesOfCategoryTable.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 20.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit

class AllThemesOfCategoryTable: UITableViewController {

    var category : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(category?.title)
        
        // get all themes of category
        // TODO
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }


}
