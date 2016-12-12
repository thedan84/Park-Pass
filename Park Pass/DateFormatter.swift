//
//  DateFormatter.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 26-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//A simple dateformatter which converts the date to the right format
var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
}()
