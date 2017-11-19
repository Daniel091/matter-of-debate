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
    @IBOutlet weak var feedback_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createUser(_ sender: UIButton) {
        guard let email = email_field.text, !email.isEmpty, let pw = pw_field.text, !pw.isEmpty,
            let usr_name = usr_field.text,!usr_name.isEmpty else {
            
            self.feedback_label.text = "Passwort/Mail/Nutzername fehlt"
            return
        }
        
        // try to create a user, show a spinner
        let sv = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().createUser(withEmail: email, password: pw) { (user, error) in
            
            // Hide spinner
            UIViewController.removeSpinner(spinner: sv)
            if error == nil {
                print(":-) Successfully created a user")
                self.performSegue(withIdentifier: "signedInSequeAfterRegistered", sender: self)
            } else {
                
                if let error_desc = error?.localizedDescription {
                    self.feedback_label.text = error_desc
                }
                print(error.debugDescription)
            }
        }
        
    }

}
