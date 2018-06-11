//
//  UIViewController-titleView.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/11/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

extension UIViewController {

    func makeTitleView(_ title: String?) -> UILabel? {
        guard let title = title else { return nil}
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        let attTitle = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.black,
                                                                             .font: font])
        
        label.attributedText = attTitle
        return label
    }

}
