//
//  ViewController.swift
//  Carender
//
//  Copyright © 2019 tmsah. All rights reserved.
//

import UIKit
extension UIView {
    /// 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    /// 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    /// 角丸の大きさ
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
  /// 影の色
  @IBInspectable var shadowColor: UIColor? {
    get {
      return layer.shadowColor.map { UIColor(cgColor: $0) }
    }
    set {
      layer.shadowColor = newValue?.cgColor
      layer.masksToBounds = false
    }
  }
  /// 影の透明度
  @IBInspectable var shadowAlpha: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  /// 影のオフセット
  @IBInspectable var shadowOffset: CGSize {
    get {
     return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  /// 影のぼかし量
  @IBInspectable var shadowRadius: CGFloat {
    get {
     return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
}

extension UIColor {
    class func rgba(color: String) -> UIColor{
        if let c = Colors[color] {
            return UIColor(red: CGFloat(c[0]) / 255.0, green: CGFloat(c[1]) / 255.0, blue: CGFloat(c[2]) / 255.0, alpha: CGFloat(c[3]))
        }
        else {
            return UIColor.clear
        }
    }
}

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
    
    let weekDays = ["日", "月", "火", "水", "木", "金", "土"]

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

        showDate(thisDay: today)
//        thisDay = today

        gestureInitialize()
//        toMonthlyButton.isHidden = true
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
        
/*        switch(weekDay){
        case 1:
            dayLabel.textColor = UIColor.red
            weekdayLabel.textColor = UIColor.red
        case 7:
            dayLabel.textColor = UIColor.blue
            weekdayLabel.textColor = UIColor.blue
        default:
            dayLabel.textColor = UIColor.black
            weekdayLabel.textColor = UIColor.black
        }*/
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

