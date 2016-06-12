//
//  PassViewController.swift
//  Park Pass
//
//  Created by Dennis Parussini on 12-06-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

class PassViewController: UIViewController {

    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var rideAccessLabel: UILabel!
    @IBOutlet weak var foodDiscountLabel: UILabel!
    @IBOutlet weak var merchDiscountLabel: UILabel!
    
    var pass: Pass?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func testAreaAccessTapped(sender: UIButton) {
    }
    
    @IBAction func testRideAccessTapped(sender: UIButton) {
    }
    
    @IBAction func testDiscountAccessTapped(sender: UIButton) {
    }
    
    @IBAction func createNewPassButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
