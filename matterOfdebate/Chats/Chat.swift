//
//  Chat.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 07.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class Chat {
    var title:String
    var lastMessage: String
    var users : [String]
    
    init(title: String, lastMessage: String, users: [String]) {
        self.title = title
        self.lastMessage = lastMessage
        self.users = users
    }
    
}
