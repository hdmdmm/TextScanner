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
    
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.videoQuality = .typeLow
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        return picker
    }()
    
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
    
    private func startScanning() {
        present(picker, animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: { [weak self] in
            self?.doRecoginze(of: self?.imageView)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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

extension ViewController: ReceiptRecognizer {}
extension ViewController: Message{}
extension ViewController: ActivityProgress{}
