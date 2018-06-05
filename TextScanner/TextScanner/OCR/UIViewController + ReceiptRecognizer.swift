//
//  UIViewController + ReceiptRecognizer.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/5/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

protocol ReceiptRecognizer {
    var imageView: UIImageView? {get set}
}

extension ReceiptRecognizer where Self: UIViewController {
    
    private var picker: UIImagePickerController {
        let picker = UIImagePickerController()
        picker.videoQuality = .typeLow
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self as? UINavigationControllerDelegate&UIImagePickerControllerDelegate
        return picker
    }
    
    func startScanning() {
        present(picker, animated: true, completion: nil)
    }
    
    private func doRecoginze(of imageView: UIImageView?) {
        
    }
}

extension ReceiptRecognizer where Self: UIViewController & UIImagePickerControllerDelegate {
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

extension ReceiptRecognizer where Self: UINavigationControllerDelegate {}


