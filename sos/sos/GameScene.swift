//
//  GameScene.swift
//  sos
//
//  Created by Philip McMahon on 8/16/17.
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let background = SKSpriteNode(imageNamed: "map2.png")
    var touchDown: CGPoint?
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        background.zPosition = 1
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(background)
        
        let cameraNode = SKCameraNode()
        
        cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(cameraNode)
        camera = cameraNode
        
        let zoomInAction = SKAction.scale(to: 0.5, duration: 1)
        cameraNode.run(zoomInAction)
    }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        touchDown = pos

    }
    
    func touchMoved(toPoint pos : CGPoint) {

        guard let td = self.touchDown else { return }
        let delta = CGPoint(x: pos.x - td.x, y: pos.y - td.y)
        var newPosition = CGPoint(x: background.position.x + delta.x,
                                  y: background.position.y + delta.y)
        newPosition = constrain(position: newPosition, toBackground: background)

        background.position = newPosition
        touchDown = pos
    }
    
    fileprivate func constrain(position: CGPoint, toBackground node: SKSpriteNode) -> CGPoint {
        
        var x = position.x
        var y = position.y
        
        if x > node.size.width / 2 {
           x = node.size.width / 2
        }
        
        if x < frame.size.width - node.size.width / 2 {
            x = frame.size.width - node.size.width / 2
        }
        
        if y > node.size.height / 2 {
            y = node.size.height / 2
        }
        
        if y < frame.size.height - node.size.height / 2 {
            y = frame.size.height - node.size.height / 2
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
