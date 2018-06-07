//
//  UIViewController + ImagePickerExtension.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/7/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    fileprivate var picker: UIImagePickerController {
        let picker = UIImagePickerController()
        picker.videoQuality = .typeLow
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        return picker
    }
    
    func startScanning() {
        present(picker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let controller = self as? ReceiptRecognizer,
            let imageView = controller.imageView else {
                return
        }
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: { [weak self] in
            if let size = controller.contentView?.bounds.size {
                self?.updateMaxZoomScaleForSize(size)
            }
            controller.doRecoginze(of: controller.imageView)
        })
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


