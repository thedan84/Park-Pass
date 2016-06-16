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
    enum Type: String {
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
            case .Classic:
                self.type = Type.ClassicGuestPass.rawValue
            case .VIP:
                self.type = Type.VIPGuestPass.rawValue
            case .FreeChild:
                self.type = Type.ChildGuestPass.rawValue
            case .SeasonPass:
                self.type = Type.SeasonPass.rawValue
            case .Senior:
                self.type = Type.Senior.rawValue
            }

        case let employee as HourlyEmployee:
            self.entrantName = "\(employee.firstName) \(employee.lastName)"
            
            switch employee.workType {
            case .FoodServices:
                self.type = Type.FoodServicePass.rawValue
            case .RideServices:
                self.type = Type.RideServicePass.rawValue
            case .Maintenance:
                self.type = Type.MaintenancePass.rawValue
            }
            
        case let employee as ContractEmployee:
            self.entrantName = "\(employee.firstName) \(employee.lastName)"
            
            self.type = Type.Contractor.rawValue
        case let manager as Manager:
            self.entrantName = "\(manager.firstName) \(manager.lastName)"
            
            switch manager.managerType {
            case .GeneralManager:
                self.type = Type.GeneralManagerPass.rawValue
            case .SeniorManager:
                self.type = Type.SeniorManagerPass.rawValue
            case .ShiftManager:
                self.type = Type.ShiftManagerPass.rawValue
            }
            
        case let vendor as Vendor:
            self.entrantName = "\(vendor.firstName) \(vendor.lastName)"
            
            self.type = Type.Vendor.rawValue
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
    case AmusementAreas, KitchenAreas, RideControlAreas, MaintenanceAreas, OfficeAreas
    
    static func validateAccessForEntrant(entrant: EntrantType) -> [AreaAccess] {
        var access = [AreaAccess]()
        
        switch entrant {
        case is Guest: access = [.AmusementAreas]
        case let employee as HourlyEmployee:
            switch employee.workType {
            case .FoodServices: access = [.AmusementAreas, .KitchenAreas]
            case .RideServices: access = [.AmusementAreas, .RideControlAreas]
            case .Maintenance: access = [.AmusementAreas, .KitchenAreas, .RideControlAreas, .MaintenanceAreas]
            }
        case let employee as ContractEmployee:
            switch employee.projectNumber {
            case .oneThousandOne: access = [.AmusementAreas]
            case .oneThousandTwo: access = [.AmusementAreas, .MaintenanceAreas]
            case .oneThousandThree: access = [.AmusementAreas, .KitchenAreas, .MaintenanceAreas, .OfficeAreas]
            case .twoThousandOne: access = [.OfficeAreas]
            case .twoThousandTwo: access = [.KitchenAreas, .MaintenanceAreas]
            }
        case is Manager: access = [.AmusementAreas, .KitchenAreas, .RideControlAreas, .MaintenanceAreas, .OfficeAreas]
        case let vendor as Vendor:
            switch vendor.company {
            case .Acme: access = [.KitchenAreas]
            case .Orkin: access = [.AmusementAreas, .RideControlAreas, .KitchenAreas]
            case .Fedex: access = [.MaintenanceAreas, .OfficeAreas]
            case .NWElectrical: access = [.AmusementAreas, .RideControlAreas, .KitchenAreas, .MaintenanceAreas, .OfficeAreas]
            }
        default: break
        }
        
        return access
    }
}

//The RideAccess enum holds the different areas and validates which entrant is allowed access to which ride
enum RideAccess {
    case AllRides, SkipAllRideLines
    
    static func validateAccessForEntrant(entrant: EntrantType) -> [RideAccess] {
        var access = [RideAccess]()
        
        switch entrant {
        case let guest as Guest:
            switch guest.type {
            case .Classic, .FreeChild: access = [.AllRides]
            case .VIP, .SeasonPass, .Senior: access = [.AllRides, .SkipAllRideLines]
            }
        case is HourlyEmployee: access = [.AllRides]
        case let employee as ContractEmployee:
            switch employee.projectNumber {
            case .oneThousandOne: access = [.AllRides]
            case .oneThousandTwo: access = [.AllRides]
            case .oneThousandThree: access = [.AllRides]
            default: break
            }
        case is Manager: access = [.AllRides]
        default: break
        }
        
        return access
    }
}

//The Discount enum holds the different areas and validates which entrant is allowed access to which discount
enum Discount {
    case DiscountOnFood(discount: Int)
    case DiscountOnMerchandise(discount: Int)
    
    static func validateAccessForEntrant(entrant: EntrantType) -> [Discount]? {
        var access: [Discount]?
        
        switch entrant {
        case let guest as Guest:
            switch guest.type {
            case .VIP, .SeasonPass: access = [.DiscountOnFood(discount: 10), .DiscountOnMerchandise(discount: 20)]
            case .Senior: access = [.DiscountOnFood(discount: 10), .DiscountOnMerchandise(discount: 10)]
            default: access = nil
            }
        case is HourlyEmployee: access = [.DiscountOnFood(discount: 15), .DiscountOnMerchandise(discount: 25)]
        case is Manager: access = [.DiscountOnFood(discount: 25), .DiscountOnMerchandise(discount: 25)]
        default: break
        }
        
        return access
    }
    
}