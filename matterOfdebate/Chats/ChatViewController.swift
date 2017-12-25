//
//  ChatViewController.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 29.11.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    // array that stores messages
    var messages = [JSQMessage]()
    
    // ChatViewController has a Chat object to display
    var chat: Chat?
    
    // create colored message bubbles, outgoing is blue, incoming gray
    // lazy vars are only initialized once, when there accessed
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up back navigation
        //setupBackButton()
        
        // set up settings button for chat
        setupSettingsChatButton()
        
        // if no chat dismiss ChatView
        guard let chat_id = chat?.id else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        
        // get user object
        let user_obj = SingletonUser.sharedInstance.user
        
        senderId = user_obj.uid
        senderDisplayName = user_obj.user_name
        
        // hide attachement button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        // hidding avatar
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Query Messages of chat_id
        let query = Constants.refs.databaseMessages.child(chat_id)
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
    
    func setupSettingsChatButton() {
        let settingsButton = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicator(), style: .plain, target: self, action: #selector(settingsButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    // TODO implement showing of chat settings
    @objc func settingsButtonTapped(sender: UIBarButtonItem) {
        print(":-) Implement mee")
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped(sender:)))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // User sends a message
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        guard let chat_id = chat?.id else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // push text to firebase database messages
        let ref = Constants.refs.databaseMessages.child(chat_id).childByAutoId()
        let message = ["sender-id": senderId, "name": senderDisplayName, "text": text]
        ref.setValue(message)
        
        // and set lastMessage of chat; and update timestamp
        let ref_chat = Constants.refs.databaseChats.child(chat_id)
        let timestamp = Date().timeIntervalSince1970
        
        let childUpdates = ["lastMessage": senderDisplayName + ": " + text,
                            "timestamp": timestamp] as [String : Any]
        ref_chat.updateChildValues(childUpdates)
        
        // do a nice animation
        finishSendingMessage()
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
    
}
