//
//  Settings.swift
//  WatchSim
//
//  Created by Bradley Cline on 6/28/19.
//  Copyright © 2019 Bradley Cline. All rights reserved.
//

import SpriteKit


// Depth at which each part is rendered
enum ZPositions {
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
    
    static let dial: CGFloat = 7
    static let secondHand: CGFloat = 8
    static let hourHand: CGFloat = 8
    static let minuteHand: CGFloat = 9
    static let mainplate: CGFloat = 0
    static let palletFork: CGFloat = 1
    static let palletBridge: CGFloat = 2
    static let escapeWheel: CGFloat = 1
    static let fourthWheel: CGFloat = 2
    static let mainspringBarrel: CGFloat = 1
    static let thirdWheel: CGFloat = 3
    static let centerWheel: CGFloat = 4
    static let balanceComplete: CGFloat = 3
    static let trainBridge: CGFloat = 5
    static let barrelBridge: CGFloat = 5
    static let click: CGFloat = 6
    static let ratchetWheel: CGFloat = 6
    static let crownWheel: CGFloat = 6
    
}


// Approximate parts sized in pixels based off of real life measurements in millimeters
enum PartsSize {
    static let dial = 590
    static let mainplate = 590
    static let palletFork = 107
    static let palletBridge = 157
    static let secondHand = 127
    static let minuteHand = 272
    static let hourHand = 219
    static let escapeWheel = 104
    static let fourthWheel = 146
    static let mainspringBarrel = 260
    static let thirdWheel = 155
    static let centerWheel = 196
    static let balanceComplete = 357
    static let trainBridge = 319
    static let click = 62
    static let ratchetWheel = 205
    static let crownWheel = 164
    static let barrelBridge = 542
    static let minuteWheel = 96
    static let intermediateWheelCover = 124
    static let intermediateWheel = 41
    static let hourWheel = 79
    static let cannonPinnion = 35
}


// Array of parts in order they are removed and reassembled. Iterated through for instructions
var instructionList = ["Minute Hand", "Hour Hand", "Second Hand", "Dial", "Crown Wheel Screw", "Crown Wheel", "Ratchet Wheel Screw",
"Ratchet Wheel", "Click Screw", "Click", "Upper Right Barrel Bridge Screw",
"Lower Right Barrel Bridge Screw", "Upper Left Barrel Bridge Screw",
"Lower Left Barrel Bridge Screw", "Barrel Bridge", "Balance Bridge Screw", "Balance with Bridge",
"Upper Left Train Bridge Screw", "Lower Left Train Bridge Screw",
"Right Train Bridge Screw", "Train Bridge", "Center Wheel", "Third Wheel", "Fourth Wheel",
"Mainspring Barrel", "Escape Wheel", "Pallet Bridge", "Pallet Fork", "end", "Pallet Fork", "Pallet Bridge", "Escape Wheel", "Mainspring Barrel", "Fourth Wheel", "Third Wheel", "Center Wheel", "Train Bridge", "Right Train Bridge Screw", "Lower Left Train Bridge Screw", "Upper Left Train Bridge Screw", "Balance with Bridge", "Balance Bridge Screw", "Barrel Bridge", "Lower Left Barrel Bridge Screw", "Upper Left Barrel Bridge Screw", "Lower Right Barrel Bridge Screw", "Upper Right Barrel Bridge Screw", "Click", "Click Screw", "Ratchet Wheel", "Ratchet Wheel Screw", "Crown Wheel", "Crown Wheel Screw", "Dial", "Second Hand", "Hour Hand", "Minute Hand", "finished"]



// Custom Parts class inherits from SKSpritenode
class Part: SKSpriteNode{
    var filename: String?           // default image file
    var altFilename: String?        // image file when hint is active
    var idLabel: String?            // part identifier
    var isDraggable = false         // can be moved?
    var isRemoved = false           // has been removed?
    var initPosition: CGPoint?      // default position of part on screen
    var definition = ""             // what is the part for?
    
    
    
    // Switches between default and hint image
    func makeAltFilename(hintsOnBool:Bool) -> String {
        if(hintsOnBool == false){
            return filename!
        }else if(altFilename == nil){
            return filename!
        }else{
            return altFilename!
        }
    }
}


