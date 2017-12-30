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
            
            guard let data = snapshot.value as? [String: String],
                let name = data["name"],
                let text = data["text"],
                let id = data["sender-id"],
                !text.isEmpty,
                let message = JSQMessage(senderId: id, displayName: name, text: text) else { return
            }
            
            self?.messages.append(message)
            self?.finishReceivingMessage()
        })
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // limitation of characters && disable copypaste
        return textView.text.count <= Constants.maxNumberOfCharacters && text.count <= Constants.maxNumberCopyPaste
    }
    
    func setupSettingsChatButton() {
        let settingsButton = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicator(), style: .plain, target: self, action: #selector(settingsButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func settingsButtonTapped(sender: UIBarButtonItem) {
        guard let chat_obj = self.chat else {
            return
        }
        
        self.performSegue(withIdentifier: "chatSettings", sender: chat_obj)
    }
    
    // give chat to ChatSettings controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat_obj = sender as? Chat {
            let chatSettingsController = segue.destination as! UserChatSettings
            chatSettingsController.chat = chat_obj
        }
        
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
        
        guard !spamFilter(senderId) else {
            showDialog()
            return
        }
        
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
    
    // notification for user about chatmessages
    func showDialog() {
        let dialogController = UIAlertController(title: "", message: "You have to wait for your contrahent to answer your messages", preferredStyle: .alert)
        
        //stay at this view
        let gotToChatsView = UIAlertAction(title: "ok", style: .cancel) { (_) in
        }
        
        //adding the action to dialogbox
        dialogController.addAction(gotToChatsView)
        
        self.present(dialogController, animated: true, completion: nil)
    }
    
    // spam filter for chat -- checks if the last messages are from current user and disables him from sending another
    func spamFilter(_ curSenderID : String) -> Bool {
        
        guard messages.count >= 3 else {
            return false
        }
        for index in 1 ... Constants.maxNumberOfChatmessages {
            let lastMessage = messages[messages.count - index]
            let lastlastMessage = messages[messages.count - index]
            let lastlastlastMessage = messages[messages.count - index]
            
            if lastMessage.senderId == lastlastMessage.senderId
                && lastlastlastMessage.senderId == curSenderID
                && lastMessage.senderId == curSenderID{
                return true
            }
        }
        return false
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
