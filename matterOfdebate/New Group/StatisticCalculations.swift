//
//  StatisticCalculations.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation

class StatisticCalculations {
    var allVotes = 0
    let statisticsController = StatisticsController()
    
    func provideChartData() {
        allVotes = statisticsController.getProVotes() + statisticsController.getContraVotes()
        
        
    }
    
}
