//
//  ViewModel.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/8/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RxSwift

struct ValueModel {
    let title: String
    var value: String?
}

class WizardViewModel {
    var values: [ValueModel]?
    var title: String?
    var currentIndex = Variable<Int>(0)
    var isFinished = Variable<Bool>(false)

    /// swinject actual here
    ///
    init(title: String?, values: [ValueModel]) {
        self.title = title
        self.values = values
    }
    
    var isNextValue: Bool {
        guard let values = values else {return false}
        return currentIndex.value + 1 < values.endIndex
    }
    
    var isBackValue: Bool {
        return !(currentIndex.value == 0)
    }
    
    func value() -> ValueModel? {
        guard let values = values else { return nil }
        return values[currentIndex.value]
    }
    
    func nextValue() -> ValueModel? {
        guard isNextValue else {
            return nil
        }
        currentIndex.value += 1
        return values?[currentIndex.value]
    }
    
    func previousValue() -> ValueModel? {
        guard isBackValue else {
            return nil
        }
        currentIndex.value -= 1
        return values?[currentIndex.value]
    }
}
