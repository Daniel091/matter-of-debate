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
        static let reportedUsers = databaseRoot.child("reportedUsers")
        
        static let storageRoot = Storage.storage().reference()
        static let storageThemesImgs = storageRoot.child("theme-images")
    }
    
    // matching user -- neutral (0) is in pro List!!
    public static let opinionGroupNumber = 5;
    public static let opinionMaximum = 50;
    public static let opinionGroupDistance = opinionMaximum/opinionGroupNumber;
    
    // chat configurations
    public static let maxNumberOfCharacters = 250
    public static let maxNumberCopyPaste = 1
    public static let maxNumberOfChatmessages = 3
    
    // controll debug mode
    public static let isInDebugMode = true;
}
