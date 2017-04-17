//
//  GlobalModel.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-16.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

var tabbarCounter = 0
var profiles = [[String:Any]]()
var missed = [[String:Any]]()

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

//Formatting date to YYYY-MM-DD to compare in Calendar
func dateParseSimpleFormat (forDate date: String) -> String {
    let deFormatter = DateFormatter()
    deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //deFormatter.timeZone = .current
    let startTime = deFormatter.date(from: date)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    //let timeString = formatter.string(from: startTime!)
    let dateString = formatter.string(from: startTime!)
    return dateString
}
