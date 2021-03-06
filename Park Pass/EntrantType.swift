//
//  GuestType.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 20-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//The EntrantType protocol to wich every entrant has to conform
protocol EntrantType {
    var pass: Pass? { get set }
    func swipePass(forArea area: AreaAccess, result: (Bool) -> Void) throws
    func swipePass(forRide ride: RideAccess, result: (Bool) -> Void) throws
    func swipePass(forDiscount discount: Discount, result: (Bool) -> Void) throws
}

//Extension to give a default swipe implementation to every type which conforms to the EntrantType protocol
extension EntrantType {
    
    //Swipe the pass at an area, to get access to amusement or maintenance areas
    func swipePass(forArea area: AreaAccess, result: (Bool) -> Void) throws {
        guard let pass = pass else { throw ParkError.missingPass }
        
        let kiosk = Kiosk()
        var sound = Sound()

        if kiosk.validateAreaAccessForPass(pass, andArea: area) {
            print("Access Granted to: \(area)")
            sound.playAccessGrantedSound()
            hasGuestBirthday()
            result(true)
        } else {
            print("Access NOT Granted to :\(area)")
            sound.playAccessDeniedSound()
            result(false)
        }
    }
    
    //Swipe the pass at a ride, to get access to rides or skip lines
    func swipePass(forRide ride: RideAccess, result: (Bool) -> Void) throws {
        guard let pass = pass else { throw ParkError.missingPass }
        
        let kiosk = Kiosk()
        var sound = Sound()
        
        if kiosk.validateRideAccessForPass(pass, andRide: ride) {
            print("Access Granted to: \(ride)")
            sound.playAccessGrantedSound()
            hasGuestBirthday()
            result(true)
        } else {
            print("Access NOT Granted to: \(ride)")
            sound.playAccessDeniedSound()
            result(false)
        }
    }
    
    //Swipe the pass at a shop or eatery, to get discounts on food and/or merchandise
    func swipePass(forDiscount discount: Discount, result: (Bool) -> Void) throws {
        guard let pass = pass else { throw ParkError.missingPass }
        
        let kiosk = Kiosk()
        var sound = Sound()
        
        if kiosk.validateDiscountAccessForPass(pass, andDiscount: discount) {
            switch discount {
            case let .discountOnFood(value) :
                print("Discount Granted for \(value)% off of food")
                sound.playAccessGrantedSound()
                hasGuestBirthday()
                result(true)
            case let .discountOnMerchandise(value):
                print("Discount Granted for \(value)% off of merchandise")
                sound.playAccessGrantedSound()
                hasGuestBirthday()
                result(true)
            }
        } else {
            switch discount {
            case let .discountOnFood(value):
                print("Discount NOT Granted for \(value)% off of food")
                sound.playAccessDeniedSound()
                result(false)
            case let .discountOnMerchandise(value):
                print("Discount NOT Granted for \(value)% off of merchandise")
                sound.playAccessDeniedSound()
                result(false)
            }
        }
    }
    
    //Private function to check if the entrant's birthday is on the day
    fileprivate func hasGuestBirthday() {
        switch self {
        case let guest as Guest:
            if let birthday = guest.birthday {
                
                let calendar = Calendar.current
                let todayComponents = (calendar as NSCalendar).components([.month, .day], from: Date())
                let birthdayComponents = (calendar as NSCalendar).components([.month, .day], from: birthday as Date)
                
                if todayComponents.month == birthdayComponents.month && todayComponents.day == birthdayComponents.day {
                    print("Happy Birthday")
                }
                
            }
        case let employee as HourlyEmployee:
            let birthday = employee.dateOfBirth
            
            let calendar = Calendar.current
            
            let todayComponents = (calendar as NSCalendar).components([.month, .day], from: Date())
            let birthdayComponents = (calendar as NSCalendar).components([.month, .day], from: birthday as Date)
            
            if todayComponents.month == birthdayComponents.month && todayComponents.day == birthdayComponents.day {
                print("Happy Birthday")
            }
        case let employee as ContractEmployee:
            let birthday = employee.dateOfBirth
            
            let calendar = Calendar.current
            
            let todayComponents = (calendar as NSCalendar).components([.month, .day], from: Date())
            let birthdayComponents = (calendar as NSCalendar).components([.month, .day], from: birthday as Date)
            
            if todayComponents.month == birthdayComponents.month && todayComponents.day == birthdayComponents.day {
                print("Happy Birthday")
            }
        case let manager as Manager:
            let birthday = manager.dateOfBirth
                
            let calendar = Calendar.current
            let todayComponents = (calendar as NSCalendar).components([.month, .day], from: Date())
            let birthdayComponents = (calendar as NSCalendar).components([.month, .day], from: birthday as Date)
            
            if todayComponents.month == birthdayComponents.month && todayComponents.day == birthdayComponents.day {
                print("Happy Birthday")
            }
        case let vendor as Vendor:
            let birthday = vendor.dateOfBirth
            
            let calendar = Calendar.current
            let todayComponents = (calendar as NSCalendar).components([.month, .day], from: Date())
            let birthdayComponents = (calendar as NSCalendar).components([.month, .day], from: birthday as Date)
            
            if todayComponents.month == birthdayComponents.month && todayComponents.day == birthdayComponents.day {
                print("Happy Birthday")
            }
        default: break
        }
    }
}
