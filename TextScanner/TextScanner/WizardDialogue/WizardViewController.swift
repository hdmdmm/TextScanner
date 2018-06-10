//
//  ViewController.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/5/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WizardViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var contentView: UIView?

    @IBOutlet weak var dialogueView: WizardDialogueView!

    // model can be injected
    var model: WizardViewModel?
    
    private var disposalBag = DisposeBag()
    
    func inject(model: WizardViewModel?) {
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(exit))
        navigationItem.titleView = makeTitleView(model?.title)
        navigationController?.navigationBar.tintColor = .black

        DispatchQueue.main.async {
            self.startCapture()  //over AVFoundation with custom overlays
//            self.startScanning() //over Image Picker
        }

        model?.isFinished
            .asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.exit()
                }
            })
            .disposed(by: disposalBag)
    }
    
    private func makeTitleView(_ title: String?) -> UILabel? {
        guard let title = title else { return nil}
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        let attTitle = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.black,
                                                                             .font: font])

        label.attributedText = attTitle
        return label
    }
    
    @objc func exit() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addReceipt(_ sender: Any) {
//        startScanning()   //over Image Picker
        startCapture()  //over AVFoundation with custom overlays
    }
    
    func showUpWizard() {
        dialogueView.setup(model: model)
        dialogueView.isHidden = false
    }
}

extension WizardViewController: ReceiptRecognizerHandler {
    func recognitionCompleted() {
        //show wizard
        showUpWizard()
    }
    
    func recognitionCanceled() {
        dismiss(animated: false, completion: nil)
    }
}

extension WizardViewController: RecognizedMarkerHandlerEvent {
    func tapEventHandled(view: RecognizedBlockMarkerView,
                         model: RecognizedBlockMarkerModel?) {
        guard let model = model else {
            print("Recognized block model was not initialized")
            return
        }
        showMessage("Tapped text:", model.value)
    }
}

extension WizardViewController: ReceiptRecognizer{}
extension WizardViewController: Message{}
extension WizardViewController: ActivityProgress{}
