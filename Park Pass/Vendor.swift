//
//  Vendor.swift
//  Park Pass
//
//  Created by Dennis Parussini on 11-06-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//Protocol to which every vendor type has to conform
protocol VendorType: EntrantType {
    var firstName: String { get }
    var lastName: String { get }
    var company: Company { get }
    var dateOfBirth: NSDate { get }
    var dateOfVisit: NSDate { get }
}

//Enum to differentiate between companies
enum Company {
    case Acme, Orkin, Fedex, NWElectrical
}

struct Vendor: VendorType {

    //MARK: - Properties
    var firstName: String
    var lastName: String
    var company: Company
    var dateOfBirth: NSDate
    var dateOfVisit: NSDate
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String?, lastName: String?, company: Company?, dateOfBirth: String?, dateOfVisit: String?) throws {
        guard let first = firstName, let last = lastName else { throw ParkError.MissingName }
        guard let company = company else { throw ParkError.MissingCompany }
        guard let birthday = dateOfBirth, let dateOfBirth = dateFormatter.dateFromString(birthday) else { throw ParkError.MissingDateOfBirth }
        guard let visitingDay = dateOfVisit, let dayOfVisit = dateFormatter.dateFromString(visitingDay) else { throw ParkError.MissingDateOfVisit }
        
        self.firstName = first
        self.lastName = last
        self.company = company
        self.dateOfBirth = dateOfBirth
        self.dateOfVisit = dayOfVisit
    }
}