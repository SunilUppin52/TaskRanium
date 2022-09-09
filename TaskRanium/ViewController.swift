//
//  ViewController.swift
//  TaskRanium
//
//  Created by Sunil Uppin on 09/09/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    
    var dateFormatter = DateFormatter()
    var isStartDate = false
    var isEndDate = false
    
    var startDateString = ""
    var endDateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        startDate.layer.borderColor = UIColor.gray.cgColor
        startDate.layer.borderWidth = 1.0
        startDate.layer.cornerRadius = 10
        startDate.clipsToBounds = true
        startDate.titleLabel?.textColor = .lightGray
        
        endDate.layer.borderColor = UIColor.gray.cgColor
        endDate.layer.borderWidth = 1.0
        endDate.layer.cornerRadius = 10
        endDate.clipsToBounds = true
        endDate.titleLabel?.textColor = .lightGray
        
        submitButton.backgroundColor = .systemRed
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        submitButton.titleLabel?.textColor = .white
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    }
    
    @IBAction func startDateButtonTapped(_ sender: Any) {
        datePicker.isHidden = false
        isStartDate = true
        isEndDate = false
    }
    
    @IBAction func endDateButtonTapped(_ sender: Any) {
        datePicker.isHidden = false
        isStartDate = false
        isEndDate = true
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let result = compareDates(startDateString, endDateString)
        guard result else {
            return
        }
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainSB.instantiateViewController(withIdentifier: "DisplayChartsVC") as! DisplayChartsVC
        nextVC.startDate = startDateString
        nextVC.endDate = endDateString
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func datePickerTappen(_ sender: UIDatePicker) {
        datePicker.datePickerMode = .date
        let date = dateFormatter.string(from: datePicker.date)
        if isStartDate {
            startDateString = dateConversion(date)
            startDate.setTitle(date, for: .normal)
        } else {
            endDateString = dateConversion(date)
            endDate.setTitle(date, for: .normal)
        }
        datePicker.isHidden = true
    }
}

extension ViewController {
    func dateConversion(_ date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: showDate!)
        debugPrint(resultString)
        return resultString
    }
    
    func compareDates(_ startDate: String, _ endDate: String) -> Bool {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = inputFormatter.date(from: startDate) ?? Date()
        let endDate = inputFormatter.date(from: endDate) ?? Date()
        if endDate < startDate {
            let refreshAlert = UIAlertController(title: "", message: "End Date cannot be lesser than Start Date", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        } else {
            let calendar = NSCalendar.current as NSCalendar
            let date1 = calendar.startOfDay(for: startDate)
            let date2 = calendar.startOfDay(for: endDate)
            let flags = NSCalendar.Unit.day
            let components = calendar.components(flags, from: date1, to: date2)
            if (components.day ?? 0) + 1 > 8 {
                let refreshAlert = UIAlertController(title: "", message: "Date range cannot exceed more than 8 days", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(refreshAlert, animated: true, completion: nil)
            } else {
                return true
            }
        }
        return false
    }
}


