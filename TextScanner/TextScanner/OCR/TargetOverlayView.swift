//
//  TargetOverlayView.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/7/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TargetOverlayView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let shiftX: CGFloat = 20.0
        let shiftY: CGFloat = 20.0
        let lineLength: CGFloat = 100.0
        let lineWidth: CGFloat = 8.0
        let cc = lineWidth/2
        let upShift: CGFloat = 100.0
        let dwnShift: CGFloat = 200.0
        
        struct Points {
            let start: CGPoint
            let end: CGPoint
        }
                                //left down
        let lines: [Points] = [ .init( start: CGPoint(x: rect.minX + shiftX,                   y: rect.maxY - dwnShift + shiftY),
                                       end:   CGPoint(x: rect.minX + shiftX,                   y: rect.maxY - dwnShift + shiftY + lineLength)),
                                .init( start: CGPoint(x: rect.minX + shiftX - cc,              y: rect.maxY - dwnShift + shiftY + lineLength),
                                       end:   CGPoint(x: rect.minX + shiftX + lineLength + cc, y: rect.maxY - dwnShift + shiftY + lineLength)),
                                //right down
                                .init( start: CGPoint(x: rect.maxX - shiftX - lineLength,      y: rect.maxY - dwnShift + shiftY + lineLength),
                                       end:   CGPoint(x: rect.maxX - shiftX,                   y: rect.maxY - dwnShift + shiftY + lineLength)),
                                .init( start: CGPoint(x: rect.maxX - shiftX,                   y: rect.maxY - dwnShift + shiftY + lineLength + cc),
                                       end:   CGPoint(x: rect.maxX - shiftX,                   y: rect.maxY - dwnShift + shiftY - cc)),
                                //right upper
                                .init( start: CGPoint(x: rect.maxX - shiftX,                   y: upShift + lineLength),
                                       end:   CGPoint(x: rect.maxX - shiftX,                   y: upShift)),
                                .init( start: CGPoint(x: rect.maxX - shiftX + cc,              y: upShift),
                                       end:   CGPoint(x: rect.maxX - shiftX - lineLength - cc, y: upShift)),
                                //left upper
                                .init( start: CGPoint(x: rect.minX + shiftX + lineLength,      y: upShift),
                                       end:   CGPoint(x: rect.minX + shiftX,                   y: upShift)),
                                .init( start: CGPoint(x: rect.minX + shiftX,                   y: upShift - cc),
                                       end:   CGPoint(x: rect.minX + shiftX,                   y: upShift + lineLength + cc))
                                ]
        
        Observable.from(lines).subscribe { points in
            guard let points = points.element else {return}
            self.drawLineFromPoint(start: points.start, toPoint: points.end, ofColor: self.tintColor, inView: self)
        }.dispose()
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

