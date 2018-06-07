//
//  UIViewController + ReceiptCapturerDelegate
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/7/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

extension UIViewController: ReceiptCaptureControllerDelegate {
    fileprivate var capture: ReceiptCaptureController {
        let captureController = ReceiptCaptureController()
        captureController.receiptCaptureDelegate = self
        return captureController
    }
    
    func handledCaptureResult(_ controller: ReceiptCaptureController?, image: UIImage) {
        guard let controller = self as? ReceiptRecognizer,
            let imageView = controller.imageView else {
                return
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: false, completion: { [weak self] in
            if let size = controller.contentView?.bounds.size {
                self?.updateMaxZoomScaleForSize(size)
            }
            controller.doRecoginze(of: controller.imageView)
        })
    }
    
    func handledError(_ controller: ReceiptCaptureController?, error: Error?) {
        dismiss(animated: false, completion: nil)
    }
    
    func startCapture() {
        let controller = UINavigationController(rootViewController: capture)
        present(controller, animated: false, completion: nil)
    }
}
