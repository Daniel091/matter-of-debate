//
//  ChatsOfTopicTableVC.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 24.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Firebase

class ChatsOfTopicTableVC: UITableViewController {
    var topic : Topic?
    private var chatsUpdateHandleAdd: DatabaseHandle?
    private var chatsRef : DatabaseReference?
    private var chats : [Chat] = []
    private var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // empty chats
        chats = []
        
        // unwrap category object
        guard let topic_obj = self.topic else {
            return
        }
        print("Now displaying chats of " + topic_obj.title)
        
        // set title of table view controller
        self.title = topic_obj.title
        
        // set handlers
        getChatsOfTopic(topic_obj.id)
    }
    
    func getChatsOfTopic(_ theme_id: String) {
        chatsRef = Constants.refs.databaseChats
        chatsUpdateHandleAdd = chatsRef!.queryOrdered(byChild: "title").queryEqual(toValue: theme_id)
            .observe(.childAdded, with: { (snapshot) -> Void in
                
                let chatsData = snapshot.value as! Dictionary<String, AnyObject>
                
                let lastMessage = chatsData["lastMessage"] as? String ?? ""
                //let theme_id = chatsData["title"] as? String ?? ""
                let timestamp = chatsData["timestamp"] as? Double ?? 0.0
                let users = chatsData["users"] as? Dictionary<String, Bool> ?? [String: Bool]()
                
                if lastMessage != "" && users.count == 2{
                    self.chats.append(Chat(snapshot.key, theme_id, lastMessage, users, timestamp, ""))
                    self.chats.sort(by: Chat.sortChatsbyTimestamp)
                    self.tableView.reloadData()
                }
            })
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if chats.count>0 {
            TableViewHelper.EmptyMessage(message: "", viewController: self)
            return 1
        } else {
            TableViewHelper.EmptyMessage(message: "Keine Chats zu diesem Thema vorhanden.", viewController: self)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    // define whats in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "chatCell2"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatsOfTopicCell else {
            fatalError("The dequeued cell is not an instance of ChatsOfTopicCell.")
        }
        
        let chat = chats[indexPath.row]
        
        // set cell content
        let date = Date(timeIntervalSince1970: chat.timestamp)
        cell.titleLabel.text = self.dateFormatter.string(from: date)
        cell.lastMsgLabel.text = chat.lastMessage
        
        return cell
    }

    // click on chat row should show all chats of that theme
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        self.performSegue(withIdentifier: "showMessages2", sender: chat)
    }
    
    // give topic to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let messagesView = segue.destination as! MessagesView
            messagesView.chat = chat
        }
        
    }
    
}
