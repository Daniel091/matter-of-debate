//
//  MatchingFunction.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 17.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Firebase

class MatchingFunction {
    
    var ref = Database.database().reference()
    
    // searches for matches
    func searchForMatching(topicID: String, currUserID: String, opinionGroup: Int) -> Bool {
        // TODO: outsource logic to Firebase functions .. return just true or false
        
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value
            let usersFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
            
            for user in usersFirebase {
                if(user.key == currUserID) {
                    continue
                }
                let valuesToWant = user.value
                if let opinions = valuesToWant["opinions"] as? Dictionary<String,Int> {
                    for opinion in opinions {
                        
                        if(topicID != opinion.key) {
                            continue
                        }
                        if(-opinionGroup == opinion.value){
//                            if() {
//                                continue
//                            }
                            self.createChat(topicID: topicID, currUserID: currUserID, matchedUserID: user.key)
                            print("eas passiert was :)")
                            return
    
                            //TODO: wie teilen wir dem User mit, dass er gemached wurde?
                        }
                    }
                }
            }
            //TODO: handle no result
            print("no result")
        })
    
        return true
    }
    
    // checks if user has chat already for this Topic
    func userHasChat(userID: String, topicID: String) -> Bool {
        
    }
    
    // creates new Chat
    func createChat(topicID: String, currUserID: String, matchedUserID: String) {
        
        let databseReference = ref.child("chats").childByAutoId()
        databseReference.child("last Maessage").setValue("")
        databseReference.child("timestamp").setValue(NSDate().timeIntervalSince1970)
        databseReference.child("title").setValue(topicID)
        databseReference.child("users").child(currUserID).setValue(true)
        databseReference.child("users").child(matchedUserID).setValue(true)
    }
}
