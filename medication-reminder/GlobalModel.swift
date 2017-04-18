//
//  GlobalModel.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-16.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import UIKit

//******* DATAS *********//
var tabbarCounter = 0

struct Med {
    var id: String!
    var name: String!
    var dosage: String!
    var time: Date! //Orginal date -> yyyy-MM-dd'T'HH:mm:ss.SSSZ
    var timeParsed: Date! //Parsed date to -> YYYY-MM-DD HH:mm:ss
    var timeSimple: String! //Simple string from date -> YYYY-MM-DD
    
    var completed: Bool!
}

struct CompletedMed {
    var id: String!
    var name: String!
    var dosage: String!
    var time: Date! //Orginal date -> yyyy-MM-dd'T'HH:mm:ss.SSSZ
   // var timeParsed: Date! //Parsed date to -> YYYY-MM-DD HH:mm:ss
    //var timeSimple: String! //Simple string from date -> YYYY-MM-DD
    var timeClicked: String!
    var completed: Bool!
}

var meds = [Med]()
var todayMeds = [Med]()
var completed = [CompletedMed]()
var missed = [Med]()
//***** DATAS END**********/////


//******* TIME parsing *********//

//Formatting date to YYY-MM-DD HH:MM:ss
func dateParse (forDate date: String) -> Date {
    let deFormatter = DateFormatter()
    deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //deFormatter.timeZone = .current
    let startTime = deFormatter.date(from: date)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //let timeString = formatter.string(from: startTime!)
    let dateString = formatter.string(from: startTime!)
    
    
    let finformatter = DateFormatter()
    finformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //let timeString = formatter.string(from: startTime!)
    finformatter.timeZone = TimeZone(abbreviation:"GMT")
    let finalString = formatter.date(from: dateString)
    
    return finalString!
}

func dateParseForLabel (forDate date: Date) -> String {
    let deFormatter = DateFormatter()
    deFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    deFormatter.timeZone = TimeZone(abbreviation: "GMT")!
    //deFormatter.timeZone = .current
    let startTime = deFormatter.string(from: date)
    //print(startTime)
    return startTime
}

//Formatting date to YYYY-MM-DD -> String
func convertDateToSimple (date: Date) -> String {
    let deFormatter = DateFormatter()
    deFormatter.dateFormat = "yyyy-MM-dd"
    deFormatter.timeZone = TimeZone(abbreviation: "GMT")!
    let dateString = deFormatter.string(from: date)
    return dateString
}

//Get medication list for specific dat from Calendar
func getMedList(date: Date) -> [Med] {
   // print("In MEd LIST")
    //print(date)
    let dateString = convertDateToSimple(date: date)
    let temp = meds.filter {$0.timeSimple == dateString}
    return temp
    
}


func getMedListToday(date: Date) -> [Med] {
    let date = date.addingTimeInterval(-14400)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //formatter.timeZone = TimeZone(abbreviation: "EST")!
    let dateString = formatter.string(from: date)
    let formatter2 = DateFormatter()
    formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString2 = formatter.date(from: dateString)

    let tempMeds = getMedList(date: dateString2!)
    let todayMeds = tempMeds.filter({$0.timeParsed > dateString2!})
    
    return todayMeds
    
}


//******* TIME parsing END*********//

//******* Static UI Parameters*********//
let defaultLabel: UILabel = {
    var label = UILabel()
    label.textColor = UIColor.themeColor
    return label
} ()



