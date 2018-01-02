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
    
    // MessagesView has a Chat object to display
    var chat: Chat?
    
    var statisticsView = StatisticsView()
    public var proVotes = 0
    public var contraVotes = 0
    var allVotes = 0
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    override func viewDidLoad() {
        title = "Statistik"
        //allVotes = statisticCalculations.provideChartData(proVotes: proVotes, contraVotes: contraVotes)
        //statisticCalculations.setChart(months: months, ui: unitsSold)
        initBarChart()
        barChartUpdate()
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
    
    func initBarChart() {
        let formatter = ChartStringFormatter()
        barChart.xAxis.valueFormatter = formatter

        barChart.xAxis.labelCount = 2
        barChart.xAxis.labelPosition = .bottom
        
        // disable gird lines, legend, descritption label
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.leftAxis.axisMinimum = 0
        barChart.rightAxis.enabled = false
        barChart.legend.enabled = false
        barChart.chartDescription?.enabled = false
        
        // Disable user edit
        barChart.doubleTapToZoomEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.highlightPerTapEnabled = false
        barChart.highlightPerDragEnabled = false
    }
    
    func barChartUpdate () {
        //future home of bar chart code
        let entry1 = BarChartDataEntry(x: 1.0, y: 50.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 50.0)
        let dataSet = BarChartDataSet(values: [entry1, entry2], label: "Pro und Contra")

        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.barData?.barWidth = Double(0.50)
        
        // set colors
        let green = UIColor(hue: 0.35, saturation: 1, brightness: 0.42, alpha: 1.0) /* #006b0a */
        let red = UIColor(hue: 0.0222, saturation: 1, brightness: 0.58, alpha: 1.0) /* #931300 */
        dataSet.colors = [green, red]
        
        //This must stay at end of function
        barChart.notifyDataSetChanged()
    }
    
    @IBAction func renderCharts() {
        barChartUpdate()
    }
    
    class ChartStringFormatter: NSObject, IAxisValueFormatter {
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let strings = ["Pro","Contra"]
            return strings[Int(value)-1]
        }
    }
}
