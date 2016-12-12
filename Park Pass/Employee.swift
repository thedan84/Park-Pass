//
//  Employee.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 24-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//Protocol to which every type of employee has to conform
protocol Employable: EntrantType {
    var firstName: String { get }
    var lastName: String { get }
    var streetAddress: String { get }
    var city: String { get }
    var state: String { get }
    var zipCode: Int { get }
    var socialSecurityNumber: Int { get }
    var dateOfBirth: Date { get }
    var employeeType: EmployeeType { get }
}

//Enum to differentiate between the various Hourly Employee types
enum EmployeeType {
    case hourly, contract
}

enum WorkType {
    case foodServices, rideServices, maintenance
}

enum ProjectNumber {
    case oneThousandOne, oneThousandTwo, oneThousandThree, twoThousandOne, twoThousandTwo
}

struct HourlyEmployee: Employable {
    //MARK: - Properties
    var firstName: String
    var lastName: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: Int
    var socialSecurityNumber: Int
    var dateOfBirth: Date
    var employeeType: EmployeeType
    var workType: WorkType
    
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: Int?, socialSecurityNumber: Int?, dateOfBirth: String?, workType: WorkType?) throws {
        guard let first = firstName, let last = lastName else { throw ParkError.missingName }
        
        guard let address = streetAddress, let city = city, let state = state, let zip = zipCode else { throw ParkError.missingAddress }
        
        guard let security = socialSecurityNumber else { throw ParkError.missingSecurityNumber }
        
        guard let birthDate = dateOfBirth else { throw ParkError.missingDateOfBirth }
        
        guard let work = workType else { throw ParkError.missingType }
        
        self.firstName = first
        self.lastName = last
        self.streetAddress = address
        self.city = city
        self.state = state
        self.zipCode = zip
        self.socialSecurityNumber = security
        self.dateOfBirth = dateFormatter.date(from: birthDate)!
        self.employeeType = .hourly
        self.workType = work
    }
}

struct ContractEmployee: Employable {
    //MARK: - Properties
    var firstName: String
    var lastName: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: Int
    var socialSecurityNumber: Int
    var dateOfBirth: Date
    var projectNumber: ProjectNumber
    var employeeType: EmployeeType
    
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: Int?, socialSecurityNumber: Int?, dateOfBirth: String?, projectNumber: ProjectNumber?) throws {
        guard let first = firstName, let last = lastName else { throw ParkError.missingName }
        
        guard let address = streetAddress, let city = city, let state = state, let zip = zipCode else { throw ParkError.missingAddress }
        
        guard let security = socialSecurityNumber else { throw ParkError.missingSecurityNumber }
        
        guard let birthDate = dateOfBirth else { throw ParkError.missingDateOfBirth }
        
        guard let project = projectNumber else { throw ParkError.missingProject }
        
        self.firstName = first
        self.lastName = last
        self.streetAddress = address
        self.city = city
        self.state = state
        self.zipCode = zip
        self.socialSecurityNumber = security
        self.dateOfBirth = dateFormatter.date(from: birthDate)!
        self.employeeType = .contract
        self.projectNumber = project
    }
}
