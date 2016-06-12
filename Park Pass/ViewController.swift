//
//  ViewController.swift
//  Park Pass
//
//  Created by Dennis Parussini on 09-06-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var securityNumberTextField: UITextField!
    @IBOutlet weak var projectNumberTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var stateNameTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet weak var guestView: UIView!
    @IBOutlet weak var employeeView: UIView!
    @IBOutlet weak var managerView: UIView!
    
    @IBOutlet var allTextFields: [UITextField]!
    @IBOutlet var onlyDateOfBirthRequiredFields: [UITextField]!
    @IBOutlet var hourlyEmployeeRequiredFields: [UITextField]!
    @IBOutlet var managerRequiredFields: [UITextField]!
    @IBOutlet var seasonPassRequiredFields: [UITextField]!
    @IBOutlet var seniorGuestRequiredFields: [UITextField]!
    @IBOutlet var contractEmployeeRequiredFields: [UITextField]!
    @IBOutlet weak var vendorRequiredFields: UITextField!
    
    let kiosk = Kiosk()
    var guest: EntrantType?
    
    var selectedEntrant: String?
    
    var selectedEntrantType: String? {
        didSet {
            for field in allTextFields {
                field.hidden = true
                field.text = ""
            }
            updateTextFieldsForEntrant(selectedEntrantType!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func firstRowButtonTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            guestView.hidden = false
            employeeView.hidden = true
            managerView.hidden = true
            selectedEntrant = "Guest"
        case 1:
            guestView.hidden = true
            employeeView.hidden = false
            managerView.hidden = true
            selectedEntrant = "Hourly Employee"
        case 2:
            guestView.hidden = true
            employeeView.hidden = false
            managerView.hidden = true
            selectedEntrant = "Contractor"
        case 3:
            guestView.hidden = true
            employeeView.hidden = true
            managerView.hidden = false
            selectedEntrant = "Manager"
        default: break
        }
    }
    
    @IBAction func guestRowButtonTapped(sender: UIButton) {
        selectedEntrantType = sender.currentTitle
    }
    
    @IBAction func generatePassButtonTapped(sender: UIButton) {
        if let selectedEntrant = self.selectedEntrant, let entrant = selectedEntrantType {
            switch selectedEntrant {
            case "Guest":
                
                switch entrant {
                case "Child":
                    do {
                        guest = try Guest(dateOfBirth: dateOfBirthTextField.text, guestType: .FreeChild)
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to preceed!")
                    } catch ParkError.ChildOlderThanFive {
                        displayAlertWithTitle("Bummer", andMessage: "Your child is older than five years old and may therefore not to enter for free!")
                    }  catch {
                        print(error)
                    }
                case "Adult":
                    do {
                        guest = try Guest(dateOfBirth: nil, guestType: .Classic)
                    } catch {
                        print(error)
                    }
                case "Senior":
                    do {
                        print(dateOfBirthTextField.text)
                        
                        guest = try Guest(firstName: firstNameTextField.text, lastName: lastNameTextField.text, dateOfBirth: dateOfBirthTextField.text, guestType: .Senior)
                    } catch {
                        print(error)
                    }
                case "Season Pass": break
                default: break
                }
            case "Hourly Employee":
                switch selectedEntrantType! {
                case "Food":
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: .FoodServices)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                case "Ride":
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: .RideServices)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                case "Maintenance":
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: .Maintenance)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                default: break
                }
            case "Contracor":
                switch selectedEntrantType! {
                case "Food":
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: .FoodServices)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                case "Ride":
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: .RideServices)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                case "Maintenance":
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: .Maintenance)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                default: break
                }
            case "Manager":
                switch selectedEntrantType! {
                case "Shift":
                    do {
                        guest = try Manager(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, managerType: .ShiftManager)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a manager type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch {
                        print(error)
                    }
                case "General":
                    do {
                        guest = try Manager(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, managerType: .GeneralManager)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a manager type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch {
                        print(error)
                    }
                case "Senior":
                    do {
                        guest = try Manager(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, managerType: .SeniorManager)
                    } catch ParkError.MissingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.MissingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.MissingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a manager type to proceed!")
                    } catch ParkError.MissingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch ParkError.MissingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch {
                        print(error)
                    }
                default: break
                }
            default: break
            }
        }
        
        if var guest = guest {
            let pass = self.kiosk.createPassForEntrant(guest)
            guest.pass = pass
            print(pass)
        }
    }
    
    @IBAction func populateDataButtonTapped(sender: UIButton) {
        
    }
    
    func updateTextFieldsForEntrant(entrant: String) {
        switch entrant {
        case "Child":
            for field in onlyDateOfBirthRequiredFields {
                field.hidden = false
            }
        case "Adult", "VIP":
            for field in allTextFields {
                field.hidden = true
            }
        case "Senior":
            for field in seniorGuestRequiredFields {
                field.hidden = false
            }
        case "Season Pass":
            for field in seasonPassRequiredFields {
                field.hidden = false
            }
        case "Food", "Ride", "Maintenance":
            if selectedEntrant == "Hourly Employee" {
                for field in hourlyEmployeeRequiredFields {
                    field.hidden = false
                }
            } else if selectedEntrant == "Contractor" {
                for field in contractEmployeeRequiredFields {
                    field.hidden = false
                }
            }
        case "Shift", "General", "Senior":
            for field in managerRequiredFields {
                field.hidden = false
            }
        default: break
        }
    }
    
    func displayAlertWithTitle(title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}