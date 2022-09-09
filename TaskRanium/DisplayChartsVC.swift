//
//  DisplayChartsVC.swift
//  TaskRanium
//
//  Created by Sunil Uppin on 09/09/22.
//

import UIKit
import Highcharts

class DisplayChartsVC: UIViewController {
    
    var viewModel = AsteriodsViewModel()
    
    var dateArray = [String]()
    var fastestArray = [Double]()
    var closestArray = [Double]()
    var averageArray = [Double]()
    
    var vSpinner : UIView?
    
    var startDate: String?
    var endDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getDatas()
    }
    
    func getDatas() {
        self.showSpinner(onView: self.view)
        viewModel.getAsteriodDetails(startDate ?? "", endDate ?? "") { e in
            guard e == nil else {
                return
            }
            self.calulateData()
        }
    }
    
    func calulateData() {
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
                        
                        // Relative velocity for Fastest Asteroid
                        let relativeVelocityInKM = relatedData?.first?.relativeVelocity.kilometersPerHour
                        let doubleValue = Double(relativeVelocityInKM ?? "") ?? 0
                        relativeVelocityArray.append(Double(round(100 * doubleValue) / 100))
                        
                        // Miss distance for Closest Asteroid
                        let missDistanceInKm = relatedData?.first?.missDistance.kilometers
                        let doubleValue1 = Double(missDistanceInKm ?? "") ?? 0
                        missDistanceArray.append(Double(round(100 * doubleValue1) / 100))
                        
                        // Average Diameter
                        let maxDiameter = val?[j].estimatedDiameter.kilometers.estimatedDiameterMax ?? 0
                        let minDiameter = val?[j].estimatedDiameter.kilometers.estimatedDiameterMin ?? 0
                        
                        let totalDiameter = maxDiameter + minDiameter
                        let avgDiameter = totalDiameter / 2
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
            self.setupChart()
        }
    }
    
    func setupChart() {
        DispatchQueue.main.async {
            let chartView = HIChartView(frame: self.view.bounds)
            chartView.theme = "brand-light"
            
            let options = HIOptions()
            
            let chart = HIChart()
            chart.type = "column"
            options.chart = chart
            
            let title = HITitle()
            title.text = "Near-Earth Objects"
            options.title = title
            
            let xAxis = HIXAxis()
            xAxis.categories = self.dateArray
            options.xAxis = [xAxis]
            
            let yAxis = HIYAxis()
            yAxis.min = 0
            yAxis.title = HITitle()
            yAxis.title.text = "Kilometers per hour"
            options.yAxis = [yAxis]
            
            let tooltip = HITooltip()
            tooltip.headerFormat = "<span style=\"font-size:10px\">{point.key}</span><table>"
            tooltip.pointFormat = "<tr><td style=\"color:{series.color};padding:0\">{series.name}: </td>" + "<td style=\"padding:0\"><b>{point.y:.1f} mm</b></td></tr>"
            tooltip.footerFormat = "</table>"
            tooltip.shared = true
            tooltip.useHTML = true
            options.tooltip = tooltip
            
            let plotOptions = HIPlotOptions()
            plotOptions.column = HIColumn()
            plotOptions.column.pointPadding = 0.2
            plotOptions.column.borderWidth = 0
            options.plotOptions = plotOptions
            
            let fastestAsteroid = HIColumn()
            fastestAsteroid.name = "Fastest Asteroid"
            fastestAsteroid.data = self.fastestArray
            
            let closestAsteroid = HIColumn()
            closestAsteroid.name = "Closest Asteroid"
            closestAsteroid.data = self.closestArray
            
            let averageSize = HIColumn()
            averageSize.name = "Average Size"
            averageSize.data = self.averageArray
            
            options.series = [fastestAsteroid, closestAsteroid, averageSize]
            
            chartView.options = options
            
            self.view.addSubview(chartView)
        }
    }
}

extension DisplayChartsVC {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
