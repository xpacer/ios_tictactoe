//
//  GameScene.swift
//  TicTacToe
//
//  Created by Adedamola Adeniran on 04/04/2018.
//  Copyright © 2018 Adedamola Adeniran. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameBoard : Board!
    var stateMachine: GKStateMachine!
    var ai: GKMinmaxStrategist!
    
    override func didMove(to view: SKView) {
        
        self.enumerateChildNodes(withName: "//grid*" , using: { (node, stop) in
            if let node = node as? SKSpriteNode{
                node.color = .clear
            }
        })
        
        let top_left: BoardCell  = BoardCell(value: .None, node: "//*top_left")
        let top_middle: BoardCell = BoardCell(value: .None, node: "//*top_middle")
        let top_right: BoardCell = BoardCell(value: .None, node: "//*top_right")
        let middle_left: BoardCell = BoardCell(value: .None, node: "//*middle_left")
        let center: BoardCell = BoardCell(value: .None, node: "//*center")
        let middle_right: BoardCell = BoardCell(value: .None, node: "//*middle_right")
        let bottom_left: BoardCell = BoardCell(value: .None, node: "//*bottom_left")
        let bottom_middle: BoardCell = BoardCell(value: .None, node: "//*bottom_middle")
        let bottom_right: BoardCell = BoardCell(value: .None, node: "//*bottom_right")
        /** Creating Gameboard **/
        let board = [top_left, top_middle, top_right, middle_left, center, middle_right, bottom_left, bottom_middle, bottom_right]
        
        gameBoard = Board(gameboard: board)
        /** Initialising AI Player **/
        ai = GKMinmaxStrategist()
        ai.maxLookAheadDepth = 9
        ai.randomSource = GKARC4RandomSource()
        
        let beginGameState = StartGameState(scene: self)
        let activeGameState = ActiveGameState(scene: self)
        let endGameState = EndGameState(scene: self)
        
        stateMachine = GKStateMachine(states: [beginGameState, activeGameState, endGameState])
        stateMachine.enter(StartGameState.self)
    
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let selectedNode = self.atPoint(location)
            var node: SKSpriteNode
            
            if let name = selectedNode.name {
                if name == "Reset" || name == "resetLabel"{
                    self.stateMachine.enter(StartGameState.self)
                    return
                }
            }
        
            if gameBoard.isPlayerOne(){
                let cross = SKSpriteNode(imageNamed: "X_symbol")
                cross.size = CGSize(width: 75, height: 75)
                cross.zRotation = CGFloat(.pi / 4.0)
                node = cross
            } else{
                let circle = SKSpriteNode(imageNamed: "O_symbol")
                circle.size = CGSize(width: 75, height: 75)
                node = circle
            }
            
            
            for i in 0...8{
                guard let cellNode: SKSpriteNode = self.childNode(withName: gameBoard.getElementAtBoardLocation(index: i).node) as? SKSpriteNode else{
                    return
                }
                
                if selectedNode.name == cellNode.name{
                    cellNode.addChild(node)
                    gameBoard.addPlayerValueAtBoardLocation(index: i, value: gameBoard.isPlayerOne() ? .X : .O)
                    gameBoard.togglePlayer()
                }
            }
        }
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
        self.stateMachine.update(deltaTime: currentTime)
    }
}
