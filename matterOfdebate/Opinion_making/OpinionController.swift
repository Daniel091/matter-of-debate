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
    
    

    @IBAction func changeOpinion(_ sender: UISlider) {
        opinionValue = Int(sender.value)
        sliderVal.isHidden = false
        sliderVal.text = "\(opinionValue)"
        
        //print(opinionValue)
    }
    
    
    @IBAction func saveOpinionStartMatching(_ sender: UIButton) {
        Shared.opinionValue = self.opinionValue
        
        searchForMatching()
        
        // TODO: richtiges Topic irgendwo herbekommen
//        let topic: Topic()
//        let opinion = Opinion(topic: topic, user: SingletonUser.sharedInstance, opinionGroup: opinionValue)
        print(opinionValue)
    }
    
    func searchForMatching() {
        switch Shared.opinionValue{
        case 50, 49, 48:
            print("50 pro")
        case 40, 39, 38:
            print("40 pro")
        default:
            print("give user some toast with fail")
        }
    }
    
//    @IBAction func saveOpinion(_ sender: UIButton) {
//        print("save Opinion .. match USer :)")
//    }
    
//    @IBAction func saveTest(_ sender: Any) {
//        print("save Opinion .. match USer :)")
//    }
    
    
}
