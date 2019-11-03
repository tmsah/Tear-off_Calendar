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


let Colors: Dictionary<String,  Array<Int> > = [
    "red":     [1, 1, 1, 1],
    "blue":    [1, 1, 1, 1],
    "green":   [177, 194, 57, 1],
    "yellow":  [1, 1, 1, 1],
    "pink":    [1, 1, 1, 1],
    "orange":  [1, 1, 1, 1],
    "gray":    [1, 1, 1, 1],
    "skyblue": [1, 1, 1, 1],
    "purple":  [1, 1, 1, 1]
]
