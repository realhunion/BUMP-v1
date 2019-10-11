//
//  UserProfileEditView+DescriptionBox.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/1/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit

extension UserProfileEditView : UITextFieldDelegate {
    
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
            let textRange = Range(range, in: text) else { return false }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if textField.tag == 0 {
            if updatedText.count > 24 {
                return false
            } else {
                return true
            }
        }
        
        if textField.tag == 1 {
            self.userHandleTextField.textColor = UIColor.gray
            if updatedText.first != "@" {
                textField.text = "@"
                return true
            }
            else if updatedText == "@" {
                textField.text = ""
                return false
            } else if updatedText.count > 24 {
                return false
            } else {
                return true
            }
        }
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
}


extension UserProfileEditView : UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == self.descriptionPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.gray
            
        }
    }
    
    
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = self.descriptionPlaceholder
            textView.textColor = Constant.placeholderGray
        }
    }
    
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        let maxLines = 2
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        let textAttributes = [NSAttributedString.Key.font : textView.font!]
        
        var textWidth: CGFloat = textView.frame.insetBy(dx: textView.textContainerInset.left, dy: textView.textContainerInset.top).width
        
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding
        
        let boundingRect: CGRect = newText.boundingRect(with: CGSize(width: textWidth, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: textAttributes, context: nil)
        
        let numberOfLines = Int(floor(boundingRect.height / textView.font!.lineHeight))
        
        return numberOfLines <= maxLines
        
    }
    
}
