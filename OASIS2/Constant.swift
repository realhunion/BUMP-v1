//
//  Constant.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import SwiftEntryKit


enum Constant {
    
    static let credits = "Wouldn't be possible without some really clutch opensource github repositories.\n\n1. Google Firebase\n2. LayoutKit \n3. SwiftEntryKit\n4. Reachability Swift\n\nSoftware Licenses : https://hastebin.com/emepeqofam.sql"
    static let contactInfo = "Please email alhunai@grinnell.edu if experiencing any problems."
    static let privacyInfo = "1. The app uses the Google Firebase Analytics API to collect data on app's performance.\n2. The app uses Google Firebase Authentication system to store username and password keys privately, inaccessible to app admin directly.\n3. The app uses Google Firebase to store all user-generated data sent to and from the app.\n4. Only app administrator will have root access to database.\n5. To delete account all all associated data, please send email to contact email for further instructions.\n6. App admin has privilege to remove any user from platform who indulges in toxic behavior, at the admin's discretion.\n7. App is not liable for actions of users on the platform.\n8. App is not liable for damage to any user in any way or form stemming from platform."
    
    static func logTimestamp(label:String="") {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss.SSS"
        let x = (formatter.string(from: Date()) as NSString) as String
        print("x_\(label)_ \(x)")
    }
    
    static let messageFont : UIFont = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    static let outMessageFont : UIFont = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        //UIFont(name: "HelveticaNeue", size: 17.0)!
    
    static let inputBarFont : UIFont = UIFont.systemFont(ofSize: 16.0)
    
    static let topBottomBubbleSpacing : CGFloat = 8.0
    static let leftRightBubbleSpacing : CGFloat = 12.5
    static let incomingBubbleMargin : CGFloat = 15.0
    static let outgoingBubbleMargin : CGFloat = 10.0
    
    static let minBubbleWidth : CGFloat = 16.0
    static let maxBubbleWidth : CGFloat = UIScreen.main.bounds.width*(6/10)
    
    static let oBlueLight = UIColor(red:0.00, green:0.80, blue:1.00, alpha:1.0)
    static let oBlue = UIColor(red:0.00, green:0.71, blue:1.00, alpha:1.0)
    static let oBlueMedium = UIColor(red:0.10, green:0.68, blue:0.96, alpha:1.0)
    static let oBlueDark = UIColor(red:0.00, green:0.65, blue:1.00, alpha:1.0)
    
    
    static let myGrayColor = UIColor(red:0.905, green:0.91, blue:0.925, alpha:1.0)
    static let myBlackColor = UIColor(red:0.08, green:0.09, blue:0.10, alpha:1.0)
    static let mBlue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    static let vividRed = UIColor(red:1.00, green:0.00, blue:0.32, alpha:1.0)
    
    static let pantPurple = UIColor(red:0.97, green:0.14, blue:0.54, alpha:1.0)
    
    static let coolBlue = UIColor(red:0.16, green:0.38, blue:1.00, alpha:1.0)
    
    static let coolGray = UIColor(red:0.93, green:0.935, blue:0.94, alpha:1.0)
    static let coolestGray = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    static let placeholderGray = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
    static let chillGreen = UIColor(red:0.12, green:0.83, blue:0.38, alpha:1.0)
    
    
    static let bottomPopUpAttributes : EKAttributes = {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.none
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [UIColor.white, UIColor.white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: UIColor.black.withAlphaComponent(0.4))
        //attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))
        
        return attributes
    }()
    
    static let centerPopUpAttributes : EKAttributes = {
        var attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.none
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [UIColor.white, UIColor.white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: UIColor.black.withAlphaComponent(0.4))
        //attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))
        
        return attributes
    }()
    
    static func fixedPopUpAttributes(heightWidthRatio : CGFloat) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [UIColor.white, UIColor.white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: UIColor.black.withAlphaComponent(0.4))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .constant(value: UIScreen.main.bounds.width * heightWidthRatio))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))
        
        return attributes
    }
    
    static func fixedPopUpAttributes(height : CGFloat) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [UIColor.white, UIColor.white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: UIColor.black.withAlphaComponent(0.4))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 18.0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.15))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 10), height: .constant(value: height))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .constant(value: UIScreen.main.bounds.height))
        
        return attributes
    }

}


extension UserDefaults {
    
    func clearUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
}


class MyTapGestureRecognizer: UITapGestureRecognizer {
    var stringTag: String?
}


extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}



extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}




extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}




class ProgressBlurHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    deinit {
        print("Prog deinit")
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .prominent)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}


class ProgressHUD: UIView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    
    deinit {
        print("Prog deinit")
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
    let label: UILabel = UILabel()
    
    init(text: String, color : UIColor) {
        self.text = text
        self.color = color
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.color = Constant.myBlackColor
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.addSubview(activityIndictor)
        self.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            
            self.backgroundColor = self.color ?? Constant.myBlackColor
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}


class LabelHUD: UIView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    deinit {
        print("Prog deinit")
    }
    
    let label: UILabel = UILabel()
    
    init(text: String) {
        self.text = text
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.addSubview(label)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: 0,
                                 y: 0,
                                 width: width,
                                 height: height)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 15)
            
            self.backgroundColor = Constant.myBlackColor
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
