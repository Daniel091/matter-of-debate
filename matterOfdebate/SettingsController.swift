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
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "loggedOutUser", sender: self)
            SingletonUser.sharedInstance.user = User(uid: "", email: "", user_name: "")
            // TODO: clean Navigation Stack
            print(":-) logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func triggeredAdminCreateTheme(_ sender: UIButton) {
        self.performSegue(withIdentifier: "adminThemeControlSeque", sender: self)
    }

}
