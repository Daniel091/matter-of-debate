//
//  TabBarMainController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 19.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit

class TabBarMainController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation Controller in Case user, came from EmailRegistrationController
        self.navigationController?.navigationBar.isHidden = true
    }


}
