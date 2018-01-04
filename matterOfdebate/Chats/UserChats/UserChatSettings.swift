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
    let matchingFunction = MatchingFunction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let chat_obj = chat else {
            return
        }
        
        // Information Section
        form +++ Section("Informationen")
            <<< LabelRow("topicTitel"){
                $0.title = "Thema"
                $0.value = chat_obj.topic.title
                $0.disabled = true
            }
            <<< TextAreaRow("topicDescription"){
                $0.title = "Themen Beschreibung"
                $0.value = chat_obj.topic.description
                $0.disabled = true
            }
        
        // Settings Section
        form +++ Section("Einstellungen")
            <<< ButtonRow("deleteChat"){
                $0.title = "Chat beenden"
                }.onCellSelection({ (cell, row) in
                    self.endChat()
                })
            <<< ButtonRow("nextUser"){
                $0.title = "Select next user"
                }.onCellSelection({ (cell, row) in
                    self.nextUser()
                })
            <<< ButtonRow("reportUser"){
                $0.title = "Report user"
                }.onCellSelection({ (cell, row) in
                    self.reportUser()
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
    
    func nextUser() {
        guard let chatObject = chat else {
            return
        }
        
        self.endChat()
        
        // TODO: get real Opinion!!
        matchingFunction.searchForMatching(topicID: chatObject.topic.id, currUserID: SingletonUser.sharedInstance.user.uid, opinionGroup: 3)
    }
    
    func reportUser() {
        guard let chatObject = chat else {
            return
        }
        let title = "Reported user"
        let message = "You reported your chatpartner, the admins will get a notification"
        var chatPartner = ""
        
        for user in chatObject.users.keys {
            if (!(user == SingletonUser.sharedInstance.user.uid)) {
                chatPartner = user
            }
        }
        
        // TODO: einbauen weger was reported wird ?
        // checklist .. - flaming
        //              - some else
        
        showDialog(title: title, message: message)
        sendReportsToDatabase(chatPartner)
        print("reportet user")
    }
    
    func getNumberOfReportsOfUser(userID: String, completion: @escaping (Int) -> Void)  {
        DispatchQueue.global(qos: .background).async {
            Constants.refs.reportedUsers
                .child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                guard snapshot.exists() else {
                    completion(0)
                    return
                }
                        
                let postDict = snapshot.value
                
                let reportedUserDatabase = postDict as? Dictionary<String, AnyObject> ?? [String : AnyObject]()
                
                for key in reportedUserDatabase.keys {
                    if (key == "numberReports") {
                        print(reportedUserDatabase[key]!)
                        completion(reportedUserDatabase[key] as! Int)
                    }
                }
            })
        }
    }
    
    // TODO: fix abfrage nach number of reports
    // TODO: insert real abfrage ob der User im baum schon existiert
    func sendReportsToDatabase(_ reportedUserID: String) {
        let dispatchGroup = DispatchGroup()
        var currentNumberOfReports: Int?
        var numberOfReports = 1
        
        let dataRef = Constants.refs.reportedUsers.child(reportedUserID)
        
        dispatchGroup.enter()
        self.getNumberOfReportsOfUser(userID: reportedUserID) { result in
            currentNumberOfReports = result
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            numberOfReports = currentNumberOfReports!
        
            dataRef.child("numberReports").setValue(numberOfReports+1)
            let reportingUseresRef = dataRef.child("reportingUsers")
            reportingUseresRef.child(SingletonUser.sharedInstance.user.uid).setValue(true)
        }
    }
    
    func showDialog(title: String, message: String) {
        let dialogController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //going back to browse through themes
        let backToTopicView = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        
        //adding the action to dialogbox
        dialogController.addAction(backToTopicView)
        
        self.present(dialogController, animated: true, completion: nil)
    }
}
