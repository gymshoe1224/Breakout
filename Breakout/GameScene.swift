//
//  GameScene.swift
//  Breakout
//
//  Created by Chris Markiewicz on 3/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createBackround()
        resetGame()
    }
    
    func resetGame() {
        makeBall() //happens before game starts
        makePaddle()
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
    
    func makeBall() {
        ball.removeFromParent()     //remove ball if exists
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = .black
        ball.fillColor = .yellow
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10) //physics shape matches ball image
        ball.physicsBody?.isDynamic = false //ignores all forces and impulses
        ball.physicsBody?.usesPreciseCollisionDetection = true  //use precise collison detection
        ball.physicsBody?.friction = 0 // no loss of energy from friction
        ball.physicsBody?.affectedByGravity = false  //gravity is not a factor
        ball.physicsBody?.restitution = 1 //bounces fully of other objects
        ball.physicsBody?.linearDamping = 0 //does not slow down overtime
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) //add ball object to view
    }
    
    func makePaddle() {
        paddle.removeFromParent() //remove paddle if exists
        paddle = SKSpriteNode(color: .white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.midY + 125)
        paddle.name = "Paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
}
