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

        
        static let curruserReference = Auth.auth().currentUser
        static let databaseUsers = databaseRoot.child("users")
        
    }
    
    // neutral (0) is in pro List!!
    public static var opinionPro = [4: [50, 49, 48],
                                    3: [40, 39, 38],
                                    2: [30, 29, 28],
                                    1: [20, 19, 18],
                                    0: [10, 9, 8, 0]] as [Int : Any]
    
    public static var opinionContra = [4: [-50, -49, -48],
                                       3: [-40, -39, -38],
                                       2: [-30, -29, -28],
                                       1: [-20, -19, -18],
                                       0: [-10, -9, -8]] as [Int : Any]
    
}
