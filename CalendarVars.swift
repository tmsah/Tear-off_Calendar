//
//  CalenderVars.swift
//  Carender
//
//  Copyright © 2019 tmsah. All rights reserved.
//

import Foundation

let today = Date()
let calendar = Calendar.current

let todaysDay = calendar.component(.day, from: today)
let todaysWeekday = calendar.component(.weekday, from: today) - 1

var month = calendar.component(.month, from: today) - 1
var year = calendar.component(.year, from: today)

var selectedDate = Date()

var firstDay = Date()
var lastDay = Date()

struct DayInfo : Codable {
    let day:      String
    let id:       String
    let person:   String
    let words:    String
    let tweetDay: String
    let color:    String
}

struct DatesInfo : Codable {
    let datesInfo: [DayInfo]
}

let DatesFile = Bundle.main.url(forResource: "DatesInfo", withExtension: "json")
let DatesJson = try! JSONDecoder().decode(DatesInfo.self, from: Data(contentsOf: DatesFile!)) as DatesInfo

let Colors: Dictionary<String,  Array<Int> > = [
    "red":     [230, 0, 0, 1],
    "blue":    [0, 0, 195, 1],
    "green":   [0, 210, 0, 1],
    "yellow":  [255, 200, 0, 1],
    "pink":    [255, 105, 140, 1],
    "orange":  [255, 125, 0, 1],
    "gray":    [130, 130, 130, 1],
    "skyblue": [0, 190, 190, 1],
    "purple":  [190, 0, 190, 1]
]
