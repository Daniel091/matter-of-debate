//
//  EmailRegistrationController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 18.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Firebase

class EmailRegistrationController: UIViewController {

    @IBOutlet weak var usr_field: UITextField!
    @IBOutlet weak var pw_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

 
    @IBAction func createUser(_ sender: UIButton) {
        guard let email = email_field.text, !email.isEmpty, let pw = pw_field.text, !pw.isEmpty,
            let usr_name = usr_field.text,!usr_name.isEmpty else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pw) { (user, error) in
            if error == nil {
                print(":-) Successfully created a user")
                self.performSegue(withIdentifier: "signedInSequeAfterRegistered", sender: self)
            } else {
                print(error.debugDescription)
            }
        }
        
    }

}
