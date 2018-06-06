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
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var contentView: UIView?

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

extension ViewController: RecognizedMarkerHandlerEvent {
    func tapEventHandled(view: RecognizedBlockMarkerView,
                         model: RecognizedBlockMarkerModel?) {
        guard let model = model else {
            print("Recognized block model was not initialized")
            return
        }
        showMessage("Tapped text:", model.value)
    }
}

extension ViewController: ReceiptRecognizer{}
extension ViewController: Message{}
extension ViewController: ActivityProgress{}
