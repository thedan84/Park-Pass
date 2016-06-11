//
//  Kiosk.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 26-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

//The KioskType protocol to which every type of kiosk has to conform
protocol KioskType {
    func createPassForEntrant(entrant: EntrantType) -> Pass
    func validateAreaAccessForPass(pass: Pass, andArea areas: AreaAccess) -> Bool
    func validateRideAccessForPass(pass: Pass, andRide rides: RideAccess) -> Bool
    func validateDiscountAccessForPass(pass: Pass, andDiscount discounts: Discount) -> Bool
}

struct Kiosk: KioskType {
    
    //Create a pass for the entrant type
    func createPassForEntrant(entrant: EntrantType) -> Pass {
        return Pass(entrant: entrant)
    }
    
    //Validates if the pass is allowed to access an Area, like Amusement and Maintenance Areas
    func validateAreaAccessForPass(pass: Pass, andArea area: AreaAccess) -> Bool {
        for access in pass.areaAccess {
            if access == area {
                return true
            }
        }
        return false
    }
    
    //Validates if the pass is allowed to access a ride, such as all rides or if the entrant is allowed to skip lines
    func validateRideAccessForPass(pass: Pass, andRide ride: RideAccess) -> Bool {
        for access in pass.rideAccess {
            if access == ride {
                return true
            }
        }
        return false
    }
    
    //Validates if the pass is allowed to receive a discount on food or merchandise
    func validateDiscountAccessForPass(pass: Pass, andDiscount discount: Discount) -> Bool {
        if let access = pass.discountAccess {
            for discountAccess in access {
                switch (discountAccess, discount) {
                case (let .DiscountOnFood(value1), let .DiscountOnFood(value2)):
                    if value1 == value2 {
                        return true
                    } else {
                        return false
                    }
                case (let .DiscountOnMerchandise(value1), let .DiscountOnMerchandise(value2)):
                    if value1 == value2 {
                        return true
                    } else {
                        return false
                    }
                default: break
                }
            }            
        }
        return false
    }
}