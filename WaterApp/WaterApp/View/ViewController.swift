//
//  ViewController.swift
//  WaterApp
//
//  Created by Mehmet Ak on 4.08.2022.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var waterConsumption: UITextField!
    @IBOutlet weak var totalConsume: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateControl()
        createChart()
        screenRefresh()
        //deleteUserDefaults()
    }
    @IBAction func addButton(_ sender: Any) {
        if waterConsumption.text == "" {
            print("boş")
        }
        else {
            let inputValue = Int(waterConsumption.text!)
            let defaults = addWaterConsume(total: inputValue!)
            saveUserDefaults(defaults: defaults)
        }
    }
    func addWaterConsume(total: Int)-> Int{
        let value = UserDefaults.standard.integer(forKey: "Water")
        let totall = value + total
        return totall
    }
    func saveUserDefaults(defaults: Int){
        let defaults = defaults
        UserDefaults.standard.set(defaults, forKey: "Water")
        UserDefaults.standard.set(currentDay, forKey: "Day")
        screenRefresh()
        waterConsumption.text = ""

    }
    func screenRefresh(){
        let value = UserDefaults.standard.integer(forKey: "Water")
        totalConsume.text = "Bugün \(String(value)) ml su tükettiniz."
    }
    func deleteUserDefaults(){
        let defaults = 0.0
        UserDefaults.standard.set(defaults, forKey: "Water")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    var currentDay: Int{
        let now = Date()
        let day = Calendar.current.component(.day, from: now)
        return day
    }
    func dateControl(){
        let latestUpdateDay = getLatestUpdateDay()
        if latestUpdateDay != currentDay {
            let value = UserDefaults.standard.integer(forKey: "Water")
            var count = UserDefaults.standard.integer(forKey: "Count")
            valueSave(value: value, count: count)
            count = count + 1
            if count == 7 {count = 0}
            UserDefaults.standard.set(count, forKey: "Count")
            UserDefaults.standard.set(0, forKey: "Water")
        }
    }
    func valueSave(value: Int,count: Int){
        switch count {
        case 0:
            UserDefaults.standard.set(value, forKey: "0")
        case 1:
            UserDefaults.standard.set(value, forKey: "1")
        case 2:
            UserDefaults.standard.set(value, forKey: "2")
        case 3:
            UserDefaults.standard.set(value, forKey: "3")
        case 4:
            UserDefaults.standard.set(value, forKey: "4")
        case 5:
            UserDefaults.standard.set(value, forKey: "5")
        case 6:
            UserDefaults.standard.set(value, forKey: "6")
        default:
            print("a")
        }

    }
    func getLatestUpdateDay() -> Int {
        let latestDay = UserDefaults.standard.integer(forKey: "Day")
        return latestDay
    }
    private func createChart(){
        let barChart = BarChartView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: view.frame.size.width/1.2,
                                                  height: view.frame.size.height/4))
        var entries = [BarChartDataEntry]()
        var waterArray = [0,0,0,0,0,0,0]
        for i in 0...6 {
            waterArray[i] = UserDefaults.standard.integer(forKey: "\(i)")
        }
        for x in 1...waterArray.count{
            entries.append(
                BarChartDataEntry(x: Double(x),
                                  y: Double(waterArray[x-1])))
        }
        let set = BarChartDataSet(entries: entries, label: "Tüketim")
        let data = BarChartData(dataSet: set)
        barChart.data = data
        view.addSubview(barChart)
        barChart.center = imageView.center

    }
}

