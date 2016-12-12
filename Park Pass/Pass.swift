//
//  Pass.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 26-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

//The PassType protocol to which every Pass has to conform
protocol PassType {
    var image: UIImage? { get }
    var type: String? { get }
    var entrantName: String? { get }
    var areaAccess: [AreaAccess] { get }
    var rideAccess: [RideAccess] { get }
    var discountAccess: [Discount]? { get }
}

struct Pass: PassType {
    //MARK: - Properties
    var image: UIImage?
    var type: String?
    var entrantName: String?
    var areaAccess: [AreaAccess]
    var rideAccess: [RideAccess]
    var discountAccess: [Discount]?
    
    //MARK: - Helper enum
    //The Type enum provides the type of pass the entrant gets
    enum GuestType: String {
        case ClassicGuestPass = "Classic Guest Pass"
        case ChildGuestPass = "Child Guest Pass"
        case SeasonPass = "Season Pass Owner"
        case Senior = "Senior Guest"
        case VIPGuestPass = "VIP Guest Pass"
        case FoodServicePass = "Food Services Pass"
        case RideServicePass = "Ride Services Pass"
        case MaintenancePass = "Maintenance Services Pass"
        case ShiftManagerPass = "Shift Manager Pass"
        case GeneralManagerPass = "General Manager Pass"
        case SeniorManagerPass = "Senior Manager Pass"
        case Vendor = "Vendor"
        case Contractor = "Contractor"
    }
    
    //MARK: - Initialization
    //Initialization is done via the EntrantType protocol. Switches allow to intialize the Pass with the correct entrant type.
    init(entrant: EntrantType) {
        switch entrant {
        case let guest as Guest:
            self.entrantName = nil
            
            switch guest.type {
            case .classic:
                self.type = GuestType.ClassicGuestPass.rawValue
            case .vip:
                self.type = GuestType.VIPGuestPass.rawValue
            case .freeChild:
                self.type = GuestType.ChildGuestPass.rawValue
            case .seasonPass:
                self.type = GuestType.SeasonPass.rawValue
            case .senior:
                self.type = GuestType.Senior.rawValue
            }

        case let employee as HourlyEmployee:
            self.entrantName = "\(employee.firstName) \(employee.lastName)"
            
            switch employee.workType {
            case .foodServices:
                self.type = GuestType.FoodServicePass.rawValue
            case .rideServices:
                self.type = GuestType.RideServicePass.rawValue
            case .maintenance:
                self.type = GuestType.MaintenancePass.rawValue
            }
            
        case let employee as ContractEmployee:
            self.entrantName = "\(employee.firstName) \(employee.lastName)"
            
            self.type = GuestType.Contractor.rawValue
        case let manager as Manager:
            self.entrantName = "\(manager.firstName) \(manager.lastName)"
            
            switch manager.managerType {
            case .generalManager:
                self.type = GuestType.GeneralManagerPass.rawValue
            case .seniorManager:
                self.type = GuestType.SeniorManagerPass.rawValue
            case .shiftManager:
                self.type = GuestType.ShiftManagerPass.rawValue
            }
            
        case let vendor as Vendor:
            self.entrantName = "\(vendor.firstName) \(vendor.lastName)"
            
            self.type = GuestType.Vendor.rawValue
        default: break
        }
        
        //Assign the right access to the properties
        self.areaAccess = AreaAccess.validateAccessForEntrant(entrant)
        self.rideAccess = RideAccess.validateAccessForEntrant(entrant)
        self.discountAccess = Discount.validateAccessForEntrant(entrant)
    }
}

//MARK: - Access Enums
//The AreaAccess enum holds the different areas and validates which entrant is allowed access to which area
enum AreaAccess {
    case amusementAreas, kitchenAreas, rideControlAreas, maintenanceAreas, officeAreas
    
    static func validateAccessForEntrant(_ entrant: EntrantType) -> [AreaAccess] {
        var access = [AreaAccess]()
        
        switch entrant {
        case is Guest: access = [.amusementAreas]
        case let employee as HourlyEmployee:
            switch employee.workType {
            case .foodServices: access = [.amusementAreas, .kitchenAreas]
            case .rideServices: access = [.amusementAreas, .rideControlAreas]
            case .maintenance: access = [.amusementAreas, .kitchenAreas, .rideControlAreas, .maintenanceAreas]
            }
        case let employee as ContractEmployee:
            switch employee.projectNumber {
            case .oneThousandOne: access = [.amusementAreas]
            case .oneThousandTwo: access = [.amusementAreas, .maintenanceAreas]
            case .oneThousandThree: access = [.amusementAreas, .kitchenAreas, .maintenanceAreas, .officeAreas]
            case .twoThousandOne: access = [.officeAreas]
            case .twoThousandTwo: access = [.kitchenAreas, .maintenanceAreas]
            }
        case is Manager: access = [.amusementAreas, .kitchenAreas, .rideControlAreas, .maintenanceAreas, .officeAreas]
        case let vendor as Vendor:
            switch vendor.company {
            case .acme: access = [.kitchenAreas]
            case .orkin: access = [.amusementAreas, .rideControlAreas, .kitchenAreas]
            case .fedex: access = [.maintenanceAreas, .officeAreas]
            case .nwElectrical: access = [.amusementAreas, .rideControlAreas, .kitchenAreas, .maintenanceAreas, .officeAreas]
            }
        default: break
        }
        
        return access
    }
}

//The RideAccess enum holds the different areas and validates which entrant is allowed access to which ride
enum RideAccess {
    case allRides, skipAllRideLines
    
    static func validateAccessForEntrant(_ entrant: EntrantType) -> [RideAccess] {
        var access = [RideAccess]()
        
        switch entrant {
        case let guest as Guest:
            switch guest.type {
            case .classic, .freeChild: access = [.allRides]
            case .vip, .seasonPass, .senior: access = [.allRides, .skipAllRideLines]
            }
        case is HourlyEmployee: access = [.allRides]
        case let employee as ContractEmployee:
            switch employee.projectNumber {
            case .oneThousandOne: access = [.allRides]
            case .oneThousandTwo: access = [.allRides]
            case .oneThousandThree: access = [.allRides]
            default: break
            }
        case is Manager: access = [.allRides]
        default: break
        }
        
        return access
    }
}

//The Discount enum holds the different areas and validates which entrant is allowed access to which discount
enum Discount {
    case discountOnFood(discount: Int)
    case discountOnMerchandise(discount: Int)
    
    static func validateAccessForEntrant(_ entrant: EntrantType) -> [Discount]? {
        var access: [Discount]?
        
        switch entrant {
        case let guest as Guest:
            switch guest.type {
            case .vip, .seasonPass: access = [.discountOnFood(discount: 10), .discountOnMerchandise(discount: 20)]
            case .senior: access = [.discountOnFood(discount: 10), .discountOnMerchandise(discount: 10)]
            default: access = nil
            }
        case is HourlyEmployee: access = [.discountOnFood(discount: 15), .discountOnMerchandise(discount: 25)]
        case is Manager: access = [.discountOnFood(discount: 25), .discountOnMerchandise(discount: 25)]
        default: break
        }
        
        return access
    }
    
}
