//
//  ActivityView.swift
//  OneDentity
//
//  Created by Dmitry Khotyanovich on 2/20/18.
//

import UIKit

@objc
protocol ActivityProgress: NSObjectProtocol {
    @objc optional func showActivity()
    @objc optional func hideActivity()
}

extension ActivityProgress where Self: UIViewController {
    var activityProgressTag: Int {
        return 1000
    }

    func showActivity() {
        guard let view = self.view.viewWithTag(activityProgressTag) else {
            setupActivity()
            return
        }
        view.isHidden = false
    }

    func hideActivity() {
        guard let view = self.view.viewWithTag(activityProgressTag) else {
            return
        }
        view.isHidden = true
    }

    private func setupActivity() {
        let view = UIView(frame: CGRect.zero)
        view.tag = activityProgressTag
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubviewWithAnchorsToSuperView(view)
        let activity = UIActivityIndicatorView()
        view.addSubview(activity, constraints: [equal(\.centerXAnchor),
                                                     equal(\.centerYAnchor)])
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.startAnimating()
    }
}
