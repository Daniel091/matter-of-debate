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
    var lastMessage: String
    let users : Dictionary<String, Bool>
    let id: String
    let img_url: String
    var timestamp: Double
    var topic: Topic
    
    init(_ id: String,_ title: String,_ lastMessage: String,
         _ users: Dictionary<String, Bool>,
         _ timestamp: Double,
         _ img_url: String,
         _ topic: Topic = Topic(name: "", description: "", categories: [], imageUrl: "", id: "")) {
        
        self.title = title
        self.lastMessage = lastMessage
        self.users = users
        self.id = id
        self.timestamp = timestamp
        self.img_url = img_url
        self.topic = topic
    }
 
    class func sortChatsbyTimestamp(this:Chat, that:Chat) -> Bool {
        return this.timestamp > that.timestamp
    }
}
