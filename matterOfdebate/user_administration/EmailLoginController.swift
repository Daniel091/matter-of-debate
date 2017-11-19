//
//  ViewController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 14.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Firebase


// TODO compare with this:
// https://github.com/firebase/quickstart-ios/blob/master/authentication/AuthenticationExampleSwift/EmailViewController.swift
class EmailLoginController: UIViewController {

    @IBOutlet weak var feedback_label: UILabel!
    @IBOutlet weak var email_login_field: UITextField!
    @IBOutlet weak var pw_login_field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let fuser = user {
                print("Already logged in \(String(describing: fuser.email))")
                
                self.performSegue(withIdentifier: "loginSuccessful", sender: self)
                
            } else {
                print("Not signed in")
            }
        }
    }
    
    
    // Triggered by Login Button
    @IBAction func loginEmail(_ sender: UIButton) {

        // give feedback to user and return if email or pw fields are not set or ""
        guard let email = email_login_field.text, !email.isEmpty, let pw = pw_login_field.text, !pw.isEmpty else {
            user_SignIn_error_feedback()
            return
        }
        
        // Do the Sign, show spinner, react to error
        let sv = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signIn(withEmail: email, password: pw, completion: ({ (user, error) in
            
            // remove spinner
            UIViewController.removeSpinner(spinner: sv)
            if let userMail = user?.email {
                print(":-) " + userMail)
                self.performSegue(withIdentifier: "loginSuccessful", sender: self)
                
            } else {
                self.user_SignIn_error_feedback()
                if let error_desc = error?.localizedDescription {
                    self.feedback_label.text = error_desc
                }
                
                print(error.debugDescription)
            }
            
        }))
    }
    
    // make email and password field red
    func user_SignIn_error_feedback() {
        let redColor = UIColor.red
        
        email_login_field.layer.borderColor = redColor.cgColor
        pw_login_field.layer.borderColor = redColor.cgColor
        
        email_login_field.layer.borderWidth = 1.0
        pw_login_field.layer.borderWidth = 1.0
    }

}

