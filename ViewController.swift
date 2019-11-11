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
    @IBOutlet weak var toMonthlyButtonView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    

    var selectedDate = Date()
    var isCover = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        firstDay = dateFormatter.date(from: "2018-12-31")!
        lastDay = dateFormatter.date(from: "2020-01-01")!

        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: thisDay)
        coverInitialize(month: month)

        gestureInitialize()
    }
    
    func coverInitialize(month: String) {
        yearLabel.text = ""
        monthLabel.text = ""
        dayLabel.text = ""
        weekdayLabel.text = ""
        personLabel.text = "こゆみ物語"
        tweetDayLabel.text = ""
        if (thisDay.compare(lastDay) == .orderedDescending) {
            thisDay = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: lastDay))!
            wordsLabel.text = ("日めくりカレンダーは終了しました．")
            imageView.image = UIImage(named: "end")!
            baseView.backgroundColor = UIColor.rgba(color: "blue")
            toMonthlyButton.setTitleColor(UIColor.rgba(color: "blue"), for: .normal)
            return
        }
        let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: thisDay))!
        wordsLabel.text = ""
        imageView.image = nil
        toMonthlyButton.isHidden = true
        toMonthlyButtonView.isHidden = true
        thisDay = yesterday
        coverImageView.image = UIImage(named: month + "-cover")!
    }
    
    func showDate(thisDay: Date) {
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

        dateFormatter.dateFormat = "MM-dd"
        let wordsInfo = getWordsInfo(day: dateFormatter.string(from: thisDay))
        personLabel.text = wordsInfo.person
        wordsLabel.text = wordsInfo.words
        tweetDayLabel.text = wordsInfo.tweetDay
        imageView.image = UIImage(named: wordsInfo.id)!
        baseView.backgroundColor = UIColor.rgba(color: wordsInfo.color)
        
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let WeekComponent = calendar.components(.weekday, from: thisDay)
        let weekDay = WeekComponent.weekday
        weekdayLabel.text = weekDays[weekDay! - 1]
        
        toMonthlyButton.setTitleColor(UIColor.rgba(color: wordsInfo.color), for: .normal)
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
    
    func gestureInitialize() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextDay))
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(prevDay))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc func prevDay() {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: thisDay))!
        if (yesterday.compare(firstDay) == .orderedDescending && yesterday.compare(lastDay) == .orderedAscending && !isCover) {
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
            toMonthlyButton.isHidden = false
            toMonthlyButtonView.isHidden = false
            isCover = false
            coverImageView.image = nil
            UIView.commitAnimations()
        }

    }

    @IBAction func goBack(_ segue:UIStoryboardSegue) {  //　戻ってきたときに呼ばれる
        showDate(thisDay: selectedDate)
        isCover = false
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

