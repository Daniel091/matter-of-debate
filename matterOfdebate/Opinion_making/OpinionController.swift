//
//  OpininionController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 12.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

protocol TabBarDelegate: class {
    func switchToTab(_ index: Int)
}

class OpinionController : UIViewController {
    
    @IBOutlet weak var topicDescriptionLabel: UILabel!
    @IBOutlet var opinionView : UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderVal: UILabel!
    public var selectedTopic: Topic?
    
    var topicID = ""
    var topicDescription = ""
    
    var opinionValue: Int = 0
    
    weak var delegate: TabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedTopic!.title
        
        if let description = selectedTopic?.description {
            topicDescription = description
        }
        topicDescriptionLabel.text = topicDescription
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let id = selectedTopic?.id {
            topicID = id
        }
    }
    
    @IBAction func backToTopicView(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
        self.delegate?.switchToTab(0)
    }
    
    @IBAction func changeOpinion(_ sender: UISlider) {
        opinionValue = Int(sender.value)
        sliderVal.isHidden = false
        sliderVal.text = "\(opinionValue)"
        
        //print(opinionValue)
    }
    
    
    
    @IBAction func saveOpinionStartMatching(_ sender: UIButton) {
        let matchingFuction = MatchingFunction()
        saveOpinionInFirebaseDatabase(opinionValue: opinionValue)
        let opinionGroup = getOpinionGroup(opinion: opinionValue)
        let currUserID = SingletonUser.sharedInstance.user.uid
        
        showDialog()
        
        DispatchQueue.global(qos: .background).async {
            matchingFuction.searchForMatching(topicID: self.topicID, currUserID: currUserID, opinionGroup: opinionGroup)
        }
        
        print(opinionValue)
    }
    
    func showDialog() {
        let dialogController = UIAlertController(title: "Searching for match", message: "This could take a bit longer ... Do you want to change to your chats or go back to browse topics ?", preferredStyle: .alert)
        
        //going back to browse through themes
        let backToTopicView = UIAlertAction(title: "Categories", style: .default) { (_) in
            self.backToTopicView(self)
        }
        
        //stay at this view
        let gotToChatsView = UIAlertAction(title: "Chats", style: .cancel) { (_) in
            self.navigationController?.popToRootViewController(animated: false)
            //TODO: geht iwie nimmer -.- -.-
            self.delegate?.switchToTab(2)
        }
        
        //adding the action to dialogbox
        dialogController.addAction(backToTopicView)
        dialogController.addAction(gotToChatsView)
        
        self.present(dialogController, animated: true, completion: nil)
    }
    
    func saveOpinionInFirebaseDatabase(opinionValue: Int) {
       let currUserID = SingletonUser.sharedInstance.user.uid
    Constants.refs.databaseUsers.child(currUserID).child("opinions").child(topicID).setValue(getOpinionGroup(opinion: opinionValue))
    }
    
    public func getOpinionGroup(opinion: Int) -> Int {
        return opinion/Constants.opinionGroupDistance
    }
}
