//
//  InfoTextView.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit

class InfoTextView: UIView {

    lazy var textView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        textView.textColor = UIColor.darkGray
        
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        textView.isScrollEnabled = true
        return textView
    }()
    
    
    
    public init(text : String) {
        super.init(frame: UIScreen.main.bounds)
        
        self.textView.text = text
        setupTextView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTextView() {
        
        addSubview(textView)
        textView.layoutToSuperview(.top, offset: 20)
        textView.layoutToSuperview(.left, offset: 20)
        textView.layoutToSuperview(.right, offset: -20)
        textView.layoutToSuperview(.bottom, offset: -20)
        
    }
    

}
