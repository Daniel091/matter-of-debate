//
//  SettingsController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 18.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

 
    @IBAction func logoutUser(_ sender: UIButton) {
        print(":-) trying to logout")
        do {
            try
                Auth.auth().signOut()
                self.performSegue(withIdentifier: "loggedOutUser", sender: self)
                print(":-) logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
