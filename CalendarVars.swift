//
//  CalenderVars.swift
//  Carender
//
//  Created by akazawa on 2019/10/23.
//  Copyright © 2019 tmsah. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let todaysDay = calendar.component(.day, from: date)
let todaysWeekday = calendar.component(.weekday, from: date) - 1

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

let Months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
let DaysOfMonth = ["月", "火", "水", "木", "金", "土", "日"]
var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var currentMonth = String()
var selectedDate = Date()



