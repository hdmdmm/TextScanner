//
//  UIButton+IBDesignable.swift
//  OneDentity
//
//  Created by Dmitry Khotyanovich on 4/10/18.
//

import UIKit

@IBDesignable
extension UIButton {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }

    private func setup() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    open override func prepareForInterfaceBuilder() {
        setup()
    }
}
