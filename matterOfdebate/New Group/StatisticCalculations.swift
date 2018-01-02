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
    
    func sendStatisticsToDatatbase(proVotes: Int, contraVotes: Int, currentOpinion: String, startOpinion: String, chatID: String) {
        let dataRef = Constants.refs.statistics.child(chatID)
        dataRef.child("pro").setValue(proVotes)
        dataRef.child("contra").setValue(contraVotes)
        let userRef = dataRef.child("users").child(SingletonUser.sharedInstance.user.uid)
        userRef.child("startOpinion").setValue(startOpinion)
        userRef.child("endOpinion").setValue(currentOpinion)
    }
    
    func getStatisticByChatId(_ chatId : String) -> Statistic? {
        if !SharedData.statistics.isEmpty {
            if let i = SharedData.statistics.index(where: { $0.id == chatId }) {
                let statistic = SharedData.statistics[i]
                return statistic
            }
        }
        
        return nil
    }
    
}
