//
//  MatchingFunction.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 17.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Firebase

// LATE TODO: for publishing push this to server backend
class MatchingFunction {
    
    var ref = Database.database().reference()
    
    // searches for matches
    func searchForMatching(topicID: String, currUserID: String, opinionGroup: Int) {
        
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value
            let usersFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
            
            let dispatchGroup = DispatchGroup()
            var topicIDData: String?
            var matchedUserData: String?
            
            for user in usersFirebase {
                if(user.key == currUserID) {
                    continue
                }
                let userData = user.value
                if let opinions = userData["opinions"] as? Dictionary<String,Int> {
                    for opinion in opinions {
                        
                        if(topicID != opinion.key) {
                            continue
                        }
                        if(-opinionGroup == opinion.value){
                            
                            dispatchGroup.enter()
                            self.userHasChat(userID: user.key, topicID: topicID) { result in
                                guard(!result) else {
                                    print("user hat schon einen chat")
                                    dispatchGroup.leave()
                                    return
                                }
                                topicIDData = topicID
                                matchedUserData = user.key
                                dispatchGroup.leave()
                                
                                
                            }
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                if let topicIDData = topicIDData, let matchedUserData = matchedUserData {
                    
                    self.createChat(topicID: topicIDData, currUserID: currUserID, matchedUserID: matchedUserData)
                    print("es wird ein chat erstellt :D")
                }
            }
        })
    }
    
    // checks if user has chat already for this Topic
    func userHasChat(userID: String, topicID: String, completion: @escaping (Bool) -> Void)
    {
        DispatchQueue.global(qos: .background).async {
            self.ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
                let postDict = snapshot.value
                let chatsFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
                
                for chat in chatsFirebase {
                    if(chat.value["title"] as! String != topicID) {
                        continue
                    }
                    let chatData = chat.value
                    if let chattingUsers = chatData["users"] as? Dictionary<String,Bool> {
                        for user in chattingUsers {
                            
                            if(user.key == userID) {
                                completion(true)
                                return
                            }
                        }
                    }
                }
                completion(false)
                
            })
        }
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
