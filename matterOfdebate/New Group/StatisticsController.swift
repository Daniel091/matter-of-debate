//
//  StatisticsController.swift
//  matterOfdebate
//
//  Created by Stefanie Huber on 26.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import Charts

class StatisticsController : UIViewController {
    let statisticCalculations = StatisticCalculations()
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    
    // MessagesView has a Chat object to display
    var chat: Chat?
    
    var statisticsView = StatisticsView()
    public var proVotes = 0
    public var contraVotes = 0
    var allVotes = 0
    
    override func viewDidLoad() {
        title = "Statistik"
        //allVotes = statisticCalculations.provideChartData(proVotes: proVotes, contraVotes: contraVotes)
        //statisticCalculations.setChart(months: months, ui: unitsSold)
        barChartUpdate()
        pieChartUpdate()
    }
    
    @IBAction func proClick(_ sender: Any) {
        print("testPro")
    }
    
    @IBAction func contraClick(_ sender: Any) {
        print("testContra")
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
    
    func pieChartUpdate() {
        
    }
    
    func barChartUpdate () {
        //future home of bar chart code
        let entry1 = BarChartDataEntry(x: 1.0, y: 50.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 50.0)
        let dataSet = BarChartDataSet(values: [entry1, entry2], label: "Pro und Contra")
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.chartDescription?.text = "Chat Meinungen"
    
        
        let formatter = ChartStringFormatter()
        barChart.xAxis.valueFormatter = formatter
        
        barChart.xAxis.labelPosition = .bottom
        //All other additions to this function will go here
        dataSet.colors = ChartColorTemplates.colorful()
        
        // Disable user edit
        barChart.doubleTapToZoomEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.highlightPerTapEnabled = false
        barChart.highlightPerDragEnabled = false
        
        
        //This must stay at end of function
        barChart.notifyDataSetChanged()
    }
    
    @IBAction func renderCharts() {
        barChartUpdate()
    }
    
    class ChartStringFormatter: NSObject, IAxisValueFormatter {
        var nameValues: [String]! =  ["A", "B", "C", "D"]
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return String(describing: nameValues[Int(value)])
        }
    }
}
