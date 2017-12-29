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
    
    // Spinner
    var sv : UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let fuser = user {
                print("logged in \(String(describing: fuser.uid)) \(String(describing: fuser.email))")
                
                let isAnonymous = fuser.isAnonymous
                self.get_user(fuser.uid, isAnonymous)
            } else {
                print("Not signed in")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // Triggered by Sign In Anonymously Button
    @IBAction func signInAnonymous(_ sender: UIButton) {
        // show spinner
        self.sv = UIViewController.displaySpinner(onView: self.view)
        
        // do sign in
        Auth.auth().signInAnonymously(){ (user,error) in
            if let uid = user?.uid {
                let isAnonymous = user!.isAnonymous
                print(uid + " " + String(describing: isAnonymous))
                
            } else {
                if let error_desc = error?.localizedDescription {
                    self.feedback_label.text = error_desc
                }
                print(error.debugDescription)
            }
            UIViewController.removeSpinner(spinner: self.sv)
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
        self.sv = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signIn(withEmail: email, password: pw, completion: ({ (user, error) in
            
            if let userMail = user?.email{
                // AuthStateChange is being triggered automatically here
                print(":-) " + userMail)
                
            } else {
                UIViewController.removeSpinner(spinner: self.sv)
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
    
    // gets user to singleton instance
    func get_user(_ usr_uid: String,_ isAnonymous: Bool) {
        
        // TODO do we really need this? if SingletonUser is already there
//        if SingletonUser.sharedInstance.user.uid == usr_uid {
//            self.performSegue(withIdentifier: "loginSuccessful", sender: self)
//        }
        
        isAnonymous ? constructAnonymousUser(usr_uid) : fetchUsrDatafromDatabase(usr_uid)
    }
    
    // fetches user data from database, performs Seque
    func fetchUsrDatafromDatabase(_ usr_uid: String) {
        Constants.refs.databaseUsers.child(usr_uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // remove spinner
            UIViewController.removeSpinner(spinner: self.sv)
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let isAdmin = value?["isAdmin"] as? Bool ?? false
            
            SingletonUser.sharedInstance.user = User(uid: usr_uid, email: email, user_name: username, isAdmin: isAdmin)
            
            print(":-) Currently signed in User " + email)
            self.performSegue(withIdentifier: "loginSuccessful", sender: self)
        }) { (error) in
            UIViewController.removeSpinner(spinner: self.sv)
            print("Could not fetch user data from database")
            print(error.localizedDescription)
        }
    }
    
    // puts anonymous user obj in singleton, performs Seque
    func constructAnonymousUser(_ usr_uid: String) {
        SingletonUser.sharedInstance.user = User(uid: usr_uid, email: "", user_name: "Anonymous", isAdmin: false, isAnonymous: true)
        self.performSegue(withIdentifier: "loginSuccessful", sender: self)
    }
    
    @IBAction func adminLoginPressed(_ sender: Any) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signIn(withEmail: "s.admin@test.de", password: "passwort", completion: ({ (user, error) in
            
        }))
    }
    @IBAction func userLoginPressed(_ sender: Any) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signIn(withEmail: "s.user@test.de", password: "passwort", completion: ({ (user, error) in
            
        }))
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showRegistration", sender: self)
    }
}

