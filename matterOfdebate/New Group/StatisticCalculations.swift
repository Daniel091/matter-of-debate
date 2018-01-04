//
//  StatisticCalculations.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Charts

class StatisticCalculations {
    
    func provideChartData(proVotes: Int, contraVotes: Int) -> Int {
        return proVotes + contraVotes
    }
    
    func sendStatisticsToDatatbase(_ statistic: Statistic) {
        let dataRef = Constants.refs.statistics.child(statistic.getID())
        dataRef.child("pro").setValue(statistic.getPro())
        dataRef.child("contra").setValue(statistic.getContra())
        let userRef = dataRef.child("users").child(SingletonUser.sharedInstance.user.uid)
        userRef.child("startOpinion").setValue(statistic.getStartOpinion())
        userRef.child("endOpinion").setValue(statistic.getCurrentOpinion())
    }
    
    func getStatisticByChatId(_ chatId : String) -> Statistic? {
        if !SharedData.statistics.isEmpty {
            if let index = SharedData.statistics.index(where: { $0.id == chatId }) {
                return SharedData.statistics[index]
            }
        }
        
        return nil
    }
    
    func updateStatistic(_ statistic: Statistic) {
        if !SharedData.statistics.isEmpty {
            if let index = SharedData.statistics.index(where: { $0.id == statistic.id }) {
                SharedData.statistics[index] = statistic
            }
        }
    }
}
