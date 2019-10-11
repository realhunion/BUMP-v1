//
//  UserProfileEditView+ImgPicker.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/1/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit
import FirebaseUI

extension UserProfileEditView  {
    
    
    @objc func imageEditButtonPressed() {
        
        let atr = Constant.fixedPopUpAttributes(heightWidthRatio: 1.0)
        SwiftEntryKit.display(entry: self.imagePicker, using: atr)
        
        
        var attributes = Constant.bottomPopUpAttributes
        attributes.precedence = .enqueue(priority: .normal)
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        SwiftEntryKit.display(entry: self, using: attributes)
        
    }
    
    
    
    
    func updateFirebaseUserImage(image : UIImage, completion:@escaping (_ userImagePath : String?)->Void){
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            
            let filePath = "User-Profile-Images/\(myUID).jpg"
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.storageRef.reference(withPath: filePath).putData(imageData, metadata: metadata) { (stoMeta, err) in
                guard err == nil else { completion(nil); return }
                
                completion(filePath)
                
            }
        
        }
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
        //FIX: clear only userProfileImage not all
    }
    
    func userImageSelected(image : UIImage?) {
        
        if let img = image {
            self.userImageView.image = img
//            self.updateFirebaseUserImage(image: img)
        }
        SwiftEntryKit.dismiss()
    }
    
    
    

}


extension UserProfileEditView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.userImageSelected(image: nil)
    }



    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            self.userImageSelected(image: nil)
            return
        }
        self.userImageSelected(image: image)
    }
}
