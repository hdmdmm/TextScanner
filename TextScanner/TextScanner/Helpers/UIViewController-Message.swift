//
//  UIViewController+Error.swift
//  OneDentity
//
//  Created by Dmitry Khotyanovich on 2/19/18.
//

import UIKit


protocol Message {
}

typealias Action = () -> Swift.Void
extension Message where Self: UIViewController {

    func showMessage(_ title: String?, _ message: String?, okey: Action? = nil, cancel: Action? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: {_ in
                okey?()
            }))
        if cancel != nil {
            alert.addAction(
                UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                    cancel?()
                }))
        }
        present(alert, animated: true, completion: nil)
    }
}
