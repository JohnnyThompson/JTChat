//
//  EmittedViewController.swift
//  JTChat
//
//  Created by Evgeny on 05.05.2022.
//

import UIKit

class EmittedViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Private properties
    
    private var tinkoffEmitterLayer = CAEmitterLayer()
    private lazy var emittedCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "TinkoffImage")?.cgImage

        cell.scale = 0.55
        cell.scaleSpeed = -0.1
        
        cell.alphaSpeed = -0.2
        
        cell.birthRate = 10
        
        cell.lifetime = 3
        cell.lifetimeRange = 1
        
        cell.velocityRange = -20
        
        cell.yAcceleration = -20
        
        return cell
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
        tinkoffEmitterLayer = createEmitterLayer()
    }
    
    // MARK: - Private methods
    
    private func createEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterSize = CGSize(width: 60, height: 60)
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterDepth = -0.3
        emitterLayer.emitterCells = [emittedCell]
        return emitterLayer
    }
    
    // MARK: - Actions
    
    @objc
    private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let position = gestureRecognizer.location(in: self.view)
        
        if gestureRecognizer.state == .began {
            tinkoffEmitterLayer = createEmitterLayer()
            tinkoffEmitterLayer.emitterPosition = position
            self.view.layer.addSublayer(self.tinkoffEmitterLayer)
        }
        
        if gestureRecognizer.state == .changed {
            tinkoffEmitterLayer.emitterPosition = position
        }
        
        if gestureRecognizer.state == .ended {
            tinkoffEmitterLayer.birthRate = 0
            return
        }
    }
}
