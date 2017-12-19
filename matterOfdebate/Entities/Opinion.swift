//
//  Opinion.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 12.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

struct Opinion {
    let topic: Topic
    let user: User
    var opinionGroup: Int
    
    init(topic: Topic, user: User, opinionGroup: Int) {
        self.user = user
        self.opinionGroup = opinionGroup
        self.topic = topic
    }
}
