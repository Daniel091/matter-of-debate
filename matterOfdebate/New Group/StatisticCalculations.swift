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
    
    func setChart(months: [String], ui: [Double]) -> BarChartData{
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry()
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = BarChartData()
        return chartData
    }
    
}
