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

class WizardDialogueView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressIndicator: WizardProgresIndicatorView!

    private var model: ViewModel?
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
        backButton.addTarget(self, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
    }
    
    func setup(model: ViewModel) {
        title.text = model.value()?.title
        value.text = model.value()?.value
        backButton.isHidden = !model.isBackValue
        nextButton.setTitle(model.isNextValue ? "Next" : "Finish", for: .normal)
        progressIndicator.index = model.currentIndex
        self.model = model
    }
}
