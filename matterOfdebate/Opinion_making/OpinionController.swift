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
    
    @IBOutlet var opinionView : UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderVal: UILabel!
    
    //TODO: insert real ThemeID
    let topicID = "-L-kN-4XVEASyFAR0asg"
    
    var opinionValue: Int = 0
    
    weak var delegate: TabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Opinion"
    }
    
    
    @IBAction func backToTopicView(_ sender: Any) {
        navigationController?.popViewController(animated: false)
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
        let dialogController = UIAlertController(title: "Searching for match", message: "This could take bit longer ... Do you want to change to your Chats or go back to browse in Topics ?", preferredStyle: .alert)
        
        //going back to browse through themes
        let backToTopicView = UIAlertAction(title: "Theme View", style: .default) { (_) in
            self.backToTopicView(self)
        }
        
        //stay at this view
        let gotToChatsView = UIAlertAction(title: "Chat View", style: .cancel) { (_) in
            self.navigationController?.popToRootViewController(animated: false)
            self.delegate?.switchToTab(2)
            //self.performSegue(withIdentifier: "showChatsView", sender: self)
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
