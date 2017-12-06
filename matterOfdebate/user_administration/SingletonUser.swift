//
//  SingletonUser.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 06.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class SingletonUser {
    static let sharedInstance = SingletonUser()
    var user : User = User(uid: "", email: "", user_name: "")
}
