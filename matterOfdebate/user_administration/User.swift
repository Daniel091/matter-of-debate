//
//  User.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 16.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    let uid: String
    let email: String
    
    
    // Inits a User with Data from Firebase
    init(userData: FirebaseAuth.User) {
        uid = userData.uid
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
    
}
