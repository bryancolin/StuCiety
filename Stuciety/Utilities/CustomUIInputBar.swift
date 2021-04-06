//
//  iMessageInputBar.swift
//  Stuciety
//
//  Created by bryan colin on 4/5/21.
//

import UIKit
import InputBarAccessoryView

final class CustomUIInputBar: InputBarAccessoryView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        customInputTextView()
        
        setRightStackViewWidthConstant(to: 38, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        
        customSendButton()
        
        middleContentViewPadding.right = -38
        separatorLine.isHidden = true
        isTranslucent = false
    }
    
    func customInputTextView() {
        inputTextView.placeholder = "Enter a message"
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        
        let color = UIColor(named: K.BrandColors.purple)
        if #available(iOS 13, *) {
            inputTextView.layer.borderColor = color?.cgColor
        } else {
            inputTextView.layer.borderColor = color?.cgColor
        }
        
        inputTextView.backgroundColor = .clear
        
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 7.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func customSendButton() {
        sendButton.imageView?.backgroundColor = tintColor
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "send")
        sendButton.title = nil
        
        sendButton.backgroundColor = .clear
    }
    
}

