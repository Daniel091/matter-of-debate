//
//  CreateDiscThemeViewController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 23.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Eureka
import UIKit
import Firebase

// FormViewController is a subclass of UIViewController provided by Eureka
class CreateDiscThemeViewController: FormViewController{
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Up Eureka GUI
        form +++ Section("Generelles")
            <<< TextRow("titel"){ row in
                row.title = "Titel"
                row.placeholder = "Eingabe Titel"
                
                // adding validation
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.cellUpdate { (cell, row) in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            <<< MultipleSelectorRow<String>("categories"){
                $0.title = "Kategorien"
                $0.options = ["One","Two","Three"]
            }
            
            +++ Section("Details")
            <<< TextAreaRow("description") { row in
                row.title = "Beschreibung"
                row.placeholder = "Eingabe Beschreibungstext"
            }
    }
    
    // User clicks Save
    @IBAction func saveDiscTheme(_ sender: UIBarButtonItem) {
        let valuesDictionary = form.values()
        
        if (!checkIfDicisValid(dict: valuesDictionary)) {
            // Post alert
            notifyUser("Formular Fehler", message: "Bitte Titel, mindestens eine Kategorie und Beschreibungstext angeben")
            return
        }
        
        // unzip dic vals, and convert things
        let titel = valuesDictionary["titel"]!
        let desc = valuesDictionary["description"]!
        let cats = valuesDictionary["categories"] as! NSSet
        let cats_array = Array(cats)
        
        // Save Discussion Theme to firebase
        self.ref = Database.database().reference()
        let eventRefChild = self.ref.child("themes").childByAutoId()
        eventRefChild.setValue(["titel": titel,"description": desc, "categories": cats_array])
        
    }
    
    // simple check if Values in Dictionary are not nil or empty Strings
    func checkIfDicisValid(dict : Dictionary<String, Any?>) -> Bool {
        for(_, val) in dict {
            if(val == nil || String(describing: val) == "") {
                return false
            }
        }
        return true
    }
    
    // Notifies User
    func notifyUser(_ title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
