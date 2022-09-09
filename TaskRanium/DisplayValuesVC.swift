//
//  DisplayValuesVC.swift
//  TaskRanium
//
//  Created by Sunil Uppin on 09/09/22.
//

import UIKit
import Charts
import Highcharts

class DisplayValuesVC: UIViewController {
    
    var viewModel = AsteriodsViewModel()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var scrollContentWidth: NSLayoutConstraint!
    
    var dateArray = [String]()
    var fastestArray = [Double]()
    var closestArray = [Double]()
    var averageArray = [Double]()
    
    let groupSpace = 0.06
    let barSpace = 0.02
    let barWidth = 0.45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDatas()
        setupChart()
    }
    
    func updatedXaxix() {
        DispatchQueue.main.async { [self] in
            
            barChartView.backgroundColor = .white
            barChartView.drawBarShadowEnabled = false
            barChartView.drawValueAboveBarEnabled = false
            barChartView.dragEnabled = false
            barChartView.setScaleEnabled(false)
            barChartView.pinchZoomEnabled = false
            
            let xAxis = barChartView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.drawGridLinesEnabled = false
            xAxis.labelFont = .systemFont(ofSize: 11, weight: .semibold)
            xAxis.labelTextColor = .black
            xAxis.granularity = 0
//            xAxis.labelRotationAngle = -90
            xAxis.labelCount = dateArray.count
            xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
            xAxis.drawAxisLineEnabled = false
            xAxis.axisMinimum = 0
            xAxis.axisMaximum = Double(dateArray.count)
            xAxis.centerAxisLabelsEnabled = true
            
            let leftAxis = barChartView.leftAxis
            leftAxis.enabled = true
            leftAxis.axisMinimum = 0
            leftAxis.drawGridLinesEnabled = false
            //        leftAxis.labelCount = 4
            leftAxis.labelTextColor = .red
            leftAxis.spaceTop = 0.25
            
            let rightAxis = barChartView.rightAxis
            rightAxis.enabled = false
            
//            let legend = barChartView.legend
//            legend.font = .systemFont(ofSize: 11, weight: .semibold)
//            legend.textColor = .systemPink
//            legend.form = .circle
//            legend.xEntrySpace = 16
            
            updatedSetupDataCount()
        }
    }
    
    func updatedSetupDataCount() {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dateEntries2: [BarChartDataEntry] = []
        
        for i in 0..<self.dateArray.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(fastestArray[i]) ?? 0)
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(closestArray[i]) ?? 0)
            dataEntries1.append(dataEntry1)
            
            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: Double(averageArray[i]) ?? 0)
            dateEntries2.append(dataEntry2)
        }
        
        let fastestValuesSet = BarChartDataSet(entries: dataEntries, label: "Fastest")
        fastestValuesSet.setColor(UIColor.red)
        fastestValuesSet.drawValuesEnabled = true
        
        let closestValuesSet = BarChartDataSet(entries: dataEntries1, label: "Closest")
        closestValuesSet.setColor(UIColor.yellow)
        closestValuesSet.drawValuesEnabled = true
        
        let averageValuesSet = BarChartDataSet(entries: dateEntries2, label: "Average")
        averageValuesSet.setColor(UIColor.green)
        averageValuesSet.drawValuesEnabled = true
        
        let data = BarChartData(dataSets: [fastestValuesSet, closestValuesSet, averageValuesSet])
        data.highlightEnabled = false
        data.setValueFormatter(XValueFormatter())
        data.barWidth = barWidth
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        let groupCount = self.dateArray.count
        let startYear = 0
        
        barChartView.xAxis.axisMinimum = Double(startYear)
        let gg = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
                
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.axisMinimum = 0
        barChartView.xAxis.axisMaximum = Double(dateArray.count)
        barChartView.xAxis.centerAxisLabelsEnabled = true
        
        barChartView.notifyDataSetChanged()
        barChartView.data = data
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)

    }
    
    func setupChart() {
        DispatchQueue.main.async {
            self.barChartView.isHidden = true
            let chartView = HIChartView(frame: self.scrollContentView.bounds)
            chartView.theme = "brand-light"
            
            let options = HIOptions()
            
            let chart = HIChart()
            chart.type = "bar"
            options.chart = chart
            
            let title = HITitle()
            title.text = "Historic World Population by Region"
            options.title = title
            
            let subtitle = HISubtitle()
            subtitle.text = "Source: <a href=\"https://en.wikipedia.org/wiki/World_population\">Wikipedia.org</a>"
            options.subtitle = subtitle
            
            let xAxis = HIXAxis()
            xAxis.categories = ["Africa", "America", "Asia", "Europe", "Oceania"]
            options.xAxis = [xAxis]
            
            let yAxis = HIYAxis()
            yAxis.min = 0
            yAxis.title = HITitle()
            yAxis.title.text = "Population (millions)"
            yAxis.title.align = "high"
            yAxis.labels = HILabels()
            yAxis.labels.overflow = "justify"
            options.yAxis = [yAxis]
            
            let tooltip = HITooltip()
            tooltip.valueSuffix = " millions"
            options.tooltip = tooltip
            
            let plotOptions = HIPlotOptions()
            plotOptions.bar = HIBar()
            let dataLabels = HIDataLabels()
            dataLabels.enabled = true
            plotOptions.bar.dataLabels = [dataLabels]
            options.plotOptions = plotOptions
            
            let legend = HILegend()
            legend.layout = "vertical"
            legend.align = "right"
            legend.verticalAlign = "top"
            legend.x = -40
            legend.y = 80
            legend.floating = true
            legend.borderWidth = 1
            legend.backgroundColor = HIColor(hexValue: "FFFFFF")
            legend.shadow = HICSSObject()
            legend.shadow.opacity = 1
            options.legend = legend
            
            let credits = HICredits()
            credits.enabled = false
            options.credits = credits
            
            let year1800 = HIBar()
            year1800.name = "Year 1800"
            year1800.data = [107, 31, 635, 203, 2]
            
            let year1900 = HIBar()
            year1900.name = "Year 1900"
            year1900.data = [133, 156, 947, 408, 6]
            
            let year2000 = HIBar()
            year2000.name = "Year 2000"
            year2000.data = [814, 841, 3714, 727, 31]
            
            let year2016 = HIBar()
            year2016.name = "Year 2016"
            year2016.data = [1216, 1001, 4436, 738, 40]
            
            options.series = [year1800, year1900, year2000, year2000]
            
            chartView.options = options
            
//            self.scrollContentView.addSubview(chartView)
            self.view.addSubview(chartView)
        }
    }
}

extension DisplayValuesVC {
    func getDatas() {
        viewModel.getAsteriodDetails("", "") { e in
            guard e == nil else {
                return
            }
            debugPrint("SUCCESS")
            if let neo = self.viewModel.asteriodsValue?.nearEarthObjects {
                debugPrint(neo)
                let arr = Array(neo.keys)
                if arr.count > 0 {
                    for i in 0..<arr.count {
                        let dateValue = arr[i]
                        self.dateArray.append(dateValue)
                        let count = neo[dateValue]?.count ?? 0
                        var relativeVelocityArray = [Double]()
                        var missDistanceArray = [Double]()
                        var averageDiameter = [Double]()
                        for j in 0..<count {
                            let val = neo[dateValue]
                            let relatedData = val?[j].closeApproachData
                            debugPrint(relatedData!)
                            let relativeVelocityInKM = relatedData?.first?.relativeVelocity.kilometersPerHour
                            let doubleValue = Double(relativeVelocityInKM ?? "") ?? 0
                            relativeVelocityArray.append(Double(round(100 * doubleValue) / 100))
                            
                            let missDistanceInKm = relatedData?.first?.missDistance.kilometers
                            let doubleValue1 = Double(missDistanceInKm ?? "") ?? 0
                            missDistanceArray.append(Double(round(100 * doubleValue1) / 100))
                            
                            // Average Diameter
                            let maxDiameter = val?[j].estimatedDiameter.kilometers.estimatedDiameterMax ?? 0
                            let minDiameter = val?[j].estimatedDiameter.kilometers.estimatedDiameterMin ?? 0
                            
                            let totalDiameter = maxDiameter + minDiameter
                            let avgDiameter = totalDiameter / 2
                            debugPrint(avgDiameter)
                            averageDiameter.append(Double(round(100 * avgDiameter) / 100))
                        }
                        let total = averageDiameter.reduce(0, { $0 + $1})
                        let avgOfThatDay = total / Double(count)
                        self.averageArray.append(avgOfThatDay)
                        
                        let fast = relativeVelocityArray.max()
                        self.fastestArray.append(fast ?? 0)
                        
                        let close = missDistanceArray.min()
                        self.closestArray.append(close ?? 0)
                    }
                }
            }
//            self.updatedXaxix()
            self.setupChart()
        }
    }
}

public class XValueFormatter: NSObject, IValueFormatter {
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return value <= 0.0 ? "" : String(describing: value)
    }
}
