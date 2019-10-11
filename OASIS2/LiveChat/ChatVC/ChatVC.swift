//  ChatLogVC.swift
//  OASIS2
//
//  Created by Honey on 5/25/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import SPStorkController
import QuickLayout

class ChatVC: UICollectionViewController, SPStorkControllerDelegate, UIGestureRecognizerDelegate {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("\n CHATVC is DE INIT \n")
    }
    
    
    let incomingTextMessageCellID = "incomingTextMessageCellID"
    let outgoingTextMessageCellID = "outgoingTextMessageCellID"
    
    var msgFetcher : MessageFetcher?
    var msgSender : MessageSender?
    
    var unseenUsersHere : [UserHere] = [] //Users not seen by user yet (usershere images)
    var last3HeyArray : [Date] = []
    
    var msgArray : [[Message]] = [] // Each item is Msg Group Array.
    
    var circleID : String = "Error Circle"
    var chatID : String = "testchat001"
    var circleName : String = "Error Circle"
    
    
    lazy var navBar: UINavigationBar = UINavigationBar()
    lazy var usersHereBar : UsersHereBarView = UsersHereBarView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var numUsersLiveLabel : UILabel = {
        
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        
        label.text = "0 here"
        label.tag = 0 // How many here
        
        label.isHidden = true
        
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let inputBarHeight : CGFloat = 50.0
    lazy var inputBarView: InputBarView = {
        var inputBarView = InputBarView()
        inputBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.inputBarHeight)
        inputBarView.translatesAutoresizingMaskIntoConstraints = false
        inputBarView.chatVC = self
        return inputBarView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputBarView.isUserInteractionEnabled = false
        self.startSpinner()
        
        self.setupCollectionView()
        self.setupNavBar()
        self.setupUsersHereBar()
        
        self.setupKeyboardObservers()
        
        self.msgSender = MessageSender(circleID: self.circleID, chatID: self.chatID)
        
        self.edgesForExtendedLayout = []

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.unseenUsersHere = []
        
        self.startUsersHereBar()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.startMessageFetcher()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeBadgeValue(override: true, by: 0)
        
        DispatchQueue.main.async {
            self.scrollToBottom(at: .bottom, isAnimated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.changeBadgeValue(override: true, by: 0)
        
        (UIApplication.shared.delegate as! AppDelegate).oasis?.homeTabBarVC.circleManager.willDismissChatVC()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("✋✋✋ view will dismiss")
        super.dismiss(animated: flag, completion: completion)
    }
    
    
    func shutDown () {
        
        self.usersHereBar.shutDown()

        self.inputBarView.shutDown()
        
        self.msgFetcher?.shutDown()
        
        self.stopSpinner()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    // MARK:- Spinner
    
    var spinner : UIActivityIndicatorView?
    func startSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.style = .white
        spinner?.color = Constant.mBlue
        spinner?.hidesWhenStopped = true
        self.collectionView.backgroundView = spinner
        self.spinner?.startAnimating()
    }
    func stopSpinner() {
        spinner?.stopAnimating()
        spinner = nil
    }
    
    
    
    
    
    
    // MARK: - Collection View Set-Up
    
    var inputBarBottomAnchor: NSLayoutConstraint?
    
    func setupCollectionView () {
        
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        collectionView.addGestureRecognizer(tapG)
        tapG.delegate = self
        
        view.backgroundColor = UIColor.white
        collectionView?.indicatorStyle = .default
        collectionView?.backgroundColor = view.backgroundColor
        collectionView?.contentInset = UIEdgeInsets(top: 44+47+10, left: 0, bottom: 10, right: 0)
        collectionView?.keyboardDismissMode = .none
        collectionView?.delaysContentTouches = false
        collectionView?.alwaysBounceVertical = true
        collectionView?.isPrefetchingEnabled = false
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(inputBarView)

        inputBarView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        inputBarView.heightAnchor.constraint(equalToConstant: self.inputBarHeight).isActive = true
        inputBarBottomAnchor = inputBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputBarBottomAnchor?.isActive = true
        
        
        
        collectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -self.inputBarHeight).isActive = true
//
        
        collectionView?.register(IncomingTextMessageCell.self, forCellWithReuseIdentifier: incomingTextMessageCellID)
        collectionView?.register(OutgoingTextMessageCell.self, forCellWithReuseIdentifier: outgoingTextMessageCellID)
        
        collectionView.isScrollEnabled = false
        
        collectionView.delegate = self
    }
    
    func scrollToBottom(at position: UICollectionView.ScrollPosition, isAnimated : Bool) {
        guard let lastMsgGroup = msgArray.last else { return }
        
        let item = lastMsgGroup.count - 1
        let section = msgArray.count - 1
        
        if(section < 0 || item < 0) {
            return
        }
        
        let indexPath = IndexPath(item: item, section: section)
        
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath, at: position, animated: isAnimated)
        }
    }
    

    
    
    
}
