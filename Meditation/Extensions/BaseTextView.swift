//
//  BaseTextView.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit

protocol BaseTextViewDelegate: AnyObject {
    func didChancheSelection(_ textView: UITextView)
}

class BaseTextView: UITextView {
    
    private var customPadding = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 14)
    weak var baseDelegate: BaseTextViewDelegate?
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        label.font = .interItalic(size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    override var text: String! {
        didSet {
            togglePlaceholderVisibility()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = customPadding
        placeholderLabel.frame.origin = CGPoint(x: customPadding.left + 5, y: customPadding.top)
        placeholderLabel.frame.size.width = frame.width - (customPadding.left + customPadding.right + 10)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
        self.delegate = self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        addSubview(placeholderLabel)
        placeholderLabel.isHidden = !text.isEmpty
        togglePlaceholderVisibility()
    }
    
    private func togglePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

extension BaseTextView: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        baseDelegate?.didChancheSelection(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        togglePlaceholderVisibility()
    }
}
