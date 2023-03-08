//
//  GameScene.swift
//  Breakout
//
//  Created by Chris Markiewicz on 3/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        createBackround()
    }
    
    func createBackround() {
        let stars = SKTexture(imageNamed: "Stars")
        for i in 0...1 {
            let starsBackround  = SKSpriteNode(texture: stars)
            starsBackround.zPosition = -1
            starsBackround.position = CGPoint(x: 0, y: starsBackround.size.height * CGFloat(i))
            addChild(starsBackround)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackround.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackround.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackround.run(moveForever)
        }
    }
}
