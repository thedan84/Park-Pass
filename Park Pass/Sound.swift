//
//  Sound.swift
//  Amusement Park Pass Generator
//
//  Created by Dennis Parussini on 28-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import AudioToolbox

struct Sound {
    
    //MARK: - Properties
    var accessGrantedSound: SystemSoundID = 0
    var accessDeniedSound: SystemSoundID = 1
    
    //Properties which get the right sound based on path
    var accessGranted: URL {
        let pathToSoundFile = Bundle.main.path(forResource: "AccessGranted", ofType: "wav")
        return URL(fileURLWithPath: pathToSoundFile!)
    }
    
    var accessDenied: URL {
        let pathToSoundFile = Bundle.main.path(forResource: "AccessDenied", ofType: "wav")
        return URL(fileURLWithPath: pathToSoundFile!)
    }
    
    //MARK: - Helper
    //Helper function to load the right sound from the bundle url
    mutating func loadSoundWithURL(_ url: URL, id: inout SystemSoundID) {
        AudioServicesCreateSystemSoundID(url as CFURL, &id)
    }
    
    //MARK: - Play the right sound
    //Play the access granted sound
    mutating func playAccessGrantedSound() {
        loadSoundWithURL(accessGranted, id: &accessGrantedSound)
        AudioServicesPlaySystemSound(accessGrantedSound)
    }
    
    //Play the access denied sound
    mutating func playAccessDeniedSound() {
        loadSoundWithURL(accessDenied, id: &accessDeniedSound)
        AudioServicesPlaySystemSound(accessDeniedSound)
    }
}
