//
//  MonthlyViewController.swift
//  Carender
//
//  Created by akazawa on 2019/10/14.
//  Copyright © 2019 tmsah. All rights reserved.
//

import UIKit

class MonthlyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{


    @IBOutlet weak var MonthlyCalendar: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    let Months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    let DaysOfMonth = ["月", "火", "水", "木", "金", "土", "日"]
    var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int() // empty boxs number at the start of the current month
    var NextNumberOfEmptyBox = Int() // the same with the next month
    var PreviousNumberOfEmptyBox = Int() // the same with the previous month
    var Direction = 0  // =0: current month, =1: future month, =-1: past month
    var PositionIndex = 0  // store vars of empty boxes
    var LeapYearCounter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        
        MonthLabel.text = "\(currentMonth) \(year)"
        
        GetStartDateDayPosition()
        self.MonthlyCalendar.dataSource = self
        self.MonthlyCalendar.delegate = self
        self.MonthlyCalendar.isUserInteractionEnabled = true
        
    }
    
    @IBAction func Next(_ sender: Any) {
        Direction = 1
        switch currentMonth {
        case "12月":
            month = 0
            year += 1
            
            if LeapYearCounter < 5 {
                LeapYearCounter += 1
            }
            if LeapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            if LeapYearCounter == 5 {
                LeapYearCounter = 1
                DaysInMonths[1] = 28
            }

            GetStartDateDayPosition()
        default:
            GetStartDateDayPosition()
            month += 1
        }
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        MonthlyCalendar.reloadData()
    }
    
    @IBAction func Prev(_ sender: Any) {
        Direction = -1
        switch currentMonth {
        case "1月":
            month = 11
            year -= 1
            
            if LeapYearCounter > 0 {
                LeapYearCounter -= 1
            }
            if LeapYearCounter == 0 {
                LeapYearCounter = 4
                DaysInMonths[1] = 29
            }
            else {
                DaysInMonths[1] = 28
            }

            
        default:
            month -= 1
        }
        GetStartDateDayPosition()
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        MonthlyCalendar.reloadData()
    }
    
    func GetStartDateDayPosition() {
        switch Direction{
        case 0:
            switch day {
            case 1...7:
                NumberOfEmptyBox = weekday - day
            case 8...14:
                NumberOfEmptyBox = weekday - day - 7
            case 15...21:
                NumberOfEmptyBox = weekday - day - 14
            case 22...28:
                NumberOfEmptyBox = weekday - day + 21
            case 29...31:
                NumberOfEmptyBox = weekday - day - 28
            default:
                break
            }
            PositionIndex = NumberOfEmptyBox
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthlyCalendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.yellow
        cell.DateLabel.textColor = UIColor.black
        if cell.isHidden {
            cell.isHidden = false
        }
        switch Direction {
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1...:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
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
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - PositionIndex == day {
            cell.backgroundColor = UIColor.red
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath)!
        cell.backgroundColor = UIColor.blue // タップしているときの色にする
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath)!
        if (indexPath.item == day) {
            cell.backgroundColor = UIColor.red
        }
        else {
            cell.backgroundColor = UIColor.yellow  // 元の色にする
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(month + 1)
        print(indexPath.item)
    }
}