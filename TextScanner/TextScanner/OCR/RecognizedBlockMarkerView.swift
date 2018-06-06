//
//  RecognizedBlockView.swift
//  Receipts
//
//  Created by Dmitry Khotyanovich on 6/5/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

protocol RecognizedMarkerHandlerEvent {
    func tapEventHandled(view: RecognizedBlockMarkerView, model: RecognizedBlockMarkerModel?)
}

class RecognizedBlockMarkerView: UIView {
    var delegate: RecognizedMarkerHandlerEvent? = nil
    var model: RecognizedBlockMarkerModel? = nil
    
    convenience init(_ frame: CGRect) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:))))
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        delegate?.tapEventHandled(view: self, model: model)
    }
}
