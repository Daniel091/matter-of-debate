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
        
        guard var email = valuesDictionary["email"]!, var usr_name = valuesDictionary["username"]! else {
            return
        }
        
        // cast to string
        let email_str = email as! String
        let usr_name_str = usr_name as! String
        
        // when entered username is not the current username, check if its unique.
        if SingletonUser.sharedInstance.user.user_name != usr_name_str {
            
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users")
            ref.queryOrdered(byChild: "username").queryEqual(toValue: usr_name).observeSingleEvent(of: .value, with: { (userSnapshot) in
                if userSnapshot.childrenCount == 0 {
                    
                // Update username
                let ref_usr = Constants.refs.databaseUsers.child(self.user_obj.uid)
                let childUpdates = ["username": usr_name]
                ref_usr.updateChildValues(childUpdates)
                }
            })
        }
        
        // when entered email is not the current email, check if its unique.
        if SingletonUser.sharedInstance.user.email != email_str {
            
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users")
            ref.queryOrdered(byChild: "email").queryEqual(toValue: email_str).observeSingleEvent(of: .value, with: { (userSnapshot) in
                if userSnapshot.childrenCount == 0 {
                    
                // Update email
                let ref_email = Constants.refs.databaseUsers.child(self.user_obj.uid)
                let childUpdates = ["email": email_str]
                
                SingletonUser.sharedInstance.user.email = email_str
                ref_email.updateChildValues(childUpdates)
                }
            })
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
            print(":-) logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func triggerCreateTheme() {
        self.performSegue(withIdentifier: "adminThemeControlSeque", sender: self)
    }
}
