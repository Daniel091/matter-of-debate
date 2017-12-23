//
//  OpininionController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 12.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class OpinionController : UIViewController {
    
    @IBOutlet var opinionView : UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderVal: UILabel!
    
    //TODO: insert real ThemeID
    let topicID = "-L-kN-4XVEASyFAR0asg"
    
    var opinionValue: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backToTopicView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeOpinion(_ sender: UISlider) {
        opinionValue = Int(sender.value)
        sliderVal.isHidden = false
        sliderVal.text = "\(opinionValue)"
        
        //print(opinionValue)
    }
    
    
    
    @IBAction func saveOpinionStartMatching(_ sender: UIButton) {
        // TODO: check if there is a chat already with currTopicID
//        if() {
//            return
//        }
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
        let dialogController = UIAlertController(title: "Searching for match", message: "This could take bit longer ... Do you want to change to your Chats or go back to browse in Topics ?", preferredStyle: .alert)
        
        //going back to browse through themes
        let confirmAction = UIAlertAction(title: "Back", style: .default) { (_) in
            //TODO: hier ThemenView wieder aufrufen
        }
        
        //stay at this view
        let cancelAction = UIAlertAction(title: "Stay", style: .cancel) { (_) in
            //TODO: hier userChatView aufrufen
            
        }
        
        //adding the action to dialogbox
        dialogController.addAction(confirmAction)
        dialogController.addAction(cancelAction)
        
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
