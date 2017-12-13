//
//  CreateCategoryViewController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 13.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit

class CreateCategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        print("Clicked Save")
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
