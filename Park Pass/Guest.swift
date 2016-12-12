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
    case classic, vip, freeChild, seasonPass, senior
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
    var birthday: Date?
    var pass: Pass?
    
    //MARK: - Initialization
    init(firstName: String? = nil, lastName: String? = nil, streetAddress: String? = nil, city: String? = nil, state: String? = nil, zipCode: Int? = nil, dateOfBirth: String?, guestType: GuestType) throws {
        
        //Helper method to determine if the guest is younger than five years old and allowed to enter as a 'Free Child' guest
        func isYoungerThanFiveYearsOld(_ birthyear: Date) -> Bool {
            let today = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components(.year, from: birthyear, to: today, options: .matchFirst)
            
            if components.year! <= 5 {
                return true
            } else {
                return false
            }
        }
        
        switch guestType {
        case .freeChild:
            guard let birthday = dateOfBirth else { throw ParkError.missingDateOfBirth }
            
            guard let birthyear = dateFormatter.date(from: birthday) else { throw ParkError.missingDateOfBirth }
            
            self.birthday = birthyear
            
            if isYoungerThanFiveYearsOld(birthyear) {
                self.type = .freeChild
            } else {
                throw ParkError.childOlderThanFive
            }
        case .seasonPass:
            guard let first = firstName, let last = lastName else { throw ParkError.missingName }
            guard let street = streetAddress, let city = city, let state = state, let zip = zipCode else { throw ParkError.missingAddress }
            
            guard let birthday = dateOfBirth else { throw ParkError.missingDateOfBirth }

            guard let birthyear = dateFormatter.date(from: birthday) else { throw ParkError.missingDateOfBirth }

            self.birthday = birthyear
            self.firstName = first
            self.lastName = last
            self.streetAddress = street
            self.city = city
            self.state = state
            self.zipCode = zip
            self.type = guestType
            
        case .senior:
            guard let first = firstName, let last = lastName else { throw ParkError.missingName }
            guard let birthday = dateOfBirth else { throw ParkError.missingDateOfBirth }
            
            guard let birthyear = dateFormatter.date(from: birthday) else { throw ParkError.missingDateOfBirth }
            self.firstName = first
            self.lastName = last
            self.birthday = birthyear
            self.type = .senior
        default: self.type = guestType
        }
    }
}
