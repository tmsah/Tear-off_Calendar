//
//  MonthlyViewController.swift
//  Carender
//
//  Copyright © 2019 tmsah. All rights reserved.
//

import UIKit

class MonthlyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var thisDay = Date()
    var backDay = Date()
    var NumberOfEmptyBox = Int() // empty boxs number at the start of the current month

    @IBOutlet weak var MonthlyCalendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var PrevButton: UIButton!
    @IBOutlet weak var PrevButtonView: UIView!
    @IBOutlet weak var NextButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetStartDateDayPosition(thisDay: thisDay)
        setButtonStatus(thisDay: thisDay)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GetStartDateDayPosition(thisDay: thisDay)
        backDay = thisDay
    }

    @IBAction func Next(_ sender: Any) {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: calendar.startOfDay(for: thisDay))!
        GetStartDateDayPosition(thisDay: nextMonth)
        thisDay = nextMonth
        setButtonStatus(thisDay: thisDay)

        MonthlyCalendar.reloadData()
    }
    
    @IBAction func Prev(_ sender: Any) {
        let prevMonth = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: thisDay))!
        GetStartDateDayPosition(thisDay: prevMonth)
        thisDay = prevMonth
        setButtonStatus(thisDay: thisDay)

        MonthlyCalendar.reloadData()
    }
    
    func GetStartDateDayPosition(thisDay: Date = Date()) {
        let day = calendar.component(.day, from: thisDay)
        let weekday = calendar.component(.weekday, from: thisDay) - 1
        month = calendar.component(.month, from: thisDay)
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

        MonthLabel.text = "\(month)月 \(year)"
        
    }
    
    func setButtonStatus(thisDay: Date) {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: calendar.startOfDay(for: thisDay))!
        let prevMonth = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: thisDay))!
        NextButton.isHidden = nextMonth.compare(lastDay) == .orderedDescending ? true : false
        PrevButton.isHidden = prevMonth.compare(firstDay) == .orderedAscending ? true : false
        NextButtonView.isHidden = nextMonth.compare(lastDay) == .orderedDescending ? true : false
        PrevButtonView.isHidden = prevMonth.compare(firstDay) == .orderedAscending ? true : false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var components = DateComponents()
        components.year = year
        // 日数を求めたい次の月。13になってもOK。ドキュメントにも、月もしくは月数とある
        components.month = month + 1
        // 日数を0にすることで、前の月の最後の日になる
        components.day = 0
        // 求めたい月の最後の日のDateオブジェクトを得る
        let date = calendar.date(from: components)!
        let daysInMonth = calendar.component(.day, from: date)
        return daysInMonth + NumberOfEmptyBox
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthlyCalendar", for: indexPath) as! DateCollectionViewCell
        cell.DateLabel.textColor = UIColor.black
        cell.isUserInteractionEnabled = true
        if cell.isHidden {
            cell.isHidden = false
        }
        let day = indexPath.row + 1 - NumberOfEmptyBox
        cell.DateLabel.text = String(day)

        if Int(cell.DateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        else {
            let wordsInfo = getWordsInfo(day: String(format: "%02d", month) + "-" + String(format: "%02d", day))
            cell.DateStamp.image = UIImage(named: wordsInfo.color + "_stamp")!
        }
        
        if month > calendar.component(.month, from: today) || year > calendar.component(.year, from: today) || (month == calendar.component(.month, from: today) && indexPath.row + 1 - NumberOfEmptyBox > todaysDay)  {
            cell.isUserInteractionEnabled = false
            cell.DateStamp.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let selectedDay = String(format: "%04d", year) + "-" + String(format: "%02d", month) + "-" + String(format: "%02d", indexPath.item + 1 - NumberOfEmptyBox)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormater.date(from: selectedDay)!

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.selectedDate = selectedDate
    }
    
    @IBAction func toDailyButton(_ sender: UIButton) {
        selectedDate = backDay
    }
    
    func getWordsInfo(day: String) -> DayInfo {
        var thisDayInfo: DayInfo!
        DatesJson.datesInfo.forEach({(eachDay) in
            if (eachDay.day == day) {
                thisDayInfo = eachDay
            }
        })
        return thisDayInfo
    }

}
