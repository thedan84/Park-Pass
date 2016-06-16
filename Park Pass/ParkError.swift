//
//  ParkError.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 24-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//ErrorType enum
enum ParkError: ErrorType {
    case MissingName
    case MissingAddress
    case MissingSecurityNumber
    case MissingDateOfBirth
    case MissingType
    case MissingPass
    case ChildOlderThanFive
    case MissingProject
    case MissingCompany
    case MissingDateOfVisit
}