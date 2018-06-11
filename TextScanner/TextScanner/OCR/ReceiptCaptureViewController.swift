//
//  ReceiptCaptureViewController.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/7/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import AVFoundation

protocol ReceiptCaptureControllerDelegate: class {
    func handledCaptureResult(_ controller: ReceiptCaptureController?, image: UIImage)
    func handledError(_ controller: ReceiptCaptureController?, error: Error?)
    func canceled(_ controller: ReceiptCaptureController?)
}

class ReceiptCaptureController: UIViewController {
    let session = AVCaptureSession()
    let imageOutput = AVCaptureStillImageOutput()

    weak var receiptCaptureDelegate: ReceiptCaptureControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(exit))
        navigationItem.titleView = makeTitleView("Scan reciept")
        navigationController?.navigationBar.tintColor = .black

        // Initializing Capture Session
        initializeCaptureSession(on: self.view)

        //add view with target rect.
        let worker = DispatchWorkItem {
            let targetView = TargetOverlayView()
            targetView.backgroundColor = .clear
            targetView.tintColor = .black
            self.view.addSubviewWithAnchorsToSuperView(targetView)
        }
        DispatchQueue.main.async(execute: worker)

        //add button on bottom of screen
        let buttonInitializer = DispatchWorkItem  {
            let button = UIButton(frame: CGRect.zero)
            let attTitle = NSAttributedString(string: "CAPTURE", attributes: [.font : UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.thin),
                                                                              .foregroundColor : UIColor.white])
            button.setAttributedTitle(attTitle, for: .normal)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 10.0
            button.backgroundColor = .black
            self.view.addSubview(button, constraints: [equal(\.leftAnchor, constant: 40.0),
                                                       equal(\.rightAnchor, constant: -40.0),
                                                       equal(\.bottomAnchor, constant: -20.0),
                                                       equal(\.heightAnchor, constant: 36.0)])
            button.addTarget(self, action: #selector(self.didCaptureActivated), for: .touchUpInside)
        }
        DispatchQueue.main.async(execute: buttonInitializer)
    }
    
    private func initializeCaptureSession(on view: UIView) {
         let cameraInitializer = DispatchWorkItem { [weak self] in
            guard let sself = self,
                let camera = AVCaptureDevice.default(for: .video),
                let input = try? AVCaptureDeviceInput(device: camera),
                sself.session.canAddInput(input) else {
                print("Here is the problem. Back Camera device was not initialized as input device")
                return
            }
            sself.session.addInput(input)
            sself.imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if sself.session.canAddOutput(sself.imageOutput) {
                sself.session.sessionPreset = .photo
                sself.session.addOutput(sself.imageOutput)
            }
        }
        let previewInitializer = DispatchWorkItem { [weak self] in
            guard let sself = self else { return }
            // preview initializer
            let previewLayer = AVCaptureVideoPreviewLayer(session: sself.session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            view.layer.addSublayer(previewLayer)
            previewLayer.frame = sself.view.layer.frame
        }
        let startSession = DispatchWorkItem { [weak self] in
            guard let sself = self else { return }
            sself.session.startRunning()
        }
        DispatchQueue.main.async(execute: cameraInitializer)
        DispatchQueue.main.async(execute: previewInitializer)
        DispatchQueue.main.async(execute: startSession)
    }

    @objc private func exit() {
        canceled(self)
    }

    @objc private func didCaptureActivated() {
        if let videoConnection = imageOutput.connection(with: .video) {
            videoConnection.videoOrientation = .portrait
            imageOutput.captureStillImageAsynchronously(from: videoConnection) { [weak self] buffer, error in
                if let error = error {
                    print("Error catched from session: \(error)")
                    self?.receiptCaptureDelegate?.handledError(self, error: error)
                    return
                }
                guard let sampleBuffer = buffer,
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer),
                    let dataProvider = CGDataProvider(data: data as CFData),
                    let cgImage = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent) else {
                        
                    print("The AVCaptureSession returns nothing in the buffer.")
                    let error = NSError(domain: "\(#file)", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Buffer has wrong value"])
                    self?.receiptCaptureDelegate?.handledError(self, error: error)
                    return
                }
                
                let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: UIImageOrientation.right)
                self?.receiptCaptureDelegate?.handledCaptureResult(self, image: image)
            }
        }
    }
}
