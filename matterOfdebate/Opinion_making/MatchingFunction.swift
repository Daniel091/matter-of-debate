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
    
    func searchForMatching(topicID: String, currUserID: String, opinionGroup: Int) -> Bool {
        // TODO: outsource logic to Firebase functions .. return just true or false
        
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value
            let usersFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
            
            for user in usersFirebase {
                let valuesToWant = user.value
                if let opinions = valuesToWant["opinions"] as? Dictionary<String,Int> {
                    for opinion in opinions {
                        
                        if(-opinionGroup == opinion.value){
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
    
    func createChat(topicID: String, currUserID: String, matchedUserID: String) {
        //TODO: no dublicates !!
    }
}
