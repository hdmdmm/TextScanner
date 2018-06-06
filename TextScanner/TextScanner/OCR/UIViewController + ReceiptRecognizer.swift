//
//  UIViewController + ReceiptRecognizer.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/5/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import GoogleMobileVision

protocol ReceiptRecognizer {
    var imageView: UIImageView? {get set}
    var scrollView: UIScrollView? {get set}
    var contentView: UIView? {get set}
}

extension ReceiptRecognizer where Self: UIViewController & ActivityProgress {
    var markersViewTag: Int {
        return 4000
    }

    fileprivate var markersView: UIView? {
        guard let markersView = self.view.viewWithTag(self.markersViewTag) else {
            let markersView = UIView(frame: CGRect.zero)
            markersView.backgroundColor = .clear
            markersView.tag = self.markersViewTag
            contentView?.addSubview(markersView)
            return markersView
        }
        return markersView
    }

    private var textDetector: GMVDetector {
        let orientations = GMVUtility.imageOrientation(from: UIDevice.current.orientation,
                                                       with: AVCaptureDevice.Position.back,
                                                       defaultDeviceOrientation: UIDeviceOrientation.faceUp)
        return GMVDetector(ofType: GMVDetectorTypeText, options: [GMVDetectorImageOrientation: orientations])
    }

    func doRecoginze(of imageView: UIImageView?) {
        guard let image = imageView?.image else {
            return print("Warninng nothing to recognize")
        }
        showActivity()
        let cleanupMarkersView = DispatchWorkItem(block: {
            self.markersView?.isHidden = true
            self.markersView?.subviews.forEach {
                $0.removeFromSuperview()
            }
        })
        let updateMarkersView = DispatchWorkItem(block: { [weak self] in
            guard let sself = self,
                let img = sself.fixOrientation(image) else {
                print("Ups seems we lost the image")
                return
            }
            let frameOfImage = sself.calculateRectOfImageInImageView(imageView: imageView)
            sself.markersView?.frame = frameOfImage
            sself.googleOCR(img).forEach { model in
                let view = RecognizedBlockMarkerView(model.bounds)
                view.delegate = sself as? RecognizedMarkerHandlerEvent
                view.model = model
                sself.markersView?.addSubview(view)
            }
        })
        let completion = DispatchWorkItem(block: { [weak self] in
            self?.markersView?.isHidden = false
            self?.hideActivity()
        })
        DispatchQueue.main.async(execute: cleanupMarkersView)
        DispatchQueue.main.async(execute: updateMarkersView)
        DispatchQueue.main.async(execute: completion)
    }

    private func googleOCR(_ image: UIImage) -> [RecognizedBlockMarkerModel] {
        var blocks = [RecognizedBlockMarkerModel]()
        let coefficient = displayCoefficient(of: imageView)
        textDetector.features(in: image, options: [:]).forEach { feature in
            guard let textBlock = feature as? GMVTextBlockFeature,
                let models = blockIntoLines(textBlock, coefficient) else {
                return
            }
            blocks.append(contentsOf: models)
        }
        return blocks
    }

    private func blockIntoLines(_ block: GMVTextBlockFeature, _ coefficient: CGFloat) -> [RecognizedBlockMarkerModel]?  {
        
        let models = block.lines.compactMap { textLine in
            return RecognizedBlockMarkerModel(bounds: textLine.bounds.multiply(coefficient), value: textLine.value)
        }
        return models
    }

    //
    // displayCoefficient
    // content mode of UIImageView should be scaleAspectFit
    //
    private func displayCoefficient(of imageView: UIImageView?) -> CGFloat {
        guard let size = imageView?.image?.size,
            let imageView = imageView else {
                print("Cant't calculate coefficient")
                return 1.0
        }
        return imageView.frame.size.width/size.width
    }

    private func fixOrientation(_ img: UIImage) -> UIImage? { // can be used for images that is rotated on 90 degree
        if img.imageOrientation == .up { return img }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }

    private func calculateRectOfImageInImageView(imageView: UIImageView?) -> CGRect {
        guard let imageView = imageView
            ,let imageSize = imageView.image?.size
//            ,let origin = imageView.superview?.frame.origin
            else {
                return CGRect.zero
        }
        let imageViewSize = imageView.frame.size
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0,
                               y: 0,
                               width: imageSize.width * aspect,
                               height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x// + origin.x
        imageRect.origin.y += imageView.frame.origin.y// + origin.y
        
        return imageRect
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print(markersView?.frame)
//        guard let markersView = markersView,
//            let imageView = imageView else {
//            return
//        }
//        imageView.frame = markersView.frame
        
//        print(markersView.frame)
//        //        markersView.frame = markersView.frame.multiply(scrollView.zoomScale + 1.0)
//        markersView.subviews.forEach {
//            guard let model = ($0 as? RecognizedBlockMarkerView)?.model else {
//                print("ups, looks like we lost the model of view.")
//                return
//            }
//            print(scrollView.zoomScale)
//            print(model.bounds)
//            let bounds = model.bounds.multiply(scrollView.zoomScale + 1.0)
//            print(bounds)
//            $0.frame = bounds
//        }
    }

    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        guard let imageSize = imageView?.image?.size else {return}
        let widthScale = imageSize.width / size.width
        let heightScale = imageSize.height / size.height
        let maxScale = max(widthScale, heightScale)

        scrollView?.minimumZoomScale = 1.0
        scrollView?.maximumZoomScale = maxScale
        scrollView?.zoomScale = 1.0
    }

}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: { [weak self] in
            if let size = self?.contentView?.bounds.size {
                self?.updateMinZoomScaleForSize(size)
            }
            self?.doRecoginze(of: self?.imageView)
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//extension UIImageView {
//    func visibleImage() -> UIImage? {
//        UIGraphicsBeginImageContext(self.frame.size)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//        context.rotate(by: CGFloat(2 * Double.pi))
//        layer.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//}
