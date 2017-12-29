//
//  CreateCategoryViewController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 13.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import ImageRow
import Eureka
import UIKit
import Firebase

class CreateCategoryViewController: FormViewController {

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

            +++ Section("Picture")
            <<< ImageRow("picture") { row in
                row.title = "Foto"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
        }
        
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        let valuesDictionary = form.values()
        
        // check that image and titel are there
        guard let image = valuesDictionary["picture"]!, let titel = valuesDictionary["titel"]! else {
            return
        }
        
        // cast image and titel
        let image_ui = image as! UIImage
        let titel_str = titel as! String
        
        upload_img_to_storage(image_ui, titel_str)
    }
    
    
    func upload_img_to_storage(_ image: UIImage,_ titel: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        
        // Image to Data
        var data = Data()
        data = UIImageJPEGRepresentation(image, 0.5)!
         
        // set MetaData
        metadata.contentType = "image/jpeg"
        
        // display spinner
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        // Start upload of picture to firebase storage
        let picRef = storageRef.child("theme-images/categories/" + titel + ".jpg")
        let _ = picRef.putData(data, metadata: metadata) { (metadata, error) in
            
            // Remove spinner, because uploads finished
            UIViewController.removeSpinner(spinner: sv)
            guard let metadata = metadata else {
                print("Error")
                return
            }
            let downloadURL = metadata.downloadURL()!.absoluteString
            self.push_disc_database(downloadURL, titel)
        }
    }
    
    // push to Database
    func push_disc_database(_ downloadUrl: String,_ titel: String) {
       
        // Save Discussion Theme to firebase
        let eventRefChild = Constants.refs.databaseCategories.child(titel)
        eventRefChild.setValue(["img-url": downloadUrl])
        
        // Dismiss View
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
