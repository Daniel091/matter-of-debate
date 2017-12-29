//
//  MatchingFunction.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 17.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Firebase

// TODO: for publishing push this to server backend 
class MatchingFunction {
    
    var ref = Database.database().reference()
    
    // searches for matches
    func searchForMatching(topicID: String, currUserID: String, opinionGroup: Int) {
        
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value
            let usersFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
            
            let dispatchGroup = DispatchGroup()
            var chatInfo: (String, String)?
            
            for user in usersFirebase {
                if(user.key == currUserID) {
                    continue
                }
                print("test")
                let userData = user.value
                if let opinions = userData["opinions"] as? Dictionary<String,Int> {
                    for opinion in opinions {
                        
                        if(topicID != opinion.key) {
                            continue
                        }
                        print("found topic with opinionGroup: \(opinionGroup) opinionValue: \(opinion.value)")
                        if(-opinionGroup == opinion.value){
                            print("opinionmatch")
                            
                            dispatchGroup.enter()
                            self.userHasChat(userID: user.key, topicID: topicID) { result in
                                guard(!result) else {
                                    print("user hat schon einen chat")
                                    dispatchGroup.leave()
                                    return
                                }
                                chatInfo = (topicID, user.key)
                                dispatchGroup.leave()
                                
                                
                            }
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                if let chatInfo = chatInfo {
                    
                    self.createChat(topicID: chatInfo.0, currUserID: currUserID, matchedUserID: chatInfo.1)
                    print("es wird ein chat erstellt :D")
                }
            }
            //TODO: handle no result
            print("no result")
        })
    }
    
    // checks if user has chat already for this Topic
    // TODO: implement futures oder so
    func userHasChat(userID: String, topicID: String, completion: @escaping (Bool) -> Void)
    {
        DispatchQueue.global(qos: .background).async {
            self.ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
                let postDict = snapshot.value
                let chatsFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
                
                for chat in chatsFirebase {
                    //TODO: ändern falls Daniel auf die Idee kommt den Namen auf firebase zu ändern :D
                    if(chat.value["title"] as! String != topicID) {
                        continue
                    }
                    print("hrrrg found topic \(topicID)")
                    let chatData = chat.value
                    if let chattingUsers = chatData["users"] as? Dictionary<String,Bool> {
                        print("hrrrg found chatting users: \(chattingUsers.count)")
                        for user in chattingUsers {
                            
                            if(user.key == userID) {
                                print("hrrrg found match, userID: \(userID)")
                                completion(true)
                                return
                            }
                        }
                    }
                }
                print("hrrrg no match")
                completion(false)
                
            })
        }
        
        //do {return try await (promiseResult)} catch {return false}
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
