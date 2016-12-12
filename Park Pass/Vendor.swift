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
    var dateOfBirth: Date { get }
    var dateOfVisit: Date { get }
}

//Enum to differentiate between companies
enum Company {
    case acme, orkin, fedex, nwElectrical
}

struct Vendor: VendorType {

    //MARK: - Properties
    var firstName: String
    var lastName: String
    var company: Company
    var dateOfBirth: Date
    var dateOfVisit: Date
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String?, lastName: String?, company: Company?, dateOfBirth: String?, dateOfVisit: String?) throws {
        guard let first = firstName, let last = lastName else { throw ParkError.missingName }
        guard let company = company else { throw ParkError.missingCompany }
        guard let birthday = dateOfBirth, let dateOfBirth = dateFormatter.date(from: birthday) else { throw ParkError.missingDateOfBirth }
        guard let visitingDay = dateOfVisit, let dayOfVisit = dateFormatter.date(from: visitingDay) else { throw ParkError.missingDateOfVisit }
        
        self.firstName = first
        self.lastName = last
        self.company = company
        self.dateOfBirth = dateOfBirth
        self.dateOfVisit = dayOfVisit
    }
}
