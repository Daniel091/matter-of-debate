//
//  StatisticsController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class StatisticsController : UIViewController {
    let statisticCalculations = StatisticCalculations()
    
    @IBOutlet weak var ContraButton: UIButton!
    @IBOutlet weak var proButton: UIButton!
    
    public var proVotes = 0
    public var contraVotes = 0
    var allVotes = 0
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    override func viewDidLoad() {
        allVotes = statisticCalculations.provideChartData(proVotes: proVotes, contraVotes: contraVotes)
        
        statisticCalculations.setChart(months: months, ui: unitsSold)
        
    }
    
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
