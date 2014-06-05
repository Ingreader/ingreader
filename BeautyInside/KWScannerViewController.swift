//
//  KWScannerViewController.swift
//  BeautyInside
//
//  Created by Kamila Wojciechowska on 05.06.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

import Foundation
import UIKit

class KWScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView
    @IBAction func takePicture(AnyObject) {
       
        let imagePicker: UIImagePickerController = UIImagePickerController()
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) ) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        imagePicker.delegate = self

        self.presentViewController(imagePicker, animated: true, nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){

        self.imageView.image = image
        
        self.dismissViewControllerAnimated(true, completion:nil)


    }
}