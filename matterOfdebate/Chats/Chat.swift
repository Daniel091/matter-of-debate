//
//  Chat.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 07.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class Chat {
    let title:String
    let lastMessage: String
    let users : Dictionary<String, Bool>
    let id: String
    let timestamp: Double
    
    init(_ id: String,_ title: String,_ lastMessage: String,_ users: Dictionary<String, Bool>,_ timestamp: Double ) {
        self.title = title
        self.lastMessage = lastMessage
        self.users = users
        self.id = id
        self.timestamp = timestamp
    }
    
}
