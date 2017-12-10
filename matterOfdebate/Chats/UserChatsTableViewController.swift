//
//  UserChatsTableViewController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 06.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Firebase
class UserChatsTableViewController: UITableViewController {

    private let dateFormatter = DateFormatter()
    private var chats: [Chat] = []
    
    private lazy var chatsRef = Constants.refs.databaseChats
    private var chatsRefHandle: DatabaseHandle?
    private var chatsRefUpdateHandle: DatabaseHandle?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup dateFormatter
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        observeChats()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // removes observers
        chatsRef.removeAllObservers()
        
        // empty chats
        chats = []
    }
    
    private func observeChats() {
        // gets user
        let user_obj = SingletonUser.sharedInstance.user
        
        // Childs are added
        chatsRefHandle = chatsRef
            .queryOrdered(byChild: "users/" + user_obj.uid)
            .queryEqual(toValue: true)
            .observe(.childAdded, with: { (snapshot) -> Void in
                
            let chatsData = snapshot.value as! Dictionary<String, AnyObject>
            
            // if title is set construct new Chat Object
            if let title = chatsData["title"] as! String! {
                let last_m = chatsData["lastMessage"] as? String ?? ""
                let users = chatsData["users"] as! Dictionary<String, Bool>
                let timestamp = chatsData["timestamp"] as? Double ?? 0
                
                self.chats.append(Chat(snapshot.key,title, last_m, users, timestamp))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode chats data in child added")
            }
        })
        
        // Childs are changed
        chatsRefUpdateHandle = chatsRef
                .queryOrdered(byChild: "users/" + user_obj.uid)
                .queryEqual(toValue: true)
                .observe(.childChanged, with: { (snapshot) -> Void in
                    
            let chatsData = snapshot.value as! Dictionary<String, AnyObject>
            
            // if title is set construct new Chat Object
            if let title = chatsData["title"] as! String! {
                let last_m = chatsData["lastMessage"] as? String ?? ""
                let timestamp = chatsData["timestamp"] as? Double ?? 0
                
                // update specific objects in chats
                let found_chat = self.chats.first(where: { $0.title == title })
                found_chat?.timestamp = timestamp
                found_chat?.lastMessage = last_m
                
                //self.chats.append(Chat(snapshot.key,title, last_m, users, timestamp))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode chats data in child changed")
            }
        })
    }
    
    // click on chat row should show chat view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        print(":-) clicked " + chat.id)
        self.performSegue(withIdentifier: "showMessages", sender: chat)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController
            chatVc.chat = chat
        }
        
    }

    // define whats in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChatCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ChatTableViewCell.")
        }
        
        let chat = chats[indexPath.row]
        
        // set cell content
        cell.titelLabel.text = chat.title
        let date = Date(timeIntervalSince1970: chat.timestamp)
        cell.subtitelLabel.text = chat.lastMessage
        cell.timeLabel.text = dateFormatter.string(from: date)
        
        return cell
    }
    
    // only one big section for all chats
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows is equal to length of chats array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
}
