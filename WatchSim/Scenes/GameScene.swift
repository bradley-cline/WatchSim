//
//  GameScene.swift
//  WatchSim
//
//  Created by Bradley Cline on 6/27/19.
//  Copyright © 2019 Bradley Cline. All rights reserved.
//

import SpriteKit



class GameScene: SKScene {
    

    var backButton: SKSpriteNode!
    var bgBlock: Part!
    
    var instructionNumber = 0
    var instructionNumberMax = 0
    var hintsOn = false
    var reassembleNow = false
    
    
    var partDescriptor: String!
    
    let partName = SKLabelNode(text: "")
    let instruction = SKLabelNode(text: "")
    
    
    private var currentNode: SKNode?
    
    
    
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    
    
    
    // Handles snapping part to proper place during reassembly
    func partNearDestination(partNode: Part, destinationPoint: Part) {
        partNode.position = partNode.initPosition!
        destinationPoint.removeFromParent()
    }

    
    
    // Sets up what is displayed at app launch
    func layoutScene() {
//        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0  )  // Old, dark blue background color
//        backgroundColor = UIColor(red: 181/255, green: 154/255, blue: 121/255, alpha: 1.0  )  // Old, Light brown color
        backgroundColor = UIColor(red: 128/255, green: 110/255, blue: 88/255, alpha: 1.0  )
        
        
        
        //Line separator for watch and parts workspace.
        // Borrowed code from https://stackoverflow.com/questions/19092011/how-to-draw-a-line-in-sprite-kit Bogdan Kobylynskyi
        let sepLine = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 650.0, y: 0))
        pathToDraw.addLine(to: CGPoint(x: 650.0, y: frame.maxY))
        sepLine.path = pathToDraw
        sepLine.strokeColor = UIColor.black
        sepLine.lineWidth = 2
        addChild(sepLine)
        
        
        
        // Instantiates back button
        let backButton = Part(texture: SKTexture(imageNamed: "BackButton"), size: CGSize(width: 80, height: 80))
        backButton.idLabel = "Back Button"
        backButton.position = CGPoint(x: frame.minX + 265, y: frame.minY+40)
        backButton.zPosition = 50
//        addChild(backButton)
        
        
        //Instantiates next button
        let nextButton = Part(texture: SKTexture(imageNamed: "NextButton"), size: CGSize(width: 80, height: 80))
        nextButton.idLabel = "Next Button"
        nextButton.position = CGPoint(x: frame.minX + 345, y: frame.minY+40)
        nextButton.zPosition = 50
        addChild(nextButton)
        
        // Instantiates Hint Button
        let hintButton = Part(texture: SKTexture(imageNamed: "Hint"), size: CGSize(width: 80, height: 80))
        hintButton.idLabel = "Hint Button"
        hintButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY-40)
        hintButton.zPosition = 50
        addChild(hintButton)
        
        
        
        // Creates text field for part name and definition
        partName.fontName = "AvenirNext-Bold"
        partName.fontSize = 15.0
        partName.fontColor = UIColor.white
        partName.position = CGPoint(x: frame.minX + frame.size.height/2.5, y: frame.maxY-80)
        partName.zPosition = ZPositions.label
        addChild(partName)
        
        
        // creates text field for instructions
        instruction.fontName = "AvenirNext-Bold"
        instruction.accessibilityLabel = "instruction"
        instruction.fontSize = 22.0
        instruction.fontColor = UIColor.yellow
        instruction.position = CGPoint(x: frame.minX + frame.size.height/2.5, y: frame.minY + 90)
        instruction.text = "Remove the \(instructionList[instructionNumber])"
        instruction.zPosition = 50
        addChild(instruction)
        
        
        // Loads all of the watch parts onto screen
        spawnWatch()
    }
    
    
    // Updates part label with part most recently touched
    func updatePartNameLabel() {
        partName.numberOfLines = 3
        partName.text = "\(partDescriptor!)"
    }
    
    
    // Cues the next instruction
    func updateInstructionLabel() {
        for case let child as Part in self.children {
            print(instructionList[instructionNumber])
            if instructionNumber > 0 && child.idLabel == instructionList[instructionNumber - 1] {
                child.texture = SKTexture(imageNamed: child.filename!)
            }
            if child.idLabel == instructionList[instructionNumber] {
                if !reassembleNow {child.isDraggable = true}
                child.texture = SKTexture(imageNamed: child.makeAltFilename(hintsOnBool: hintsOn))
            }
        }
        if reassembleNow == false{
            instruction.text = "Next, remove the \(instructionList[instructionNumber])"
        }else{
            instruction.text = "Next, replace the \(instructionList[instructionNumber])"
            if hintsOn {reassembleHint(partIdentifier: instructionList[instructionNumber])}
            if instructionList[instructionNumber - 1] != "end" {  //When part is reassembled, snaps part 2 back into place
                snap(partIdentifier: instructionList[instructionNumber - 2])
            }
        }
    }
    
    
    // Snaps parts into place
    func snap(partIdentifier: String) {
        for child in self.children {
            if let node = child as? Part {
                if node.idLabel == partIdentifier {
                    node.position = node.initPosition!  //sets current position to default position
                    node.isDraggable = false
                }
            }
        }
    }
    
    
    
    // Creates a yellow hint dot that shows where each part goes
    func reassembleHint(partIdentifier: String) {
        for child in self.children {                    // iterates through all nodes
            if let node = child as? Part {
                if node.idLabel == partIdentifier{
                    let hintNode = SKShapeNode(circleOfRadius: 5)
                    hintNode.strokeColor = UIColor.black
                    hintNode.glowWidth = 1.0
                    hintNode.fillColor = UIColor.yellow
                    hintNode.zPosition = node.zPosition - 1
                    hintNode.position = node.initPosition!
                    addChild(hintNode)
                }
            }
        }
    }
    
    
    // Calls each parts' creation function
    func spawnWatch() {
        mainplateBackside()
        palletFork()
        palletBridge()
        mainspringBarrel()
        escapeWheel()
        fourthWheel()
        thirdWheel()
        centerWheel()
        balanceComplete()
        trainBridge()
        barrelBridge()
        click()
        ratchetWheel()
        crownWheel()
        dial()
        secondHand()
        minuteHand()
        hourHand()
    }
    
    
    func dial() {
        let dial = Part(texture: SKTexture(imageNamed: "Dial"), size: CGSize(width: PartsSize.dial, height: PartsSize.dial))
        dial.filename = "Dial"
        dial.altFilename = "HintDial"
        dial.position = CGPoint(x: frame.minX + frame.size.height/2.5, y: frame.midY)
        dial.initPosition = dial.position
        dial.idLabel = "Dial"
        dial.definition = " - the 'face' of the watch"
        dial.zPosition = ZPositions.dial
        addChild(dial)
    }
    
    // Creates Second Hand
    func secondHand() {
        let secondHand = Part(texture: SKTexture(imageNamed: "SecondHand"), size: CGSize(width: PartsSize.secondHand, height: PartsSize.secondHand))
        secondHand.filename = "SecondHand"
        secondHand.altFilename = "HintSecondHand"
        secondHand.position = CGPoint(x: frame.minX + frame.size.height/2.4, y: frame.midY-frame.size.height/6.8)
        secondHand.initPosition = secondHand.position
        secondHand.idLabel = "Second Hand"
        secondHand.definition = " - indicates time"
        secondHand.zPosition = ZPositions.secondHand
        addChild(secondHand)
    }
    
    //Creates Hour Hand
    func hourHand() {
        let hourHand = Part(texture: SKTexture(imageNamed: "HourHand"), size: CGSize(width: PartsSize.hourHand, height: PartsSize.hourHand))
        hourHand.filename = "HourHand"
        hourHand.altFilename = "HintHourHand"
        hourHand.position = CGPoint(x: frame.minX + 238, y: frame.midY + 6)
        hourHand.initPosition = hourHand.position
        hourHand.idLabel = "Hour Hand"
        hourHand.definition = " - indicates time"
        hourHand.zPosition = ZPositions.hourHand
        addChild(hourHand)
    }
    
    //Creates Minute Hand
    func minuteHand() {
        let minuteHand = Part(texture: SKTexture(imageNamed: "MinuteHand"), size: CGSize(width: PartsSize.minuteHand - 7, height: PartsSize.minuteHand - 7))
        minuteHand.filename = "MinuteHand"
        minuteHand.altFilename = "HintMinuteHand"
        minuteHand.position = CGPoint(x: frame.minX + frame.size.height/2.5 - 3, y: frame.midY + 110)
        minuteHand.initPosition = minuteHand.position
        minuteHand.idLabel = "Minute Hand"
        minuteHand.definition = " - indicates time"
        minuteHand.isDraggable = true
        minuteHand.zPosition = ZPositions.minuteHand
        addChild(minuteHand)
    }
    
    // Creates Mainplate
    func mainplateBackside() {
        let mainplateBackside = Part(texture: SKTexture(imageNamed: "MainplateBackside"), size: CGSize(width: PartsSize.mainplate, height: PartsSize.mainplate))
        mainplateBackside.position = CGPoint(x: frame.minX + frame.size.height/2.5, y: frame.midY)
        mainplateBackside.initPosition = mainplateBackside.position
        mainplateBackside.idLabel = "Mainplate"
        mainplateBackside.zPosition = ZPositions.mainplate
        addChild(mainplateBackside)
    }
    
    // Creates Pallet Fork
    func palletFork() {
        let palletFork = Part(texture: SKTexture(imageNamed: "PalletFork"), size: CGSize(width: PartsSize.palletFork, height: PartsSize.palletFork))
        palletFork.filename = "PalletFork"
        palletFork.altFilename = "HintPalletFork"
        palletFork.position = CGPoint(x: frame.minX + 413, y: frame.midY-67)
        palletFork.initPosition = palletFork.position
        palletFork.idLabel = "Pallet Fork"
        palletFork.definition = " - allows for incremental\n release of power to prevent damage to the watch"
        palletFork.zPosition = ZPositions.palletFork
        addChild(palletFork)
    }
    
    // Creates Pallet Bridge
    func palletBridge() {
        let palletBridge = Part(texture: SKTexture(imageNamed: "PalletBridge"), size: CGSize(width: PartsSize.palletBridge, height: PartsSize.palletBridge))
        palletBridge.filename = "PalletBridge"
        palletBridge.altFilename = "HintPalletBridge"
        palletBridge.position = CGPoint(x:frame.minX + 419, y: frame.midY - 73)
        palletBridge.initPosition = palletBridge.position
        palletBridge.idLabel = "Pallet Bridge"
        palletBridge.definition = " - holds the pallet fork in place"
        palletBridge.zPosition = ZPositions.palletBridge
        addChild(palletBridge)
    }
    
    
    // Creates Mainspring Barrel
    func mainspringBarrel() {
        let mainspringBarrel = Part(texture: SKTexture(imageNamed: "MainspringBarrel"), size: CGSize(width: PartsSize.mainspringBarrel - 9, height: PartsSize.mainspringBarrel - 9))
        mainspringBarrel.filename = "MainspringBarrel"
        mainspringBarrel.altFilename = "HintMainspringBarrel"
        mainspringBarrel.position = CGPoint(x:frame.minX + 183, y: frame.midY + 54)
        mainspringBarrel.initPosition = mainspringBarrel.position
        mainspringBarrel.idLabel = "Mainspring Barrel"
        mainspringBarrel.definition = " - holds the mainspring, which\nstores potential energy that powers the watch"
        mainspringBarrel.zPosition = ZPositions.mainspringBarrel
        addChild(mainspringBarrel)
    }
    
    // Creates Escape Wheel
    func escapeWheel() {
        let escapeWheel = Part(texture: SKTexture(imageNamed: "EscapeWheel"), size: CGSize(width: PartsSize.escapeWheel+15, height: PartsSize.escapeWheel+15))
        escapeWheel.filename = "EscapeWheel"
        escapeWheel.altFilename = "HintEscapeWheel"
        escapeWheel.position = CGPoint(x:frame.minX + 388, y: frame.midY - 146)
        escapeWheel.initPosition = escapeWheel.position
        escapeWheel.idLabel = "Escape Wheel"
        escapeWheel.definition = " - moves forward one step at a\ntime to control the speed of power release"
        escapeWheel.zPosition = ZPositions.escapeWheel
        addChild(escapeWheel)
    }
    
    // Creates Fourth Wheel
    func fourthWheel() {
        let fourthWheel = Part(texture: SKTexture(imageNamed: "FourthWheel"), size: CGSize(width: PartsSize.fourthWheel+12, height: PartsSize.fourthWheel+12))
        fourthWheel.filename = "FourthWheel"
        fourthWheel.altFilename = "HintFourthWheel"
        fourthWheel.position = CGPoint(x:frame.minX + 314, y: frame.midY - 127)
        fourthWheel.initPosition = fourthWheel.position
        fourthWheel.idLabel = "Fourth Wheel"
        fourthWheel.definition = " - holds the second hand"
        fourthWheel.zPosition = ZPositions.fourthWheel
        addChild(fourthWheel)
    }
    
    // Creates Third Wheel
    func thirdWheel() {
        let thirdWheel = Part(texture: SKTexture(imageNamed: "ThirdWheel"), size: CGSize(width: PartsSize.thirdWheel, height: PartsSize.thirdWheel))
        thirdWheel.filename = "ThirdWheel"
        thirdWheel.altFilename = "HintThirdWheel"
        thirdWheel.position = CGPoint(x:frame.minX + 256, y: frame.midY - 73)
        thirdWheel.initPosition = thirdWheel.position
        thirdWheel.idLabel = "Third Wheel"
        thirdWheel.definition = " - exists to drive the fourth wheel"
        thirdWheel.zPosition = ZPositions.thirdWheel
        addChild(thirdWheel)
    }
    
    // Creates Center Wheel
    func centerWheel() {
        let centerWheel = Part(texture: SKTexture(imageNamed: "CenterWheel"), size: CGSize(width: PartsSize.centerWheel, height: PartsSize.centerWheel))
        centerWheel.filename = "CenterWheel"
        centerWheel.altFilename = "HintCenterWheel"
        centerWheel.position = CGPoint(x:frame.minX + 307, y: frame.midY + 9)
        centerWheel.initPosition = centerWheel.position
        centerWheel.idLabel = "Center Wheel"
        centerWheel.definition = " - holds minute hand and\nrotates once per hour"
        centerWheel.zPosition = ZPositions.centerWheel
        addChild(centerWheel)
    }
    
    // Creates Balance Wheel and Balance Bridge
    func balanceComplete() {
        let balanceComplete = Part(texture: SKTexture(imageNamed: "BalanceComplete"), size: CGSize(width: PartsSize.balanceComplete, height: PartsSize.balanceComplete))
        balanceComplete.filename = "BalanceComplete"
        balanceComplete.altFilename = "HintBalanceComplete"
        balanceComplete.position = CGPoint(x:frame.minX + 443, y: frame.midY + 46)
        balanceComplete.initPosition = balanceComplete.position
        balanceComplete.idLabel = "Balance with Bridge"
        balanceComplete.definition = " - controls timing\n of the watch and allows for fine adjustments\nto correct the speed of the watch"
        balanceComplete.zPosition = ZPositions.balanceComplete
        addChild(balanceComplete)
        
        let screw = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 25, height: 25))
        screw.filename = "Screw"
        screw.altFilename = "HintScrew"
        screw.position = CGPoint(x:frame.minX + 493.5, y: frame.midY + 128.5)
        screw.initPosition = screw.position
        screw.idLabel = "Balance Bridge Screw"
        screw.zPosition = ZPositions.balanceComplete+1
        addChild(screw)
    }
    
    // Creates Train Bridge
    func trainBridge() {
        let trainBridge = Part(texture: SKTexture(imageNamed: "TrainBridge"), size: CGSize(width: PartsSize.trainBridge + 12, height: PartsSize.trainBridge + 12))
        trainBridge.filename = "TrainBridge"
        trainBridge.altFilename = "HintTrainBridge"
        trainBridge.position = CGPoint(x:frame.minX + 262, y: frame.midY - 152)
        trainBridge.initPosition = trainBridge.position
        trainBridge.idLabel = "Train Bridge"
        trainBridge.definition = " - holds 3rd, 4th, and\nescape wheels in place"
        trainBridge.zPosition = ZPositions.trainBridge
        addChild(trainBridge)
        
        let screw1 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 30, height: 30))
        screw1.filename = "Screw"
        screw1.altFilename = "HintScrew"
        screw1.position = CGPoint(x:frame.minX + 347, y: frame.midY - 218)
        screw1.initPosition = screw1.position
        screw1.idLabel = "Right Train Bridge Screw"
        screw1.zPosition = ZPositions.trainBridge+1
        addChild(screw1)
        
        let screw2 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 38, height: 38))
        screw2.filename = "Screw"
        screw2.altFilename = "HintScrew"
        screw2.position = CGPoint(x:frame.minX + 154, y: frame.midY - 187)
        screw2.initPosition = screw2.position
        screw2.idLabel = "Lower Left Train Bridge Screw"
        screw2.zPosition = ZPositions.trainBridge+1
        addChild(screw2)
        
        let screw3 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 31, height: 31))
        screw3.filename = "Screw"
        screw3.altFilename = "HintScrew"
        screw3.position = CGPoint(x:frame.minX + 180, y: frame.midY - 163)
        screw3.initPosition = screw3.position
        screw3.idLabel = "Upper Left Train Bridge Screw"
        screw3.zPosition = ZPositions.trainBridge+1
        addChild(screw3)
    }
    
    // Creates Barrel Bridge
    func barrelBridge() {
        let barrelBridge = Part(texture: SKTexture(imageNamed: "BarrelBridge"), size: CGSize(width: PartsSize.barrelBridge-100, height: PartsSize.barrelBridge-100))
        barrelBridge.filename = "BarrelBridge"
        barrelBridge.altFilename = "HintBarrelBridge"
        barrelBridge.position = CGPoint(x:frame.minX + 249, y: frame.midY + 61)
        barrelBridge.initPosition = barrelBridge.position
        barrelBridge.idLabel = "Barrel Bridge"
        barrelBridge.definition = " - holds the mainspring\nbarrel and center wheel in place"
        barrelBridge.zPosition = ZPositions.barrelBridge
        addChild(barrelBridge)
        
        let screw1 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 30, height: 30))
        screw1.filename = "Screw"
        screw1.altFilename = "HintScrew"
        screw1.position = CGPoint(x:frame.minX + 203.5, y: frame.midY + 215)
        screw1.initPosition = screw1.position
        screw1.idLabel = "Upper Left Barrel Bridge Screw"
        screw1.zPosition = ZPositions.barrelBridge+1
        addChild(screw1)
        
        let screw2 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 30, height: 30))
        screw2.filename = "Screw"
        screw2.altFilename = "HintScrew"
        screw2.position = CGPoint(x:frame.minX + 392, y: frame.midY + 202)
        screw2.initPosition = screw2.position
        screw2.idLabel = "Lower Right Barrel Bridge Screw"
        screw2.zPosition = ZPositions.barrelBridge+1
        addChild(screw2)
        
        let screw3 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 33, height: 33))
        screw3.filename = "Screw"
        screw3.altFilename = "HintScrew"
        screw3.position = CGPoint(x:frame.minX + 419, y: frame.midY + 230)
        screw3.initPosition = screw3.position
        screw3.idLabel = "Upper Right Barrel Bridge Screw"
        screw3.zPosition = ZPositions.barrelBridge+1
        addChild(screw3)
        
        let screw4 = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 30, height: 30))
        screw4.filename = "Screw"
        screw4.altFilename = "HintScrew"
        screw4.position = CGPoint(x:frame.minX + 126.5, y: frame.midY - 98.5)
        screw4.initPosition = screw4.position
        screw4.idLabel = "Lower Left Barrel Bridge Screw"
        screw4.zPosition = ZPositions.barrelBridge+1
        addChild(screw4)
    }
    
    // Creates Click
    func click() {
        let click = Part(texture: SKTexture(imageNamed: "Click"), size: CGSize(width: PartsSize.click, height: PartsSize.click))
        click.filename = "Click"
        click.altFilename = "HintClick"
        click.position = CGPoint(x:frame.minX + 125, y: frame.midY - 48)
        click.initPosition = click.position
        click.idLabel = "Click"
        click.definition = " - allows the ratchet wheel\nto wind only in one direction"
        click.zPosition = ZPositions.click
        addChild(click)

        let screw = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 25, height: 25))
        screw.filename = "Screw"
        screw.altFilename = "HintScrew"
        screw.position = CGPoint(x:frame.minX + 125, y: frame.midY - 48)
        screw.initPosition = screw.position
        screw.idLabel = "Click Screw"
        screw.zPosition = ZPositions.click+1
        addChild(screw)
    }
    
    // Creates Ratchet Wheel
    func ratchetWheel() {
        let ratchetWheel = Part(texture: SKTexture(imageNamed: "RatchetWheel"), size: CGSize(width: PartsSize.ratchetWheel+10, height: PartsSize.ratchetWheel+10))
        ratchetWheel.filename = "RatchetWheel"
        ratchetWheel.altFilename = "HintRatchetWheel"
        ratchetWheel.position = CGPoint(x:frame.minX + 179, y: frame.midY + 57)
        ratchetWheel.initPosition = ratchetWheel.position
        ratchetWheel.idLabel = "Ratchet Wheel"
        ratchetWheel.definition = " - turns the mainspring barrel"
        ratchetWheel.zPosition = ZPositions.ratchetWheel
        addChild(ratchetWheel)
        
        let screw = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 36, height: 36))
        screw.filename = "Screw"
        screw.altFilename = "HintScrew"
        screw.position = CGPoint(x:frame.minX + 182, y: frame.midY + 58)
        screw.initPosition = screw.position
        screw.idLabel = "Ratchet Wheel Screw"
        screw.zPosition = ZPositions.ratchetWheel+1
        addChild(screw)
    }
    
    // Creates Crown Wheel
    func crownWheel() {
        let crownWheel = Part(texture: SKTexture(imageNamed: "CrownWheel"), size: CGSize(width: PartsSize.crownWheel, height: PartsSize.crownWheel))
        crownWheel.filename = "CrownWheel"
        crownWheel.altFilename = "HintCrownWheel"
        crownWheel.position = CGPoint(x:frame.minX + 299.2, y: frame.midY + 175)
        crownWheel.initPosition = crownWheel.position
        crownWheel.idLabel = "Crown Wheel"
        crownWheel.definition = " - transfers power\nfrom winding the watch to the mainspring"
        crownWheel.zPosition = ZPositions.crownWheel
        addChild(crownWheel)
        
        let screw = Part(texture: SKTexture(imageNamed: "Screw"), size: CGSize(width: 36, height: 36))
        screw.filename = "Screw"
        screw.altFilename = "HintScrew"
        screw.position = CGPoint(x:frame.minX + 299.2, y: frame.midY + 175)
        screw.initPosition = screw.position
        screw.idLabel = "Crown Wheel Screw"
        screw.zPosition = ZPositions.crownWheel+1
        addChild(screw)
    }
    
    
    // Handles taps
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                
                if let partNode:Part = node as? Part {
                    
                    // displays previous instruction
                    if partNode.idLabel == "Back Button" {
                        if instructionNumber > 0{
                            instructionNumber -= 1
                            updateInstructionLabel()
                        }
                    }
                    
                    // triggers next instruction
                    if partNode.idLabel == "Next Button" && instructionList[instructionNumberMax] != "end" && instructionList[instructionNumberMax] != "finished"{
                        if instructionNumber < instructionNumberMax{
                            instructionNumber += 1
                            updateInstructionLabel()
                        }
                    }
                    
                    // handles midway point
                    if partNode.idLabel == "Next Button" && instructionList[instructionNumberMax] == "end"{
                        instructionNumberMax += 1
                        instructionNumber = instructionNumberMax
                        updateInstructionLabel()
                        bgBlock.size = CGSize(width: 1, height: 1)
                    }
                    if (partNode.idLabel == "Next Button" || partNode.idLabel == "Hint Button") && instructionList[instructionNumberMax] == "finished"{
                        //cycles through all parts and fixes them in place
                        for child in self.children {
                            if let node = child as? Part {
                                if node.idLabel == "Minute Hand" || node.idLabel == "Hour Hand"{
                                    node.position = node.initPosition!
                                    node.texture = SKTexture(imageNamed: node.filename!)
                                }
                                node.isDraggable = false
                            }
                        }
                    }
                    if partNode.idLabel == "Hint Button"{  // toggles hints on/off when hint button clicked
                        if hintsOn == false { partNode.texture = SKTexture(imageNamed: "HintActive")
                            hintsOn = true
                            if instructionList[instructionNumberMax] != "finished" {updateInstructionLabel()}
                        }else{
                            partNode.texture = SKTexture(imageNamed: "Hint")
                            hintsOn = false
                            if instructionList[instructionNumberMax] != "finished" {updateInstructionLabel()}
                        }
                    }
                    if partNode.isDraggable == true {   //sets current node to touched node
                        self.currentNode = partNode
                    }
                    
                    // Do not display node name if hint button, back button, next button, or text box
                    if (partNode.idLabel != nil) && (partNode.idLabel != "Next Button") && (partNode.idLabel != "Back Button") && (partNode.idLabel != "Hint Button") && (partNode.idLabel != "bgBlock"){
                        partDescriptor = partNode.idLabel! + partNode.definition
                        updatePartNameLabel()
                    }
                }
                
            }
            
        }
    }
    
    
    // Handles actions when part is moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first, let node = self.currentNode {             // selects node at touch location
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
            
            
            
            if let partNode: Part = node as? Part {
                if reassembleNow == false{
                    if partNode.filename == "Screw"{
                        node.run(SKAction.scale(to: 0.7, duration: 0.25))       // scaled screws to 70% original size
                    }else{
                        node.run(SKAction.scale(to: 0.4, duration: 0.25))       // scales part to 40% original size
                    }
                    
                }else {
                    node.run(SKAction.scale(to: 1.0, duration: 0.25))           // scales part back to normal size
                }
                
                if partNode.idLabel == instructionList[instructionNumberMax] {  // if selected part is next part up
                    print(instructionList[instructionNumberMax])
                    instructionNumberMax += 1
                    instructionNumber = instructionNumberMax
                    if instructionList[instructionNumber] == "end" {  // Handles midway point and transitions between dis- and reassembly
                        bgBlock = Part(texture: SKTexture(imageNamed: "TextBox"), size: CGSize(width: 450, height: 173))
                        bgBlock.position = CGPoint(x: frame.minX + frame.size.height/2.5, y: frame.minY + 170)
                        bgBlock.idLabel = "bgBlock"
                        self.addChild(bgBlock)
                        instruction.numberOfLines = 5
                        instruction.zPosition = 50
                        instruction.text = "CONGRATULATIONS!\nYou have disassembled the watch!\nNow reassemble the watch starting\nwith the Pallet Fork\nCLICK NEXT TO CONTINUE"
                        reassembleNow = true
                    }else if instructionList[instructionNumber] == "finished" {  // What to do when finished with the simulator
                        // Create a text box
                        bgBlock = Part(texture: SKTexture(imageNamed: "TextBox"), size: CGSize(width: 450, height: 80))
                        bgBlock.position = CGPoint(x: frame.minX + frame.size.height/2.5, y: frame.minY + 125)
                        bgBlock.initPosition = bgBlock.position
                        bgBlock.idLabel = "bgBlock"
                        bgBlock.zPosition = 49
                        self.addChild(bgBlock)  // add text box to screen
                        
                        instruction.numberOfLines = 2
                        instruction.zPosition = 50
                        instruction.text = "CONGRATULATIONS!\nYou are finished!"  // sets text
                    }else {
                        updateInstructionLabel()  // If not at midway point or finished, changes to the next instruction
                    }
                }
            }
            
        }
    }
    
    
    // Currently unused
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentNode = nil
        
    }
    
    
    // Currently unused
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentNode = nil
    }
    
}








