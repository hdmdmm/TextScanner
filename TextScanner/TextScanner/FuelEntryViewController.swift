//
//  FuleEntryViewController.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/8/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

class FuelEntryViewController: UIViewController {

    @IBAction func addReceiptActivated(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WizardViewController")
        present(UINavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    
}
