//
//  Guest.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 24-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//Enum with the different types of guests
enum GuestType {
    case Classic, VIP, FreeChild, SeasonPass, Senior
}

struct Guest: EntrantType {
    //MARK: - Properties
    var firstName: String? = nil
    var lastName: String? = nil
    var streetAddress: String? = nil
    var city: String? = nil
    var state: String? = nil
    var zipCode: Int? = nil
    
    var type: GuestType
    var birthday: NSDate?
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String? = nil, lastName: String? = nil, streetAddress: String? = nil, city: String? = nil, state: String? = nil, zipCode: Int? = nil, dateOfBirth: String?, guestType: GuestType) throws {
        
        //Helper method to determine if the guest is younger than five years old and allowed to enter as a 'Free Child' guest
        func isYoungerThanFiveYearsOld(birthyear: NSDate) -> Bool {
            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Year, fromDate: birthyear, toDate: today, options: .MatchFirst)
            
            if components.year <= 5 {
                return true
            } else {
                return false
            }
        }
        
        switch guestType {
        case .FreeChild:
            guard let birthday = dateOfBirth else { throw ParkError.MissingDateOfBirth }
            
            guard let birthyear = dateFormatter.dateFromString(birthday) else { throw ParkError.MissingDateOfBirth }
            
            self.birthday = birthyear
            
            if isYoungerThanFiveYearsOld(birthyear) {
                self.type = .FreeChild
            } else {
                throw ParkError.ChildOlderThanFive
            }
        case .SeasonPass:
            guard let first = firstName, let last = lastName else { throw ParkError.MissingName }
            guard let street = streetAddress, let city = city, let state = state, let zip = zipCode else { throw ParkError.MissingAddress }
            
            guard let birthday = dateOfBirth else { throw ParkError.MissingDateOfBirth }

            guard let birthyear = dateFormatter.dateFromString(birthday) else { throw ParkError.MissingDateOfBirth }

            self.birthday = birthyear
            self.firstName = first
            self.lastName = last
            self.streetAddress = street
            self.city = city
            self.state = state
            self.zipCode = zip
            self.type = guestType
            
        case .Senior:
            guard let first = firstName, let last = lastName else { throw ParkError.MissingName }
            guard let birthday = dateOfBirth else { throw ParkError.MissingDateOfBirth }
            
            guard let birthyear = dateFormatter.dateFromString(birthday) else { throw ParkError.MissingDateOfBirth }
            self.firstName = first
            self.lastName = last
            self.birthday = birthyear
            self.type = .Senior
        default: self.type = .Classic
        }
    }
    
//    init(firstName: String?, lastName: String?, streetAddress: String? = nil, city: String? = nil, state: String? = nil, zipCode: Int? = nil, dateOfBirth: String?, guestType: GuestType) throws {
//        
//        guard let first = firstName, let last = lastName else { throw ParkError.MissingName }
//        guard let street = streetAddress, let city = city, let state = state, let zip = zipCode else { throw ParkError.MissingAddress }
//        guard let birthDate = dateOfBirth else { throw ParkError.MissingDateOfBirth }
//        
//        self.firstName = first
//        self.lastName = last
//        guard let birthday = dateFormatter.dateFromString(birthDate) else { throw ParkError.MissingDateOfBirth }
//        
//        self.birthday = birthday
//        
//        switch guestType {
//        case .SeasonPass:
//            self.streetAddress = street
//            self.city = city
//            self.state = state
//            self.zipCode = zip
//            self.type = guestType
//        case .Senior:
//            self.type = guestType
//        default: self.type = guestType
//        }
//    }
}