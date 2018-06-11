//
//  WizardDialogueView.swift
//  TextScanner
//
//  Created by Dmitry Khotyanovich on 6/8/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol WizardDialogueHandler {
    func handledFinisheEvent(view: WizardDialogueView)
}

class WizardDialogueView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressIndicator: WizardProgresIndicatorView!

    var disposeBag = DisposeBag()

    private var model: WizardViewModel?
    private var contentView: UIView?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        addSubviewWithAnchorsToSuperView(view)
        contentView = view
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: WizardDialogueView.self), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backButton.addTarget(self,
                             action:#selector(backButtonActivated(_:)), for: .touchUpInside)
        nextButton.addTarget(self,
                             action: #selector(nextButtonActivated(_:)), for: .touchUpInside)
    }
    
    func setup(model: WizardViewModel?) {
        setupValues(model?.value())
        setupButtons()
        self.model = model

        model?.currentIndex
            .asObservable()
            .bind(onNext: { index in
                self.progressIndicator.index = index
            }).disposed(by: disposeBag)
        
        model?.values
            .asObservable()
            .bind(onNext: { values in
                guard let index = model?.currentIndex else { return }
                self.value.text = values[index.value].value
        }).disposed(by: disposeBag)
        
        value.rx
            .didEndEditing
            .map { self.value }
            .bind { textView in
                guard let index = model?.currentIndex.value else { return }
                self.model?.values.value[index].value = textView?.text
            }
            .disposed(by: disposeBag)
    }
    
    private func setupValues(_ valueModel: ValueModel?) {
        title.text = valueModel?.title
        value.text = valueModel?.value
    }
    
    @objc private func backButtonActivated(_ sender: UIButton) {
        setupValues(model?.previousValue())
        setupButtons()
    }
    
    @objc private func nextButtonActivated(_ sender: UIButton) {
        setupValues(model?.nextValue())
        setupButtons()
    }
    
    @objc private func finishButtonActivated(_ sender: UIButton) {
        model?.isFinished.value = true
    }
    
    private func setupButtons() {
        guard let model = model else { return }
        backButton.isHidden = !model.isBackValue
        if model.isNextValue {
            setupNextButton()
        } else {
            setupFinishButton()
        }
    }
    
    private func setupNextButton() {
        nextButton.removeTarget(self, action: nil, for: .allEvents)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonActivated(_:)), for: .touchUpInside)
    }
    
    private func setupFinishButton() {
        nextButton.removeTarget(self, action: nil, for: .allEvents)
        nextButton.setTitle("Finish", for: .normal)
        nextButton.addTarget(self, action: #selector(finishButtonActivated(_:)), for: .touchUpInside)
    }
}
