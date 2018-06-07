//
//  View-Layout.swift
//  DKhVMVCHelper
//
//  Created by Dmitry Khotyanovich on 11/15/17.
//  Copyright © 2017 Dmitry Khotyanovich. All rights reserved.
//

import UIKit

/*
How to use current extension
	let view = UIView()
	let label = UILabel()
	view.addSubview(label, constraints: [equal(\.leadingAnchor, 10),
										 equal(\.topAnchor, 20),
										 equal(\.trailingAnchor)])
*/
public typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                _ to: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
	return { view, parent in
		view[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
	}
}

public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
	return equal(keyPath, keyPath, constant: constant)
}

public func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
						  constant: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
	return { view, _ in
		view[keyPath: keyPath].constraint(equalToConstant: constant)
	}
}

public extension UIView { //Layout
	public func addSubview(_ child: UIView, constraints: [Constraint]) {
		addSubview(child)
		child.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints.map { $0(child, self) })
	}
	
	public func addSubviewWithAnchorsToSuperView(_ child: UIView) {
		self.addSubview(child, constraints: [equal(\.topAnchor),
											 equal(\.bottomAnchor),
											 equal(\.leftAnchor),
											 equal(\.rightAnchor)])
	}
}
