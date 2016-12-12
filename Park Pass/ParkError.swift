//
//  ParkError.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 24-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//ErrorType enum
enum ParkError: Error {
    case missingName
    case missingAddress
    case missingSecurityNumber
    case missingDateOfBirth
    case missingType
    case missingPass
    case childOlderThanFive
    case missingProject
    case missingCompany
    case missingDateOfVisit
}
