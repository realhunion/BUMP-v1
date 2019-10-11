//
//  ChatInputContainerView.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import AVFoundation


class InputBarView: UIView {
    
    func shutDown() {
        self.chatVC = nil
    }
    
    weak var chatVC: ChatVC? {
        didSet {
            sendButton.addTarget(chatVC, action: #selector(ChatVC.handleSend), for: .touchUpInside)
            attachButton.addTarget(chatVC, action: #selector(ChatVC.handleHeyButton), for: .touchUpInside)
        }
    }
    
    lazy var inputTextView: UITextField = {
        let textView = UITextField()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = Constant.inputBarFont
        textView.layer.cornerRadius = 18
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        textView.leftView = paddingViewLeft
        textView.leftViewMode = UITextField.ViewMode.always
        
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: self.frame.height))
        textView.rightView = paddingViewRight
        textView.rightViewMode = UITextField.ViewMode.always
        
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.returnKeyType = UIReturnKeyType.send
        
        textView.placeholder = "Type a Message"
        
        textView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        return textView
    }()
    
    let attachButton: UIButton = {
        let attachButton = UIButton()
        attachButton.translatesAutoresizingMaskIntoConstraints = false
        
        attachButton.setTitle("🤙", for: .normal)
        attachButton.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
        
        return attachButton
    }()
    
    let sendButton: UIButton = {
        let sendButton = UIButton(type: .custom)
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.isEnabled = false
        
        return sendButton
    }()
    
    deinit {
        print("\nCHAT INPUT CONTAINER VIEW DID DE INIT\n")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("\nCHAT INPUT CONTAINER VIEW INIT\n")
        backgroundColor = UIColor.white
        self.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        
        addSubview(attachButton)
        addSubview(inputTextView)
        addSubview(sendButton)
        
        attachButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        attachButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        attachButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        attachButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: attachButton.rightAnchor, constant: 3).isActive = true
        
        
        sendButton.rightAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: -4).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: -4).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension InputBarView {
    
    func prepareForSend() {
        inputTextView.text = ""
        sendButton.isEnabled = false
    }
}

extension InputBarView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


extension InputBarView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chatVC?.scrollToBottom(at: .bottom, isAnimated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        chatVC?.scrollToBottom(at: .bottom, isAnimated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard sendButton.isEnabled else { return false }
        
        chatVC?.handleSend()
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if text == "" {
            sendButton.isEnabled = false
        } else if text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 140
    }

    
}





extension UIButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
