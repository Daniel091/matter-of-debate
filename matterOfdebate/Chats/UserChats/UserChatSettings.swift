//
//  UserChatSettings.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 25.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class UserChatSettings: FormViewController {
    var chat:Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Logout button
        form +++ Section("Einstellungen")
            <<< ButtonRow("deleteChat"){
                $0.title = "Chat beenden"
                }.onCellSelection({ (cell, row) in
                    self.endChat()
                })
    }

    func endChat() {
        guard let chat_obj = chat else {
            return
        }
        
        // sign user out of chat but keep the chat data
        var dataRef = Constants.refs.databaseChats.child(chat_obj.id)
            .child("users")
            .child(SingletonUser.sharedInstance.user.uid)
        dataRef.setValue(false)
        
        // make a message to other chat partner
        let user_name = SingletonUser.sharedInstance.user.user_name
        let msg = user_name + " hat den Chat verlassen"
        let dict = ["name": user_name, "sender-id": "ChatBot", "text": msg]

        dataRef = Constants.refs.databaseMessages.child(chat_obj.id).childByAutoId()
        dataRef.setValue(dict)
        
        if let navController = self.navigationController {
            navController.popToRootViewController(animated: true)
        }
    }
}
