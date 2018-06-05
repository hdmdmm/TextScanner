//
//  ViewController.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/5/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView?
    
    @IBAction func addReceipt(_ sender: Any) {
        startScanning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: ReceiptRecognizer {
}
