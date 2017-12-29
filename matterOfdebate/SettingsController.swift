//
//  SettingsController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 18.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Firebase
import Eureka

class SettingsController: FormViewController {
    
    let user_obj = SingletonUser.sharedInstance.user

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if user is not Anonymus show change user data options
        if !user_obj.isAnonymous {
            form +++ Section("Benutzer Informationen")
                <<< TextRow("username"){ row in
                    row.title = "Username"
                    row.value = self.user_obj.user_name
                }
                <<< TextRow("email"){
                    $0.title = "Email"
                    $0.value = self.user_obj.email
                }
                <<< ButtonRow("save"){
                    $0.title = "Save"
                    }.onCellSelection({ (cell, row) in
                        self.saveUsrData()
                    })
        }
        
        // Logout button
        form +++ Section("Weitere Einstellungen")
            <<< ButtonRow("logout"){
                $0.title = "Logout"
                }.onCellSelection({ (cell, row) in
                    self.logoutUser()
                })
        // if user is Admin show create theme section
        if user_obj.isAdmin && !user_obj.isAnonymous{
            form +++ Section("Admin-Panel")
                <<< ButtonRow("create Theme"){
                    $0.title = "Create new Theme"
                    }.onCellSelection({ (cell, row) in
                        self.triggerCreateTheme()
                    })
        }
        
    }
    
    // Checks in Firebase for douplicates and then updates the user data
    func saveUsrData() {
        print("Trying to save usr data")
        let valuesDictionary = form.values()

        guard let email = valuesDictionary["email"]!, let usr_name = valuesDictionary["username"]! else {
            return
        }
        
        // test if new username is already taken
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users")
        ref.queryOrdered(byChild: "username").queryEqual(toValue: usr_name as! String).observeSingleEvent(of: .value) { (userSnapshot) in

            if userSnapshot.childrenCount != 0 {
                print("Username already exists")
                
                // TODO: benachrichtige den user.
                let usernameAlert = UIAlertController(title: "", message: "Username already exists", preferredStyle: .alert)
                usernameAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The duplicate username alert occured.")
                }))
                self.present(usernameAlert, animated: true, completion: nil)
                
            } else {

                // update Username
                let ref_usr = Constants.refs.databaseUsers.child(self.user_obj.uid)
                let childUpdates = ["username": usr_name] as [String : Any]

                ref_usr.updateChildValues(childUpdates)
                print("username changed")
            }
        }
        
        // test if email already exists
        ref.queryOrdered(byChild: "email").queryEqual(toValue: email as! String).observeSingleEvent(of: .value) { (userSnapshot) in
            
            if userSnapshot.childrenCount != 0 {
                print("email already exists")
                
                // TODO: benachrichtige den user.
                let emailAlert = UIAlertController(title: "", message: "email already exists", preferredStyle: .alert)
                emailAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The duplicate email alert occured.")
                }))
                self.present(emailAlert, animated: true, completion: nil)
                
                
            } else {
                
                // update email
                let ref_email = Constants.refs.databaseUsers.child(self.user_obj.uid)
                let childUpdates = ["email": email] as [String : Any]
                
                // TODO: Update singleton
                
                ref_email.updateChildValues(childUpdates)
                print("email changed")
            }
        }
    }
    
    // logs out the current user
    func logoutUser() {
        print(":-) trying to logout")
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: false)
            self.performSegue(withIdentifier: "loggedOutUser", sender: self)
            
            //SingletonUser.sharedInstance.user = User(uid: "", email: "", user_name: "")
            // TODO: clean Navigation Stack
            print(":-) logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func triggerCreateTheme() {
        self.performSegue(withIdentifier: "adminThemeControlSeque", sender: self)
    }

}
