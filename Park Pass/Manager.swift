//
//  Manager.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 24-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//Protocol to which every manager type has to conform
protocol ManagerType: EntrantType {
    var firstName: String { get }
    var lastName: String { get }
    var streetAddress: String { get }
    var city: String { get }
    var state: String { get }
    var zipCode: Int { get }
    var socialSecurityNumber: Int { get }
    var dateOfBirth: NSDate { get }
    var managerType: ManagementTier { get }
}

//Enum to differentiate between the various Manager types
enum ManagementTier {
    case ShiftManager, GeneralManager, SeniorManager
}

struct Manager: ManagerType {
    
    //MARK: - Properties
    var firstName: String
    var lastName: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: Int
    var socialSecurityNumber: Int
    var dateOfBirth: NSDate
    var managerType: ManagementTier
    
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: Int?, socialSecurityNumber: Int?, dateOfBirth: String?, managerType: ManagementTier?) throws {
        guard let first = firstName, let last = lastName else { throw ParkError.MissingName }
        
        guard let address = streetAddress, let city = city, let state = state, let zip = zipCode else { throw ParkError.MissingAddress }
        
        guard let security = socialSecurityNumber else { throw ParkError.MissingSecurityNumber }
        
        guard let birthDate = dateOfBirth else { throw ParkError.MissingDateOfBirth }
        
        guard let type = managerType else { throw ParkError.MissingType }
        
        self.firstName = first
        self.lastName = last
        self.streetAddress = address
        self.city = city
        self.state = state
        self.zipCode = zip
        self.socialSecurityNumber = security
        self.dateOfBirth = dateFormatter.dateFromString(birthDate)!
        self.managerType = type
    }
}