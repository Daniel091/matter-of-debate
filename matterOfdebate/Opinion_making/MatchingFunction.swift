//
//  MatchingFunction.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 17.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
import AwaitKit

// TODO: for publishing push this to server backend 
class MatchingFunction {
    
    var ref = Database.database().reference()
    
    // searches for matches
    func searchForMatching(topicID: String, currUserID: String, opinionGroup: Int) {
        
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
//                            let userHasAChat = self.userHasChat(userID: user.key,topicID: topicID)
//                            if(userHasAChat) {
//                                print("there is a chat already")
//                                continue
//                            }
                            
                            self.createChat(topicID: topicID, currUserID: currUserID, matchedUserID: user.key)
                            print("user konnte gematched werden :D")
                            return
    
                            //TODO: wie teilen wir dem User mit, dass er gematched wurde?
                        }
                    }
                }
            }
            //TODO: handle no result
            print("no result")
        })
    }
    
    // checks if user has chat already for this Topic
    // TODO: implement futures oder so
    func userHasChat(userID: String, topicID: String) -> Bool {
            
        var (promiseResult, fulfill, _) = Promise<Bool>.pending()

        DispatchQueue.global(qos: .background).async {
            self.ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
                let postDict = snapshot.value
                let chatsFirebase = postDict as? Dictionary<String, Dictionary<String, AnyObject>> ?? [String : [String : AnyObject]]()
                
                for chat in chatsFirebase {
                    //TODO: ändern falls Daniel auf die Idee kommt den Namen auf firebase zu ändern :D
                    if(chat.value["title"] as! String != topicID) {
                        continue
                    }
                    let valuesToWant = chat.value
                    if let users = valuesToWant["users"] as? Dictionary<String,Bool> {
                        for user in users {
                            
                            if(user.key == userID) {
                                fulfill(true)
                            }
                        }
                    }
                }
                fulfill(false)
            })
        }
        
        do {return try await (promiseResult)} catch {return false}
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
