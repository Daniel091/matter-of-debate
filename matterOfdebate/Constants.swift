//
//  Constants.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 29.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Firebase

// hard coded paths for firebase data here get a reference e.g: Constants.refs.databaseChats
struct Constants {
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
        static let databaseMessages = databaseRoot.child("messages")
        static let databaseCategories = databaseRoot.child("categories")
        static let databaseThemes = databaseRoot.child("themes")
        
        static let curruserReference = Auth.auth().currentUser
        static let databaseUsers = databaseRoot.child("users")
    }
    
    // neutral (0) is in pro List!!
    public static let opinionGroupNumber = 5;
    public static let opinionMaximum = 50;
    public static let opinionGroupDistance = opinionMaximum/opinionGroupNumber;
}
