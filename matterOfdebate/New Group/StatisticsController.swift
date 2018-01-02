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
    
    @IBOutlet weak var proBtn: UIButton!
    @IBOutlet weak var contraBtn: UIButton!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    
    // MessagesView has a Chat object to display
    var chat: Chat?
    
    let statisticCalculation = StatisticCalculations()
    
    override func viewDidLoad() {
        title = "Statistik"
        
        // set round buttons
        contraBtn.layer.cornerRadius = 10
        proBtn.layer.cornerRadius = 10
        
        // Init charts
        initBarChart()
        initPieChart()
      
        // load statistics list
        loadStatistics()
    }
    
    func updateCharts() {
        // show content of shared list
        guard let chat_obj = chat else {return}
        guard let statistic = statisticCalculation.getStatisticByChatId(chat_obj.id) else {return}

        barChartUpdate(Double(statistic.pro), Double(statistic.contra))
        pieChartUpdate(Double(statistic.pro), Double(statistic.contra))
    }
    
    
    func loadStatistics() {
        guard let chat_obj = chat else {
            return
        }
        
        if let statistic = statisticCalculation.getStatisticByChatId(chat_obj.id) {
            barChartUpdate(Double(statistic.pro), Double(statistic.contra))
            pieChartUpdate(Double(statistic.pro), Double(statistic.contra))
        } else {
            // gets statistic data once, saves it to sharedData list
            let ref = Constants.refs.statistics.child(chat_obj.id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                let contra = value?["contra"] as? Int ?? 0
                let pro = value?["pro"] as? Int ?? 0
                let ops = value?["users"] as? [[String]] ?? [[]]
                
                let statistic = Statistic(id: snapshot.key, contra: contra, pro: pro, startOpinion: "asd", currentOpinion: "asasd", opinions: ops)
                
                SharedData.statistics.append(statistic)
                self.updateCharts()
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func proClick(_ sender: Any) {
        guard let chatObject = chat else {
            return
        }
        
        if(SharedData.statistics.isEmpty) {
            return
        }
        
        //TODO: auf die current Opinion noch den User matchen !!
        if(statisticCalculation.getStatisticByChatId(chatObject.id)?.currentOpinion == "pro") {
            // TODO: show dialoge
            return
        }
        
        var proVotesOptional = statisticCalculation.getStatisticByChatId(chatObject.id)?.getPro()
        var contraVotesOptional = statisticCalculation.getStatisticByChatId(chatObject.id)?.getContra()
        
        guard let proVotes = proVotesOptional else { return }
        guard let contraVotes = contraVotesOptional else { return }
        
        if(statisticCalculation.getStatisticByChatId(chatObject.id)?.startOpinion.isEmpty)! {
            statisticCalculations.sendStatisticsToDatatbase(proVotes: proVotes+1, contraVotes: contraVotes-1, currentOpinion: "pro", startOpinion: "pro", chatID: chatObject.id)
        } else {
            statisticCalculations.sendStatisticsToDatatbase(proVotes: proVotes+1, contraVotes: contraVotes, currentOpinion: "pro", startOpinion: "pro", chatID: chatObject.id)
        }
        updateCharts()
        print("testPro")
    }
    
    @IBAction func contraClick(_ sender: Any) {
        guard let chatObject = chat else {
            return
        }
        //TODO: auf die current Opinion noch den User matchen !!
        if(statisticCalculation.getStatisticByChatId(chatObject.id)?.currentOpinion == "contra") {
            return
        }
        
        let proVotesOptional = statisticCalculation.getStatisticByChatId(chatObject.id)?.getPro()
        let contraVotesOptional = statisticCalculation.getStatisticByChatId(chatObject.id)?.getContra()
        
        guard let proVotes = proVotesOptional else { return }
        guard let contraVotes = contraVotesOptional else { return }
        
        if(statisticCalculation.getStatisticByChatId(chatObject.id)?.startOpinion.isEmpty)! {
            statisticCalculations.sendStatisticsToDatatbase(proVotes: proVotes-1, contraVotes: contraVotes+1, currentOpinion: "contra", startOpinion: "contra", chatID: chatObject.id )
        } else {
            statisticCalculations.sendStatisticsToDatatbase(proVotes: proVotes, contraVotes: contraVotes+1, currentOpinion: "contra", startOpinion: "contra", chatID: chatObject.id)
        }
        updateCharts()
        print("testContra")
    }
    
    func pieChartUpdate(_ pro : Double,_ contra : Double) {
        let entry1 = PieChartDataEntry(value: pro, label: "Pro")
        let entry2 = PieChartDataEntry(value: contra, label: "Contra")
        let dataSet = PieChartDataSet(values: [entry1, entry2], label: "Pro und Contras")
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data

        // show percentages
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChart.data?.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        dataSet.colors = ChartColorTemplates.joyful()
        
        //This must stay at end of function
        pieChart.notifyDataSetChanged()
    }
    
    func initPieChart() {
        pieChart.chartDescription?.enabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        
        pieChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCirc)
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
        
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
    }
    
    func barChartUpdate (_ pro : Double,_ contra : Double) {
        //future home of bar chart code
        let entry1 = BarChartDataEntry(x: 1.0, y: pro)
        let entry2 = BarChartDataEntry(x: 2.0, y: contra)
        let dataSet = BarChartDataSet(values: [entry1, entry2], label: "Pro und Contra")

        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.barData?.barWidth = Double(0.50)
        
        // set colors
        let green = UIColor(hue: 0.3083, saturation: 1, brightness: 0.8, alpha: 1.0) /* #1ecc00 */
        let red = UIColor(hue: 0, saturation: 1, brightness: 0.92, alpha: 1.0) /* #ea0000 */
        dataSet.colors = [green, red]
        
        //This must stay at end of function
        barChart.notifyDataSetChanged()
    }
    
    @IBAction func renderCharts() {
        barChartUpdate(3.0,3.0)
        pieChartUpdate(3.0, 3.0)
    }
    
    class ChartStringFormatter: NSObject, IAxisValueFormatter {
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let strings = ["Pro","Contra"]
            return strings[Int(value)-1]
        }
    }
}
