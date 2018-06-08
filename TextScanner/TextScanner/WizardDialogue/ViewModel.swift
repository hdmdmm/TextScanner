//
//  ViewModel.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/8/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

struct ValueModel {
    let title: String
    var value: String?
}

struct ViewModel {
    var values: [ValueModel]?
    var title: String?
    var currentIndex: Int = 0

    /// swinject actual here
    ///
    init(/* data provider as DataLayer */) {
        /* values = dataProvider.fuelValue */
        title = "Fuel entry"
        values = [ValueModel(title: "Price total ($)", value: nil),
                  ValueModel(title: "Amount (L)", value: nil),
                  ValueModel(title: "Date", value: nil),
                  ValueModel(title: "Address", value: nil)]
    }
    
    var isNextValue: Bool {
        guard let values = values else {return false}
        return currentIndex+1 <= values.endIndex
    }
    var isBackValue: Bool {
        return !(currentIndex == 0)
    }
    
    func value() -> ValueModel? {
        guard let values = values else { return nil }
        return values[currentIndex]
    }
    mutating func nextValue() -> ValueModel? {
        guard isNextValue else {
            return nil
        }
        currentIndex += 1
        return values?[currentIndex]
    }
    mutating func previousValue() -> ValueModel? {
        guard isBackValue else {
            return nil
        }
        currentIndex -= 1
        return values?[currentIndex]
    }
}
