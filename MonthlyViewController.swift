//
//  MonthlyViewController.swift
//  Carender
//
//  Created by akazawa on 2019/10/14.
//  Copyright © 2019 tmsah. All rights reserved.
//

import UIKit
var NumberOfEmptyBox = Int() // empty boxs number at the start of the current month
var NextNumberOfEmptyBox = Int() // the same with the next month
var PreviousNumberOfEmptyBox = Int() // the same with the previous month
var PositionIndex = 0  // store vars of empty boxes
var LeapYearCounter = 3

class MonthlyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var thisDay = Date()

    @IBOutlet weak var MonthlyCalendar: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetStartDateDayPosition(thisDay: thisDay)
        
    }

    @IBAction func Next(_ sender: Any) {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: calendar.startOfDay(for: thisDay))!
        GetStartDateDayPosition(thisDay: nextMonth)
        thisDay = nextMonth

        MonthlyCalendar.reloadData()
    }
    
    @IBAction func Prev(_ sender: Any) {
        let prevMonth = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: thisDay))!
        GetStartDateDayPosition(thisDay: prevMonth)
        thisDay = prevMonth

        MonthlyCalendar.reloadData()
    }
    
    func GetStartDateDayPosition(thisDay: Date = Date()) {
        let day = calendar.component(.day, from: thisDay)
        let weekday = calendar.component(.weekday, from: thisDay) - 1
        month = calendar.component(.month, from: thisDay) - 1
        year = calendar.component(.year, from: thisDay)

        switch day {
        case 1...7:
            NumberOfEmptyBox = weekday - day
        case 8...14:
            NumberOfEmptyBox = weekday - day + 7
        case 15...21:
            NumberOfEmptyBox = weekday - day + 14
        case 22...28:
            NumberOfEmptyBox = weekday - day + 21
        case 29...31:
            NumberOfEmptyBox = weekday - day + 28
        default:
            break
        }
        if (NumberOfEmptyBox < 0) {
            NumberOfEmptyBox += 7
        }

        PositionIndex = NumberOfEmptyBox
        currentMonth = Months[month]
        MonthLabel.text = "\(month)月 \(year)"

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var components = DateComponents()
        components.year = year
        // 日数を求めたい次の月。13になってもOK。ドキュメントにも、月もしくは月数とある
        components.month = month + 1 + 1
        // 日数を0にすることで、前の月の最後の日になる
        components.day = 0
        // 求めたい月の最後の日のDateオブジェクトを得る
        let date = calendar.date(from: components)!
        let daysInMonth = calendar.component(.day, from: date)
        return daysInMonth + NumberOfEmptyBox
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthlyCalendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.yellow
        cell.DateLabel.textColor = UIColor.black
        if cell.isHidden {
            cell.isHidden = false
        }
        cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        
        if Int(cell.DateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        switch indexPath.row {
        case 5, 6, 12, 13, 19, 20, 26, 27, 33, 34:
            if Int(cell.DateLabel.text!)! > 0 {
                cell.DateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        if currentMonth == Months[calendar.component(.month, from: today) - 1] && year == calendar.component(.year, from: today) && indexPath.row + 1 - PositionIndex == todaysDay {
            cell.backgroundColor = UIColor.red
        }
        if month > calendar.component(.month, from: today) - 1 || year > calendar.component(.year, from: today) || (month == calendar.component(.month, from: today) - 1 && indexPath.row + 1 - PositionIndex > todaysDay)  {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath)!
        cell.backgroundColor = UIColor.blue // タップしているときの色にする
        
        let selectedDay = String(format: "%04d", year) + "-" + String(format: "%02d", month + 1) + "-" + String(format: "%02d", indexPath.item + 1 - PositionIndex)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormater.date(from: selectedDay)!

    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath)!
        if (indexPath.item == todaysDay) {
            cell.backgroundColor = UIColor.red
        }
        else {
            cell.backgroundColor = UIColor.yellow  // 元の色にする
        }
    }    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.selectedDate = selectedDate
    }
}
