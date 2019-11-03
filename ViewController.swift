//
//  ViewController.swift
//  Carender
//
//  Copyright © 2019 tmsah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var weekdayLabel: UILabel!
    @IBOutlet var toMonthlyButton: UIButton!
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var tweetDayLabel: UILabel!
    
    var images: [UIImage] = []
    var weekDays: [String] = []
    
    let today = Date()

    var selectedDate = Date()
    var thisDay = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        firstDay = dateFormatter.date(from: "2018-12-31")!
        lastDay = dateFormatter.date(from: "2020-01-01")!

        images = [UIImage(named: "sunday.jpg")!, UIImage(named: "monday.jpg")!, UIImage(named: "tuesday.jpg")!, UIImage(named: "wednesday.JPG")!, UIImage(named: "thursday.jpg")!, UIImage(named: "friday.jpg")!, UIImage(named: "saturday.jpg")!]
        weekDays = ["日", "月", "火", "水", "木", "金", "土"]
        showDate(thisDay: today)
//        thisDay = today
        baseView.backgroundColor = UIColor.lightGray

        gestureInitialize()
//        toMonthlyButton.isHidden = true
        let file = Bundle.main.url(forResource: "DatesInfo", withExtension: "json")
        let data = try? Data(contentsOf: file!)
        let json = try! JSONDecoder().decode(DatesInfo.self, from: data!) as DatesInfo
        print(json.datesInfo[1].day)
    }
    func showDate(thisDay: Date) {
        if (thisDay.compare(firstDay) == .orderedAscending) {
            print("カレンダーは開始していません．")
        }
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
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextDay))
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(prevDay))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc func prevDay() {  //todo: 表紙の時はめくれない設定
        let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: thisDay))!
        if (yesterday.compare(firstDay) == .orderedDescending) {
            UIView.beginAnimations("TransitionAnimation", context: nil)
            UIView.setAnimationTransition(UIView.AnimationTransition.curlDown, for: self.view, cache: true)
            UIView.setAnimationDuration(1)
            showDate(thisDay: yesterday)
            thisDay = yesterday
            UIView.commitAnimations()
        }
    }
    
    @objc func nextDay() {
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: thisDay))!
        if (tomorrow.compare(today) == .orderedAscending && tomorrow.compare(lastDay) == .orderedAscending) {
            UIView.beginAnimations("TransitionAnimation", context: nil)
            UIView.setAnimationTransition(UIView.AnimationTransition.curlUp, for: self.view, cache: true)
            UIView.setAnimationDuration(1)
            showDate(thisDay: tomorrow)
            thisDay = tomorrow
//            toMonthlyButton.isHidden = false
            UIView.commitAnimations()
        }

    }

    @IBAction func goBack(_ segue:UIStoryboardSegue) {  //　戻ってきたときに呼ばれる
        showDate(thisDay: selectedDate)
        thisDay = selectedDate
    }

    // セグエ遷移用に追加 ↓↓↓
    @IBAction func goMonthlyBySegue(_ sender: Any) {
        performSegue(withIdentifier: "toMonthly", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMonthly" {
            let vc = segue.destination as! MonthlyViewController
            vc.thisDay = thisDay
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

