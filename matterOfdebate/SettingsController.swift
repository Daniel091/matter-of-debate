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
        if let navBar = self.navigationController?.navigationBar {
            navBar.topItem?.title = "Settings"
        }
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
        
        form +++ Section("Weitere Einstellungen")
            // Logout button
            <<< ButtonRow("logout"){
                $0.title = "Logout"
                }.onCellSelection({ (cell, row) in
                    self.logoutUser()
                })
            // Delete account button
            <<< ButtonRow("deleteAccount"){
                $0.title = "Delete Account"
                $0.hidden = Condition(booleanLiteral: user_obj.isAnonymous)
                }.onCellSelection({ (cell, row) in
                    self.securityPopup()
                })
        
        // if user is Admin show create theme section
        if user_obj.isAdmin && !user_obj.isAnonymous{
            form +++ Section("Admin-Panel")
                <<< ButtonRow("create Theme"){
                    $0.title = "Create new Theme"
                    }.onCellSelection({ (cell, row) in
                        self.triggerCreateTheme()
                    })
                <<< ButtonRow("proposals"){
                    $0.title = "View Proposals"
                    }.onCellSelection({ (cell, row) in
                        self.toProposals()
                    })
        }
        
        //if user is neither admin nor anonymous, he can propose topics
        if !user_obj.isAdmin && !user_obj.isAnonymous {
            form +++ Section("Thema vorschlagen")
                <<< TextRow("t_titel"){ row in
                    row.title = "Thema Titel"
                }
                <<< TextRow("t_description"){
                    $0.title = "Beschreibung"
                }
                <<< ButtonRow("propose Theme"){
                    $0.title = "Propose a Theme"
                    }.onCellSelection({ (cell, row) in
                        self.proposeTopic()
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
    
    // shows a security popup window to make sure the user wants to delete his account
    func securityPopup() {
        let deleteUserAlert = UIAlertController(title: "", message: "Do you want to delete your Account?", preferredStyle: .alert)
        // delete user action
        deleteUserAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .`default`, handler: { _ in
            self.deleteAccount()
        }))
        // not deleting the user action
        deleteUserAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .`default`, handler: { _ in
            print("Delete account cancelled")
        }))
        self.present(deleteUserAlert, animated: true, completion: nil)
    }
    
    // deletes the current user`s account
    func deleteAccount() {
        let user = Auth.auth().currentUser
        Constants.refs.databaseUsers.child(SingletonUser.sharedInstance.user.uid).removeValue()
        user?.delete { error in
            if let error = error {
                print("An error occurred: \(error)")
            } else {
                print("Account deleted")
                self.logoutUser()
            }
        }
    }
    
    func triggerCreateTheme() {
        self.performSegue(withIdentifier: "adminThemeControlSeque", sender: self)
    }
    
    func proposeTopic() {
        let valuesDictionary = form.values()
        guard let ttitle = valuesDictionary["t_titel"]!, let tdescr = valuesDictionary["t_description"]! else {
            return
        }
        // cast to string
        let proposedTitle = ttitle as! String
        let proposedDescr = tdescr as! String
        
        // is theme already proposed
        
       
        // creating new path for a proposal
        let refProposal = Constants.refs.databaseProposals.childByAutoId()
        // values for storing
        let propValues = ["title": proposedTitle, "description": proposedDescr]
        // adding the values to the proposal
        refProposal.updateChildValues(propValues)
        
        // alert the user
        let alertController = UIAlertController.init(title: "Neues Thema vorgeschlagen", message: "Dein Vorschlag wird in Betracht gezogen", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(alertAction)
        alertAction.isEnabled = true
        self.present(alertController, animated: true, completion: nil)
        
        // reset Eureka form
        self.form.setValues(["t_titel": "", "t_description": ""])
        self.form.rowBy(tag: "t_titel")?.reload()
        self.form.rowBy(tag: "t_description")?.reload()
        
    }
    
    func toProposals() {
        performSegue(withIdentifier: "toProposedThemes", sender: self)
    }
}
