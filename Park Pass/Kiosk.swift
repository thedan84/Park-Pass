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
    func createPassForEntrant(_ entrant: EntrantType) -> Pass
    func validateAreaAccessForPass(_ pass: Pass, andArea areas: AreaAccess) -> Bool
    func validateRideAccessForPass(_ pass: Pass, andRide rides: RideAccess) -> Bool
    func validateDiscountAccessForPass(_ pass: Pass, andDiscount discounts: Discount) -> Bool
}

struct Kiosk: KioskType {
    
    //Create a pass for the entrant type
    func createPassForEntrant(_ entrant: EntrantType) -> Pass {
        return Pass(entrant: entrant)
    }
    
    //Validates if the pass is allowed to access an Area, like Amusement and Maintenance Areas
    func validateAreaAccessForPass(_ pass: Pass, andArea area: AreaAccess) -> Bool {
        for access in pass.areaAccess {
            if access == area {
                return true
            }
        }
        return false
    }
    
    //Validates if the pass is allowed to access a ride, such as all rides or if the entrant is allowed to skip lines
    func validateRideAccessForPass(_ pass: Pass, andRide ride: RideAccess) -> Bool {
        for access in pass.rideAccess {
            if access == ride {
                return true
            }
        }
        return false
    }
    
    //Validates if the pass is allowed to receive a discount on food or merchandise
    func validateDiscountAccessForPass(_ pass: Pass, andDiscount discount: Discount) -> Bool {
        if let access = pass.discountAccess {
            for discountAccess in access {
                switch (discountAccess, discount) {
                case (let .discountOnFood(value1), let .discountOnFood(value2)):
                    if value1 == value2 {
                        return true
                    } else {
                        return false
                    }
                case (let .discountOnMerchandise(value1), let .discountOnMerchandise(value2)):
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
