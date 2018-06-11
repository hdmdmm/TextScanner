//
//  FuleEntryViewController.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/8/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

class FuelEntryViewController: UIViewController {
    
    var wizardViewModel = WizardViewModel(title: "Fuel entry",
                                          values: [ValueModel(title: "Price total ($)", value: nil),
                                                   ValueModel(title: "Amount (L)", value: nil),
                                                   ValueModel(title: "Date", value: nil),
                                                   ValueModel(title: "Address", value: nil)] )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = makeTitleView("Fuel Entry")
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Display Data from wizardViewModel
        print(wizardViewModel.values.value)
    }

    @IBAction func addReceiptActivated(_ sender: Any) {
        let vc = WizardViewController(nibName: "WizardViewController", bundle: nil)
        vc.inject(model: wizardViewModel)
        present(UINavigationController(rootViewController: vc), animated: false, completion: nil)
    }
}
