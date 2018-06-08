//
//  WizardProgresIndicatorView.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/8/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

@IBDesignable
class WizardProgresIndicatorView: UIView {

    @IBInspectable
    var index: Int = 2 {
        didSet {
            if index < dots {
                setNeedsDisplay()
                return
            }
            index = dots-1
        }
    }

    @IBInspectable
    var passColor: UIColor = .red

    @IBInspectable
    var currentColor: UIColor = .green
    
    @IBInspectable
    var defaultColor: UIColor = .darkGray
    
    @IBInspectable
    var dotRadius: CGFloat = 5.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var dots: Int = 4 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let begin = dots % 2 == 0
            ? CGPoint(x: center.x - dotRadius/2 * (CGFloat(3 * dots) - 2) - dotRadius/2, y: rect.height/2 - dotRadius)
            : CGPoint(x: center.x - dotRadius * (CGFloat(dots) + CGFloat(dots/2)), y: rect.height/2 - dotRadius)
        
        (0..<dots).forEach { i in
            let layer = CAShapeLayer()
            let shift = 3 * dotRadius * CGFloat(i)
            let origin = CGPoint(x: begin.x + shift, y: begin.y)
            let rect = CGRect(origin: origin, size: CGSize(width: dotRadius * 2, height: dotRadius * 2))
            layer.path = UIBezierPath(ovalIn: rect).cgPath
            layer.fillColor = i < index ? passColor.cgColor
                            : i == index ? currentColor.cgColor
                            : defaultColor.cgColor
            self.layer.addSublayer(layer)
        }
    }
}
