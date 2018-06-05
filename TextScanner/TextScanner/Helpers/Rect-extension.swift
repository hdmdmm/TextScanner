//
//  Rect-extension.swift
//  Receipts
//
//  Created by Dmitry Khotyanovich on 6/5/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

extension CGRect {
    func multiply(_ multiplier: CGFloat) -> CGRect {
        let point = CGPoint(x: self.origin.x * multiplier, y: self.origin.y * multiplier)
        let size = CGSize(width: self.size.width * multiplier, height: self.size.height * multiplier)
        return CGRect(origin: point, size: size)
    }
}
