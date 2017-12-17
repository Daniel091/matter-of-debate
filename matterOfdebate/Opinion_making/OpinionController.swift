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
        // TODO: insert topicID
        if (matchingFuction.searchForMatching(topicID: "-L-kN-4XVEASyFAR0asg", currUserID: currUserID, opinionGroup: opinionGroup)){
            
            
            // TODO: just for testing:
            showDialog()
        } else {
            showDialog()
        }
        
        // TODO: richtiges Topic irgendwo herbekommen
//        let topic: Topic()
//        let opinion = Opinion(topic: topic, user: SingletonUser.sharedInstance, opinionGroup: opinionValue)
        print(opinionValue)
    }
    
    func showDialog() {
        let dialogController = UIAlertController(title: "Es wird nach einem Match gesucht", message: "Das könnte etwas länger dauern ... Willst du hier bleiben, oder zurück zu der Themenübersicht?", preferredStyle: .alert)
        
        //going back to browse through themes
        let confirmAction = UIAlertAction(title: "zurück", style: .default) { (_) in
            //TODO: hier ThemenView wieder aufrufen
        }
        
        //stay at this view
        let cancelAction = UIAlertAction(title: "bleiben", style: .cancel) { (_) in
            //TODO: hier ladebalken anzeigen(Android: ProgressBar)
            // mit dem Text: "search for matching"
            // Slider und Button sperren auf dieser View
        }
        
        //adding the action to dialogbox
        dialogController.addAction(confirmAction)
        dialogController.addAction(cancelAction)
        
        self.present(dialogController, animated: true, completion: nil)
    }
    
    func saveOpinionInFirebaseDatabase(opinionValue: Int) {
        //TODO: insert real ThemeID
       let currUserID = SingletonUser.sharedInstance.user.uid
    Constants.refs.databaseUsers.child(currUserID).child("opinions").child("-L-kN-4XVEASyFAR0asg").setValue(getOpinionGroup(opinion: opinionValue))
    }
    
    public func getOpinionGroup(opinion: Int) -> Int {
        return opinion/Constants.opinionGroupDistance
    }
}
