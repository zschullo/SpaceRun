//
//  HUDNode.swift
//  SpaceRun
//
//  Created by Zachary Schullo on 12/11/17.
//  Copyright © 2017 assignment2 Zachary Schullo. All rights reserved.
//

import SpriteKit

class HUDNode: SKNode {
    
    // Create a heads up display (HUD) that will hold all of our display areas
    //
    // Once the node is added to the scene, we'll tell it to lay out its child nodes.
    // The child nodes will not contain labels as we will use the blank nodes as group containers and lay
    // out the label nodes inside of them.
    //
    // We will left align our score and right align the elapsed game time.
    //
    //
    
    // Build two parent nodes (containers) as group containers that will hold the score and value labels
    private let ScoreGroupName = "scoreGroup"
    private let ScoreValueName = "scoreValue"
    
    private let ElapsedGroupName = "elapsedGroup"
    private let ElapsedValueName = "elapsedValue"
    private let TimerActionName = "elapsedGameTimer"
    
    private let PowerupGroupName = "powerupGroup"
    private let PowerupValueName = "powerupValue"
    private let PowerupTimerActionName = "showPowerupTimer"
    
    private let HealthGroupName = "healthGroup"
    private let HealthValueName = "healthValue"
    private let HealthBarName = "healthBar"

    var elapsedTime: TimeInterval = 0.0
    var score: Int = 0
    var health: Double = 0.0
    
    // Lazy variables are not set until they are called
    lazy private var scoreFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        
        return formatter
        
    }()
    
    lazy private var timeFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        return formatter
        
    }()
    
    // When the class gets instantiated this init method is called
    override init() {
        super.init()
        
        createScoreGroup()
        
        createElapsedGroup()
        
        createPowerupGroup()
        
        createHealthGroup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    // Our labels are properly layed out within their parent group nodes, but the group nodes are centered on the
    // scene.  We need to create a layout method that will properly position the groups.
    //
    
    func layoutForScene() {
        
        // When a node exists in the Scene Graph, it can get access to the scene via it's scene property. That property
        // is nil if the node doesn't belong to a scene yet, so this method is useless if the node is not yet added
        // to the scene.
        if let scene = scene {
            
            let sceneSize = scene.size
            
            // the following will be used to calculate position of each group
            var groupSize = CGSize.zero
            
            if let scoreGroup = childNode(withName: ScoreGroupName) {
                
                // Get sie of scoreGroup container (box)
                groupSize = scoreGroup.calculateAccumulatedFrame().size
                
                // 30 points to the right of center
                scoreGroup.position = CGPoint(x: 0.0 - sceneSize.width/2.0 + 30.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                
                assert(false, "No score group node was found in the Scene Graph node tree")
                
            }
            
            if let elapsedGroup = childNode(withName: ElapsedGroupName) {
                
                // Get sie of scoreGroup container (box)
                groupSize = elapsedGroup.calculateAccumulatedFrame().size
                
                // 30 points to the right of center
                elapsedGroup.position = CGPoint(x: sceneSize.width/2.0 - 30.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                
                assert(false, "No elapsed group node was found in the Scene Graph node tree")
                
            }
            
            if let powerupGroup = childNode(withName: PowerupGroupName) {
                
                // Get sie of scoreGroup container (box)
                groupSize = powerupGroup.calculateAccumulatedFrame().size
                
                // 30 points to the right of center
                powerupGroup.position = CGPoint(x: 0.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                
                assert(false, "No powerup group node was found in the Scene Graph node tree")
                
            }
            
            if let healthGroup = childNode(withName: HealthGroupName) {
                
                // Get size of healthGroup container (box)
                groupSize = healthGroup.calculateAccumulatedFrame().size
                healthGroup.position = CGPoint(x: 0, y: -sceneSize.height/2.0 + groupSize.height)
            } else {
                
                assert(false, "No health group node was found in the Scene Graph node tree")
                
            }
 
        }
        
        
    }
    
    func createScoreGroup() {
        
        // Creating an SKNode (container) that will contain the children SKLabelNodes below
        let scoreGroup = SKNode()
        
        scoreGroup.name = ScoreGroupName
        
        // Create an SKLabelNode for our title
        let scoreTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        scoreTitle.fontSize = 12.0
        scoreTitle.fontColor = SKColor.white
        
        // Set the vertical and horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        scoreTitle.horizontalAlignmentMode = .center
        scoreTitle.verticalAlignmentMode = .bottom
        scoreTitle.text = "SCORE"
        scoreTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        scoreGroup.addChild(scoreTitle)
        
        // Creating an SKLabelNode constant for the score
        let scoreValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        scoreValue.fontSize = 20.0
        scoreValue.fontColor = SKColor.white
        
        // Set the vertical and horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        scoreValue.horizontalAlignmentMode = .center
        scoreValue.verticalAlignmentMode = .top
        scoreValue.name = ScoreValueName
        scoreValue.text = "0"
        scoreValue.position = CGPoint(x: 0.0, y: -4.0)
        
        scoreGroup.addChild(scoreValue)
        
        // Add soreGroup node as a child of our HUD node which is the current class
        addChild(scoreGroup)
    }
    
    func createElapsedGroup() {
        
        // Creating an SKNode (container) that will contain the children SKLabelNodes below
        let elapsedGroup = SKNode()
        
        elapsedGroup.name = ElapsedGroupName
        
        // Create an SKLabelNode for our title
        let elapsedTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        elapsedTitle.fontSize = 12.0
        elapsedTitle.fontColor = SKColor.white
        
        // Set the vertical and horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        elapsedTitle.horizontalAlignmentMode = .center
        elapsedTitle.verticalAlignmentMode = .bottom
        elapsedTitle.text = "TIME"
        elapsedTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        elapsedGroup.addChild(elapsedTitle)
        
        // Creating an SKLabelNode constant for the score
        let elapsedValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        elapsedValue.fontSize = 20.0
        elapsedValue.fontColor = SKColor.white
        
        // Set the vertical and horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        elapsedValue.horizontalAlignmentMode = .center
        elapsedValue.verticalAlignmentMode = .top
        elapsedValue.name = ElapsedValueName
        elapsedValue.text = "0.0s"
        elapsedValue.position = CGPoint(x: 0.0, y: -4.0)
        
        elapsedGroup.addChild(elapsedValue)
        
        // Add soreGroup node as a child of our HUD node which is the current class
        addChild(elapsedGroup)
    }
    
    func createPowerupGroup() {
        
        // Creating an SKNode (container) that will contain the children SKLabelNodes below
        let powerupGroup = SKNode()
        
        powerupGroup.name = PowerupGroupName
        
        // Create an SKLabelNode for our title
        let powerupTitle = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        powerupTitle.fontSize = 14.0
        powerupTitle.fontColor = SKColor.red
        
        // Set the horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        powerupTitle.verticalAlignmentMode = .bottom
        powerupTitle.text = "Power-up!"
        powerupTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        // set up actions to make our title pulse
        powerupTitle.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.3), SKAction.scale(to: 1.0, duration: 0.3)])))
        
        powerupGroup.addChild(powerupTitle)
        
        // Creating an SKLabelNode constant for the score
        let powerupValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        powerupValue.fontSize = 20.0
        powerupValue.fontColor = SKColor.red
        
        // Set the vertical alignment modes in a way that will help use layout
        // for the labels inside this group node.
        powerupValue.verticalAlignmentMode = .top
        powerupValue.name = PowerupValueName
        powerupValue.text = "0s left"
        powerupValue.position = CGPoint(x: 0.0, y: -4.0)
        
        powerupGroup.addChild(powerupValue)
        
        // Add soreGroup node as a child of our HUD node which is the current class
        addChild(powerupGroup)
        
        powerupGroup.alpha = 0.0 // make it invisible to start
    }
    
    func createHealthGroup() {

        // Creating an SKNode (container) that will contain the children SKLabelNodes below
        let healthGroup = SKNode()
        
        healthGroup.name = HealthGroupName
        
        // Create an SKLabelNode for our title
        let healthTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        healthTitle.fontSize = 12.0
        healthTitle.fontColor = SKColor.white
        
        // Set the vertical and horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        healthTitle.horizontalAlignmentMode = .center
        healthTitle.verticalAlignmentMode = .bottom
        healthTitle.text = "Health"
        healthTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        healthGroup.addChild(healthTitle)

        // Creating an SKLabelNode constant for the score
        let healthValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        healthValue.fontSize = 20.0
        healthValue.fontColor = SKColor.white
        
        // Set the vertical and horizonal alignment modes in a way that will help use layout
        // for the labels inside this group node.
        healthValue.horizontalAlignmentMode = .center
        healthValue.verticalAlignmentMode = .top
        healthValue.name = HealthValueName
        healthValue.text = "0"
        healthValue.position = CGPoint(x: 0.0, y: -2.0)
        
        healthGroup.addChild(healthValue)
        
        // Attempting to create a progress bar
        let healthBar = SKShapeNode(rect: CGRect(x: -100.0, y: -30.0, width: 200.0, height: 5.0))
        healthBar.name = HealthBarName
        healthGroup.addChild(healthBar)
        
        
        // Add soreGroup node as a child of our HUD node which is the current class
        addChild(healthGroup)
 
    }
    
    // Function to update ScoreValue label in HUD
    func addPoints(_ points: Int){
        
        score += points
        
        // Update HUD by looking up score value label and updating it
        if let scoreValue = childNode(withName: "\(ScoreGroupName)/\(ScoreValueName)") as! SKLabelNode? {
            
            // Format our score value using a thousands separator by using our cached scoreFormatter property
            scoreValue.text = scoreFormatter.string(from: NSNumber(value: score))
            
            // Scale the node up for a brief period of time and then scale it back down
            scoreValue.run(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.02), SKAction.scale(to: 1, duration: 0.07)]))
            
        }
        
    }
    
    func showPowerupTimer(_ time: TimeInterval) {
        
        // Getting a reference from the scene graph when in a different method
        if let powerupGroup = childNode(withName: PowerupGroupName) {
            
            powerupGroup.removeAction(forKey: PowerupTimerActionName)
            
            if let powerupValue = powerupGroup.childNode(withName: PowerupValueName) as! SKLabelNode? {
                
                // Run the countdown sequence
                let start = Date.timeIntervalSinceReferenceDate
                
                let block = SKAction.run {
                    
                    [weak self] in
                    
                    if let weakSelf = self {
                        
                        let elapsedTime = Date.timeIntervalSinceReferenceDate - start
                        
                        let timeLeft = max(time - elapsedTime, 0)
                        
                        let timeLeftFormat = weakSelf.timeFormatter.string(from: NSNumber(value: timeLeft))
                        
                        powerupValue.text = "\(timeLeftFormat ?? "0")s left"
                        
                    }
                    
                }
                
                let countDownSequence = SKAction.sequence([block, SKAction.wait(forDuration: 0.05)])
                
                let countDown = SKAction.repeatForever(countDownSequence)
                
                let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
                let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                
                let stopAction = SKAction.run({ () -> Void in
                    
                    powerupGroup.removeAction(forKey: self.PowerupTimerActionName)
                    
                })
                
                let visuals = SKAction.sequence([fadeIn, SKAction.wait(forDuration: time), fadeOut, stopAction])
                
                powerupGroup.run(SKAction.group([countDown, visuals]), withKey: self.PowerupTimerActionName)
                
            }
            
        }
    }
    
    func showHealth(_ shipHealthRate: Double) {
        
        health = shipHealthRate
        
        // Getting a reference from the scene graph when in a different method
        if let healthGroup = childNode(withName: HealthGroupName) {
            
            
            if let healthValue = healthGroup.childNode(withName: HealthValueName) as! SKLabelNode? {
                
                let healthPercent = (100 * health/4)
                healthValue.text = "\(Int(healthPercent))%"
                
                if health == 4 {
                    
                    healthValue.fontColor = .green
                    
                } else if health == 3 {
                    
                    healthValue.fontColor = .yellow
                    
                } else if health == 2 {
                    
                    healthValue.fontColor = .orange
                    
                } else {
                    
                    healthValue.fontColor = .red
                    
                }
                
            }
            
            
             if let healthBar = healthGroup.childNode(withName: HealthBarName) as! SKShapeNode? {
             
                 if health == 4 {
                 
                    healthBar.fillColor = .green
                 
                 } else if health == 3 {
                 
                    healthBar.fillColor = .yellow
                 
                 } else if health == 2 {
                 
                    healthBar.fillColor = .orange
                    
                 } else {
                    
                    healthBar.fillColor = .red
                
                }
             
             }
            
        }
            
    }
    
    
    
    func startGame() {
        
        // Calculate the time stamp when starting the game
        let startTime = Date.timeIntervalSinceReferenceDate
        
        if let elapsedValue = childNode(withName: "\(ElapsedGroupName)/\(ElapsedValueName)") as! SKLabelNode? {
            
            // Use a codeblock to update the elapsed time property to be the difference between the startTime and current
            // timeStamp
            
            let update = SKAction.run({
                
                [weak self] in
                
                if let weakSelf = self {
                    
                    let currentTime = Date.timeIntervalSinceReferenceDate
                    
                    weakSelf.elapsedTime = currentTime - startTime
                    
                    elapsedValue.text = weakSelf.timeFormatter.string(from: NSNumber(value: weakSelf.elapsedTime))
                }
                
            })
            
            let updateAndDelay = SKAction.sequence([update, SKAction.wait(forDuration: 0.05)])
            
            let timer = SKAction.repeatForever(updateAndDelay)
            
            run(timer, withKey: TimerActionName)
            
        }
    }
    
    func endGame() {
        
        // Stop the timer sequence
        removeAction(forKey: TimerActionName)
        
        if let powerupGroup = childNode(withName: PowerupGroupName) {
            
            powerupGroup.removeAction(forKey: PowerupTimerActionName)
            
            powerupGroup.run(SKAction.fadeAlpha(to: 0.0, duration: 0.3))
            
        }
        
    }
}
