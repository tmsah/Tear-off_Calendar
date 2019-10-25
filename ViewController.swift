//
//  ViewController.swift
//  Carender
//
//  Created by akazawa on 2019/10/13.
//  Copyright © 2019 tmsah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var weekdayLabel: UILabel!

    var dayCount = 0
    
    var images: [UIImage] = []
    var weekDays: [String] = []
    
    let today = Date(timeIntervalSinceNow: TimeInterval())
    var lastDay = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        lastDay = dateFormatter.date(from: "2021-01-01 00:00:00")!

        images = [UIImage(named: "sunday.jpg")!, UIImage(named: "monday.jpg")!, UIImage(named: "tuesday.jpg")!, UIImage(named: "wednesday.JPG")!, UIImage(named: "thursday.jpg")!, UIImage(named: "friday.jpg")!, UIImage(named: "saturday.jpg")!]
        weekDays = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
        showDate()
        
        gestureInitialize()
    }
    
    func showDate() {
        let seconds = TimeInterval(dayCount*24*60*60)
        let thisDay = Date(timeIntervalSinceNow: seconds)
        if (thisDay.compare(lastDay) == .orderedDescending) {
            print("カレンダーは終了しました．")
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
                
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: thisDay)
        yearLabel.text = year

        dateFormatter.dateFormat = "M"
        let month = dateFormatter.string(from: thisDay)
        monthLabel.text = month

        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: thisDay)
        dayLabel.text = day
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let WeekComponent = calendar.components(.weekday, from: thisDay)
        let weekDay = WeekComponent.weekday
        imageView.image = images[weekDay! - 1]
        weekdayLabel.text = weekDays[weekDay! - 1]
        
        switch(weekDay){
        case 1:
            dayLabel.textColor = UIColor.red
            weekdayLabel.textColor = UIColor.red
        case 7:
            dayLabel.textColor = UIColor.blue
            weekdayLabel.textColor = UIColor.blue
        default:
            dayLabel.textColor = UIColor.black
            weekdayLabel.textColor = UIColor.black
        }
    }
    
    func gestureInitialize() {
        /*let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(prevDay))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextDay))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)*/
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextDay))
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(prevDay))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc func prevDay() {
        dayCount -= 1
        UIView.beginAnimations("TransitionAnimation", context: nil)
        UIView.setAnimationTransition(UIView.AnimationTransition.curlDown, for: self.view, cache: true)
        UIView.setAnimationDuration(1)
        showDate()
        UIView.commitAnimations()
    }
    
    @objc func nextDay() {
        if dayCount < 0 {
            dayCount += 1
            UIView.beginAnimations("TransitionAnimation", context: nil)
            UIView.setAnimationTransition(UIView.AnimationTransition.curlUp, for: self.view, cache: true)
            UIView.setAnimationDuration(1)
            showDate()
            UIView.commitAnimations()
        }

    }

    @IBAction func goBack(_ segue:UIStoryboardSegue) {}

    @IBAction func goNext(_ sender:UIButton) {
        let next = storyboard!.instantiateViewController(withIdentifier: "nextView")
        self.present(next,animated: true, completion: nil)
    }

    // セグエ遷移用に追加 ↓↓↓
    @IBAction func goMonthlyBySegue(_ sender: Any) {
        performSegue(withIdentifier: "toMonthly", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
