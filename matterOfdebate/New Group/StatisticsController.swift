//
//  StatisticsController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class StatisticsController : UIViewController {
    
    @IBOutlet weak var ContraButton: UIButton!
    @IBOutlet weak var proButton: UIButton!
    
    public var proVotes = 0
    public var contraVotes = 0
    
    public func getProVotes() -> Int{
        return proVotes
    }
    
    public func getContraVotes() -> Int{
        return contraVotes
    }
    
    @IBAction func voteForPro(_ sender: Any) {
        proVotes = proVotes+1
    }
    
    @IBAction func voteForContra(_ sender: Any) {
        contraVotes = contraVotes+1
    }
}
