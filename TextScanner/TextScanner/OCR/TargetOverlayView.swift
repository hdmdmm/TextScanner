//
//  TargetOverlayView.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/7/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

class TargetOverlayView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let shiftX: CGFloat = 20.0
        let shiftY: CGFloat = 20.0
        let lineLength: CGFloat = 100.0
        let lineWidth: CGFloat = 8.0
        let cc = lineWidth/2
        
        //left down
        var startPoint = CGPoint(x: rect.origin.x + shiftX, y: rect.origin.y + (self.frame.height - 200) + shiftY)
        var endPoint = CGPoint(x: startPoint.x, y: startPoint.y + lineLength)
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        
        startPoint = endPoint
        startPoint.x -= cc
        endPoint = CGPoint(x: endPoint.x + lineLength, y: endPoint.y)
        endPoint.x += cc
        
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        //right down
        startPoint = CGPoint(x: self.frame.width - shiftX - lineLength, y: endPoint.y)
        endPoint = CGPoint(x: startPoint.x + lineLength, y: startPoint.y)
        
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        
        startPoint = endPoint
        startPoint.y += cc
        endPoint = CGPoint(x: startPoint.x, y: startPoint.y - lineLength)
        endPoint.y += cc
        
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        
        //right upper
        startPoint = CGPoint(x: endPoint.x, y: 100 + lineLength)
        endPoint = CGPoint(x: endPoint.x, y: startPoint.y - lineLength)
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        
        startPoint = endPoint
        startPoint.x += cc
        endPoint = CGPoint(x: startPoint.x - lineLength, y: startPoint.y)
        endPoint.x -= cc
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        
        //left upper
        startPoint = CGPoint(x: shiftX + lineLength, y: 100)
        endPoint = CGPoint(x: startPoint.x - lineLength, y: startPoint.y)
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
        startPoint = endPoint
        startPoint.y -= cc
        endPoint = CGPoint(x: startPoint.x, y: startPoint.y + lineLength)
        endPoint.y += cc
        drawLineFromPoint(start: startPoint,
                          toPoint: endPoint,
                          ofColor: tintColor,
                          inView: self)
    }
    
    func drawLineFromPoint(start : CGPoint,
                           toPoint end:CGPoint,
                           ofColor lineColor: UIColor,
                           inView view:UIView) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 8.0
        
        view.layer.addSublayer(shapeLayer)
    }
}

