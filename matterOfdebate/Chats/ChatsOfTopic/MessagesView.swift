//
//  MessagesView.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 24.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class MessagesView: JSQMessagesViewController {
    // array that stores messages
    var messages = [JSQMessage]()
    
    // MessagesView has a Chat object to display
    var chat: Chat?
    
    // create colored message bubbles, outgoing is blue, incoming gray
    // lazy vars are only initialized once, when there accessed
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide input bar
        self.inputToolbar.removeFromSuperview()
        
        setupSettingsChatButton()
        
        
        guard let chat_obj = chat, let users = chat?.users else {
            return
        }
        
        senderId = users.keys.first
        senderDisplayName = "Not needed here, but has to be set"
        
        // hide attachement button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        // hidding avatar
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Query Messages of chat_id
        let query = Constants.refs.databaseMessages.child(chat_obj.id)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: String] {
                if let name = data["name"], let text = data["text"], let id = data["sender-id"], !text.isEmpty {
                    // build a message from the snapshots data
                    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                        self?.messages.append(message)
                        self?.finishReceivingMessage()
                    }
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupSettingsChatButton() {
        let settingsButton = UIBarButtonItem(title: "Statistiken", style: .plain, target: self, action: #selector(settingsButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func settingsButtonTapped(sender: UIBarButtonItem) {
        if let chat_obj = self.chat {
            self.performSegue(withIdentifier: "showStats", sender: chat_obj)
        }
    }
    
    // give topic to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let statisticsController = segue.destination as! StatisticsController
            statisticsController.chat = chat
        }
        
    }
    
    // returns message from specific index
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    // returns total number of messages
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // gets the right bubble image for each kind of message (incoming, outgoing)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    // hiding of avatars by now
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // sets font color
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        // if sender id is the same as our logged in users sender id use a white bubble
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    // sets sender name on top of message bubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!{
        let message = messages[indexPath.item]
        
        guard let senderDisplayName = message.senderDisplayName else {
            assertionFailure()
            return nil
        }
        
        return NSAttributedString(string: senderDisplayName)
    }
    
    // needed little extra space, for sender name at top of message bubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 17.0
    }
}
