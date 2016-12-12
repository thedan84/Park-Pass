//
//  ViewController.swift
//  Park Pass
//
//  Created by Dennis Parussini on 09-06-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}


class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
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
    @IBOutlet weak var dateOfVisitTextField: UITextField!
    
    @IBOutlet weak var guestView: UIView!
    @IBOutlet weak var employeeView: UIView!
    @IBOutlet weak var managerView: UIView!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var contractorView: UIView!
    
    @IBOutlet var allTextFields: [UITextField]!
    @IBOutlet var onlyDateOfBirthRequiredFields: [UITextField]!
    @IBOutlet var hourlyEmployeeRequiredFields: [UITextField]!
    @IBOutlet var managerRequiredFields: [UITextField]!
    @IBOutlet var seasonPassRequiredFields: [UITextField]!
    @IBOutlet var seniorGuestRequiredFields: [UITextField]!
    @IBOutlet var contractEmployeeRequiredFields: [UITextField]!
    @IBOutlet var vendorRequiredFields: [UITextField]!
    
    @IBOutlet weak var generatePassButtonBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    let kiosk = Kiosk()
    var guest: EntrantType?
    
    var selectedEntrant: String?
    
    //This property determines which text field should be hidden for which entrant type
    var selectedEntrantType: String? {
        didSet {
            for field in allTextFields {
                field.isHidden = true
                field.text = ""
            }
            updateTextFieldsForEntrant(selectedEntrantType!)
        }
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectNumberTextField.delegate = self
        dateOfBirthTextField.delegate = self
        securityNumberTextField.delegate = self
        zipCodeTextField.delegate = self
        dateOfVisitTextField.delegate = self

        //Please uncomment before testing on iPad Pro
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
         */
    }
    
    //MARK: - Action methods
    //This function updates the selectedEntrant property, dependant on the tapped button in the first row
    @IBAction func firstRowButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            guestView.isHidden = false
            employeeView.isHidden = true
            managerView.isHidden = true
            vendorView.isHidden = true
            contractorView.isHidden = true
            selectedEntrant = "Guest"
        case 1:
            guestView.isHidden = true
            employeeView.isHidden = false
            managerView.isHidden = true
            contractorView.isHidden = true
            vendorView.isHidden = true
            selectedEntrant = "Employee"
        case 2:
            guestView.isHidden = true
            employeeView.isHidden = true
            contractorView.isHidden = false
            managerView.isHidden = true
            vendorView.isHidden = true
            selectedEntrant = "Contractor"
        case 3:
            guestView.isHidden = true
            employeeView.isHidden = true
            managerView.isHidden = false
            contractorView.isHidden = true
            vendorView.isHidden = true
            selectedEntrant = "Manager"
        case 4:
            guestView.isHidden = true
            employeeView.isHidden = true
            contractorView.isHidden = true
            managerView.isHidden = true
            vendorView.isHidden = false
            selectedEntrant = "Vendor"
        default: break
        }
    }
    
    //This function updates the selectedEntrantType property, dependent on the button tapped in the second row
    @IBAction func guestRowButtonTapped(_ sender: UIButton) {
        selectedEntrantType = sender.currentTitle
    }
    
    //This function generates a guest, dependent on the selectedEntrant and selectedEntrantType properties. It also generates and assigns a pass to the guest, and presents the PassViewController, if guest and pass generation are successful
    @IBAction func generatePassButtonTapped(_ sender: UIButton) {
        if let selectedEntrant = self.selectedEntrant, let entrant = selectedEntrantType {
            switch selectedEntrant {
            case "Guest":
                switch entrant {
                case "Child":
                    do {
                        guest = try Guest(dateOfBirth: dateOfBirthTextField.text, guestType: .freeChild)
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to preceed!")
                    } catch ParkError.childOlderThanFive {
                        displayAlertWithTitle("Bummer", andMessage: "Your child is older than five years old and may therefore not to enter for free!")
                    }  catch {
                        print(error)
                    }
                case "Adult":
                    do {
                        guest = try Guest(dateOfBirth: nil, guestType: .classic)
                    } catch {
                        print(error)
                    }
                case "Senior":
                    do {
                        guest = try Guest(firstName: firstNameTextField.text, lastName: lastNameTextField.text, dateOfBirth: dateOfBirthTextField.text, guestType: .senior)
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to preceed!")
                    } catch ParkError.missingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to preceed!")
                    } catch {
                        print(error)
                    }
                case "Season Pass":
                    do {
                        guest = try Guest(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), dateOfBirth: dateOfBirthTextField.text, guestType: .seasonPass)
                    } catch ParkError.missingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.missingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                case "VIP":
                    do {
                        guest = try Guest(dateOfBirth: nil, guestType: .vip)
                    } catch {
                        print(error)
                    }
                default: break
                }
            case "Employee":
                var workType: WorkType?
                
                switch entrant {
                case "Food": workType = .foodServices
                case "Ride": workType = .rideServices
                case "Maintenance": workType = .maintenance
                default: workType = nil
                }
                
                if let work = workType {
                    do {
                        guest = try HourlyEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, workType: work)
                    } catch ParkError.missingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.missingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.missingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch ParkError.missingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a work type to proceed!")
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch {
                        print(error)
                    }
                } else {
                    displayAlertWithTitle("Missing Info", andMessage: "Please select a valid work type to proceed!")
                }
            case "Contractor":
                var project: ProjectNumber?
                switch projectNumberTextField.text! {
                case "1001": project = .oneThousandOne
                case "1002": project = .oneThousandTwo
                case "1003": project = .oneThousandThree
                case "2001": project = .twoThousandOne
                case "2002": project = .twoThousandTwo
                default: project = nil
                }
                
                if let projNumber = project {
                    do {
                        guest = try ContractEmployee(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, projectNumber: projNumber)
                    } catch ParkError.missingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.missingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch ParkError.missingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch {
                        print(error)
                    }
                } else {
                    displayAlertWithTitle("Warning", andMessage: "Please enter a valid project number to proceed!")
                }
            case "Manager":
                var managerType: ManagementTier?

                switch entrant {
                case "Shift Manager": managerType = .shiftManager
                case "General Manager": managerType = .generalManager
                case "Senior Manager": managerType = .seniorManager
                default: managerType = nil
                }
                
                if let manager = managerType {
                    do {
                        guest = try Manager(firstName: firstNameTextField.text, lastName: lastNameTextField.text, streetAddress: streetAddressTextField.text, city: cityNameTextField.text, state: stateNameTextField.text, zipCode: Int(zipCodeTextField.text!), socialSecurityNumber: Int(securityNumberTextField.text!), dateOfBirth: dateOfBirthTextField.text, managerType: manager)
                    } catch ParkError.missingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.missingAddress {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide an address to proceed!")
                    } catch ParkError.missingType {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a manager type to proceed!")
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch ParkError.missingSecurityNumber {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a social security number to proceed!")
                    } catch {
                        print(error)
                    }
                } else {
                    displayAlertWithTitle("Missing Info", andMessage: "Please select a valid managment tier to proceed!")
                }
            case "Vendor":
                var company: Company?

                switch companyNameTextField.text! {
                    case "Acme": company = .acme
                    case "Orkin": company = .orkin
                    case "Fedex": company = .fedex
                    case "NW Electrical": company = .nwElectrical
                default: company = nil
                }
                
                if let company = company {
                    do {
                        guest = try Vendor(firstName: firstNameTextField.text, lastName: lastNameTextField.text, company: company, dateOfBirth: dateOfBirthTextField.text, dateOfVisit: dateOfVisitTextField.text)
                    } catch ParkError.missingName {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a name to proceed!")
                    } catch ParkError.missingDateOfBirth {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a date of birth to proceed!")
                    } catch ParkError.missingDateOfVisit {
                        displayAlertWithTitle("Missing Info", andMessage: "Please provide a valid date of visit to proceed!")
                    } catch {
                        print(error)
                    }
                } else {
                    displayAlertWithTitle("Warning", andMessage: "Please enter a valid company to proceed!")
                }
            default: break
            }
        }
        
        checkValidInputForTextFields()
        
        if var guest = guest {
            let pass = self.kiosk.createPassForEntrant(guest)
            guest.pass = pass
            
            let passVC = storyboard?.instantiateViewController(withIdentifier: "PassViewController") as! PassViewController
            passVC.guest = guest
            present(passVC, animated: true, completion: nil)
        }
        
    }
    
    //This function updates the text fields with plug values for the different entrant types
    @IBAction func populateDataButtonTapped(_ sender: UIButton) {
        if let selectedEntrant = self.selectedEntrant, let entrant = self.selectedEntrantType {
            switch selectedEntrant {
            case "Guest":
                switch entrant {
                case "Child":
                    self.dateOfBirthTextField.text = "06/10/2015"
                case "Senior":
                    self.firstNameTextField.text = "Joe"
                    self.lastNameTextField.text = "Smith"
                    self.dateOfBirthTextField.text = "06/10/1960"
                case "Season Pass":
                    self.firstNameTextField.text = "Joe"
                    self.lastNameTextField.text = "Smith"
                    self.dateOfBirthTextField.text = "06/10/2002"
                    self.streetAddressTextField.text = "Hollywood Blvd."
                    self.cityNameTextField.text = "Los Angeles"
                    self.stateNameTextField.text = "CA"
                    self.zipCodeTextField.text = "91601"
                default: break
                }
            case "Employee":
                self.firstNameTextField.text = "Joe"
                self.lastNameTextField.text = "Smith"
                self.dateOfBirthTextField.text = "06/10/2002"
                self.streetAddressTextField.text = "Hollywood Blvd."
                self.cityNameTextField.text = "Los Angeles"
                self.stateNameTextField.text = "CA"
                self.zipCodeTextField.text = "91601"
                self.securityNumberTextField.text = "1212344"
            case "Contractor":
                self.firstNameTextField.text = "Joe"
                self.lastNameTextField.text = "Smith"
                self.dateOfBirthTextField.text = "06/10/2002"
                self.streetAddressTextField.text = "Hollywood Blvd."
                self.cityNameTextField.text = "Los Angeles"
                self.stateNameTextField.text = "CA"
                self.zipCodeTextField.text = "91601"
                self.securityNumberTextField.text = "1212344"
                self.projectNumberTextField.text = entrant
            case "Manager":
                self.firstNameTextField.text = "Joe"
                self.lastNameTextField.text = "Smith"
                self.dateOfBirthTextField.text = "06/10/2002"
                self.streetAddressTextField.text = "Hollywood Blvd."
                self.cityNameTextField.text = "Los Angeles"
                self.stateNameTextField.text = "CA"
                self.zipCodeTextField.text = "91601"
                self.securityNumberTextField.text = "1212344"
            case "Vendor":
                self.firstNameTextField.text = "Joe"
                self.lastNameTextField.text = "Smith"
                self.dateOfBirthTextField.text = "06/10/2002"
                self.dateOfVisitTextField.text = dateFormatter.string(from: Date())
                self.companyNameTextField.text = entrant
            default: break
            }
        }
    }
    
    //This function is used in the selectedEntrantType property to show or hide the necessary text fields for the various entrant types
    func updateTextFieldsForEntrant(_ entrant: String) {
        switch entrant {
        case "Child":
            for field in onlyDateOfBirthRequiredFields {
                field.isHidden = false
            }
        case "Adult", "VIP":
            for field in allTextFields {
                field.isHidden = true
            }
        case "Senior":
            for field in seniorGuestRequiredFields {
                field.isHidden = false
            }
        case "Season Pass":
            for field in seasonPassRequiredFields {
                field.isHidden = false
            }
        case "Food", "Ride", "Maintenance":
            for field in hourlyEmployeeRequiredFields {
                field.isHidden = false
            }
        case "1001", "1002", "1003", "2001", "2002":
            for field in contractEmployeeRequiredFields {
                field.isHidden = false
            }
        case "Shift Manager", "General Manager", "Senior Manager":
            for field in managerRequiredFields {
                field.isHidden = false
            }
        case "Acme", "Orkin", "Fedex", "NW Electrical":
            for field in vendorRequiredFields {
                field.isHidden = false
            }
        default: break
        }
    }
    
    //Helper function to display an alert when something wrong was entered in the text fields, or when errors are thrown
    func displayAlertWithTitle(_ title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    //This function from the UITextFieldDelegate protocol disables wrong input into text fields which expect integer values
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentLocale = Locale.current
        
        let decimalSeparator = (currentLocale as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        let replacementTextHasAlphabet = string.rangeOfCharacter(from: CharacterSet.letters)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil || replacementTextHasAlphabet != nil {
            return false
        } else {
            return true
        }
    }
    
    //This function checks for valid input dependent on the type of information required
    func checkValidInputForTextFields() {
        let allTextFields = [firstNameTextField, lastNameTextField, streetAddressTextField, cityNameTextField, stateNameTextField, companyNameTextField, dateOfBirthTextField, projectNumberTextField, zipCodeTextField, securityNumberTextField, dateOfVisitTextField]
        
        for textField in allTextFields {
            if !(textField?.isHidden)! {
                switch textField {
                case firstNameTextField?, lastNameTextField?:
                    //Values for text lengths are completely made up for names and social security numbers. ;-)
                    if (textField?.text?.characters.count)! > 15 {
                        displayAlertWithTitle("Wrong Input", andMessage: "A person's name shouldn't be longer than 15 characters")
                    }
                case streetAddressTextField?:
                    if (textField?.text?.characters.count)! > 15 {
                        displayAlertWithTitle("Wrong Input", andMessage: "Street names shouldn't be longer than 10 characters")
                    }
                case cityNameTextField?:
                    if (textField?.text?.characters.count)! > 15 {
                        displayAlertWithTitle("Wrong Input", andMessage: "City names shouldn't be longer than 15 characters")
                    }
                case companyNameTextField?:
                    if (textField?.text?.characters.count)! > 15 {
                        displayAlertWithTitle("Wrong Input", andMessage: "Company names shouldn't be longer than 15 characters")
                    }
                case stateNameTextField?:
                    if (textField?.text?.characters.count)! != 2 {
                        displayAlertWithTitle("Wrong Input", andMessage: "Please enter the two letter abbreviation for state names")
                    }
                    //Value for text length is based on US zip codes which are 5 characters long
                case zipCodeTextField?:
                    if (textField?.text?.characters.count)! != 5 {
                        displayAlertWithTitle("Wrong Input", andMessage: "Please enter a valid zip code. Zip codes should be 5 characters long")
                    }
                    //Value for text length is based on the project numbers provided in the Entrant Rules Matrix
                case projectNumberTextField?:
                    if (textField?.text?.characters.count)! != 4 {
                        displayAlertWithTitle("Wrong Input", andMessage: "Project numbers should be exactly 4 characters long")
                    }
                    //Value for text length is based on the format of the dates which is MM/DD/YYYY
                case dateOfBirthTextField?, dateOfVisitTextField?:
                    if (textField?.text?.characters.count)! != 10 {
                        displayAlertWithTitle("Wrong Input", andMessage: "A date should be exactly 10 characters long, with the format MM/DD/YYYY")
                    }
                case securityNumberTextField?:
                    if (textField?.text?.characters.count)! > 7 {
                        displayAlertWithTitle("Wrong Input", andMessage: "Security numbers shouldn't be longer than 7 characters")
                    }
                default: break
                }
            }
        }
    }
    
    //Helper method which moves the generate pass and populate data buttons up when the keyboard is shown
    func keyboardWillShow(_ notification: Notification) {
        if let userInfoDictionary = notification.userInfo, let keyboardFrameValue = userInfoDictionary[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            UIView.animate(withDuration: 0.8, animations: {
                self.generatePassButtonBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }) 
        }
    }
    
    //Helper method which moves the generate pass and populate data buttons down when the keyboard is hidden
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.8, animations: {
            self.generatePassButtonBottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        }) 
        
    }
}
