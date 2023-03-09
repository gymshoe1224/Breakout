//
//  GameScene.swift
//  Breakout
//
//  Created by Chris Markiewicz on 3/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    var loseZone = SKSpriteNode()
    var playLabel = SKLabelNode()
    var livesLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var playingGame = false
    var score = 0
    var lives = 3
    var removedBricks = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackround()
        resetGame()
        makeLoseZone()
        makeLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if playingGame {
                paddle.position.x = location.x
            }
            else {
                for node in nodes(at: location) {
                    if node.name == "playLabel" {
                        playingGame = true
                        node.alpha = 0
                        score = 0
                        lives = 3
                        updateLabels()
                        kickBall()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if playingGame {
                paddle.position.x = location.x
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        for brick in bricks {
            if contact.bodyA.node == brick ||
                contact.bodyB.node == brick {
                score += 1
                updateLabels()
                brick.removeFromParent()
                removedBricks += 1
                if removedBricks == bricks.count {
                    gameOver(winner: true)
                }
            }
        }
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "loseZone" {
            lives -= 1
            if lives > 0 {
                score = 0
                resetGame()
                kickBall()
            }
            else {
                gameOver(winner: false)
            }
        }
    }
    
    func resetGame() {
        makeBall() //happens before game starts
        makePaddle()
        makeBricks()
        updateLabels()
    }
    
    func kickBall() {
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
    }
    
    func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        livesLabel.text = "Lives: \(lives)"
    }
    
    func gameOver(winner: Bool) {
        playingGame = false
        playLabel.alpha = 1
        resetGame()
        if winner {
            playLabel.text = "You Win! Tap to Play Again"
        }
        else {
            playLabel.text = "You Lose! Tap to Play Again"
        }
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
        paddle.position = CGPoint(x: frame.midX, y: frame.midY - 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
     
    func makeBrick(x: Int, y: Int, color: UIColor) {
        let brick = SKSpriteNode(color: color, size: CGSize(width: 50, height: 20))
        brick.position = CGPoint(x: x, y: y)
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
        bricks.append(brick)
    }
    
    func makeBricks() {
        //remove any leftover Bricks from previous game
        for brick in bricks {
            if brick.parent != nil {
                brick.removeFromParent()
            }
        }
        bricks.removeAll() //clear the array
        removedBricks = 0 //reset the counter
        
        let count = Int(frame.width) / 55
        let xOffset = (Int(frame.width) - (count * 55)) / 2 + Int(frame.minX) + 25
        let y = Int(frame.maxY) - 65
        for i in 0..<count {
            let x = i * 55 + xOffset
            makeBrick( x: x, y: y, color: .green)
        }
    }
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)

    }
    
    func makeLabels() {
        playLabel.fontSize = 24
        playLabel.text = "Tap to Start"
        playLabel.fontName = "Arial"
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        playLabel.name = "playLabel"
        addChild(playLabel)
        
        livesLabel.fontSize = 18
        livesLabel.fontColor = .black
        livesLabel.position = CGPoint(x: frame.minX + 50, y: frame.minY + 18)
        addChild(livesLabel)
        
        scoreLabel.fontSize = 18
        scoreLabel.fontColor = .black
        scoreLabel.fontName = "Arial"
        scoreLabel.position = CGPoint(x: frame.maxX - 50, y: frame.minY + 18)
    }
}
