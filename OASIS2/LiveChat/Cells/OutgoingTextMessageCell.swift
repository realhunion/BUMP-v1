//
//  OutgoingTextMessageCell.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

class OutgoingTextMessageCell: BaseMessageCell {

    
    func setupCell(message: Message) {
        
        self.textView.font = Constant.outMessageFont
        
        self.textView.textColor = UIColor.white
        
        textView.text = message.text
        
        bubbleView.frame = CGRect(x: frame.width - estimateFrameForText(message.text).width - 35,
                                  y: 0,
                                  width: estimateFrameForText(message.text).width + (Constant.leftRightBubbleSpacing*2),
                                  height: frame.size.height).integral
        
        textView.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
        
        if(estimateFrameForText(message.text).width <= Constant.minBubbleWidth) {
            textView.textAlignment = NSTextAlignment.center
        }
        
        bubbleView.backgroundColor = Constant.oBlueDark
    }
    
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(textView)
    }
    
    override func prepareViewsForReuse() {
        super.prepareViewsForReuse()
        textView.textAlignment = NSTextAlignment.natural
        textView.text = ""
    }
    
    

    
}
