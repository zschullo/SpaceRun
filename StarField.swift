//
//  StarField.swift
//  SpaceRun
//
//  Created by Zachary Schullo on 12/6/17.
//  Copyright © 2017 assignment2 Zachary Schullo. All rights reserved.
//

import SpriteKit

class StarField: SKNode {
    
    override init() {
        
        super.init()
        
        initSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        initSetup()
    }
    
    func initSetup() {
        
        // Because we need to call a method on self (launchStar) from inside a code block, we must create
        // a weak reference to self.  This is what we are doing with the [weak self] code, and then eventually
        // assigning the "weak" self to a local constant called weakSelf.
        //
        // Why?
        //
        // The run action holds a strong refrence to the code block and the node/object (self) holds a strong
        // reference to the run action.  If the code block held a strong reference to the node/object (self) then
        // the run action, the code block, and the node/object would all hold strong references to each other forming
        // a retain cycle which would never get deallocated which can also be called a memory leak.
        
        let update = SKAction.run {
            
            [weak self]  in
            
            if arc4random_uniform(10) < 5 {
                
                if let weakSelf = self {
                    
                    weakSelf.launchStar()
                }
            }
        }
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.01), update])))
        
    }
    
    func launchStar() {
        
        // Make sure we have a reference to the scene
        if let scene = self.scene {
            
            // calculate a random starting point at top of screen
            let randomX = Double(arc4random_uniform(uint(scene.size.width)))
            
            let maxY = Double(scene.size.height)
            
            let randomStart = CGPoint(x: randomX, y: maxY)
            
            // set image and other properties for node
            let star = SKSpriteNode(imageNamed: "shootingstar")
            star.position = randomStart
            star.alpha = 0.1 + (CGFloat(arc4random_uniform(10)) / 10)
            star.size = CGSize(width: 3.0 - star.alpha, height: 8 - star.alpha)
            
            // stack the stars from dimmest to brightest on the z-axis
            star.zPosition = -100 + star.alpha * 10
            
            // Move the star toward the bottom of the screen using a random duration removing the star
            // when it reaches the bottom edge.
            //
            // The different speeds of the stars based on duration will give the illusion of the parallax effect
            let destY = 0.0 - scene.size.height - star.size.height
            let duration = Double(-star.alpha + 1.8)
            
            addChild(star)
            star.run(SKAction.sequence([SKAction.moveBy(x: 0.0, y: destY, duration: duration), SKAction.removeFromParent()]))
            
            
        }
        
    }
    
}
