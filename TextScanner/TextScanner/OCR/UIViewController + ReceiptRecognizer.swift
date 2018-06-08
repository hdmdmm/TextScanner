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
    func doRecoginze(of imageView: UIImageView?)
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
        print(img.imageOrientation.rawValue)
        if img.imageOrientation == .up {
            return img
        }
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

extension UIViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        guard let controller = self as? ReceiptRecognizer else {
            return nil
        }
        return controller.contentView
    }

    func updateMaxZoomScaleForSize(_ size: CGSize) {
        guard let controller = self as? ReceiptRecognizer,
            let imageSize = controller.imageView?.image?.size else {return}
        let widthScale = imageSize.width / size.width
        let heightScale = imageSize.height / size.height
        let maxScale = max(widthScale, heightScale)
        controller.scrollView?.minimumZoomScale = 1.0
        controller.scrollView?.maximumZoomScale = maxScale
        controller.scrollView?.zoomScale = 1.3
    }
}

