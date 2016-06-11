//
//  Vendor.swift
//  Park Pass
//
//  Created by Dennis Parussini on 11-06-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

protocol VendorType: EntrantType {
    var firstName: String { get }
    var lastName: String { get }
    var company: String { get }
    var dateOfBirth: NSDate { get }
    var dateOfVisit: NSDate { get }
}

struct Vendor: VendorType {
    var firstName: String
    var lastName: String
    var company: String
    var dateOfBirth: NSDate
    var dateOfVisit: NSDate
    var pass: Pass?
    
    init(firstName: String?, lastName: String?, company: String?, dateOfBirth: String?) throws {
        guard let first = firstName, let last = lastName else { throw ParkError.MissingName }
        guard let company = company else { throw ParkError.MissingCompany }
        guard let birthday = dateOfBirth else { throw ParkError.MissingDateOfBirth }
        
        self.firstName = first
        self.lastName = last
        self.company = company
        self.dateOfBirth = dateFormatter.dateFromString(birthday)!
        self.dateOfVisit = NSDate()
    }
}