//
//  KWScannerViewController.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 05.06.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

import Foundation
import UIKit

class KWScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TesseractDelegate {
    @IBOutlet var activityIndicator: UIActivityIndicatorView;
    @IBOutlet var imageView: UIImageView
    var selectedImage = UIImage()
    var ocrResult = NSString()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.contentMode =  .ScaleAspectFit
    }
    
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
        self.selectedImage = image
        self.imageView.image = image
        picker.dismissViewControllerAnimated(true, completion:nil)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
             self.recognizeImage(image)
        }
    }
    
    func recognizeImage (image: UIImage) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        
        let tesseract:Tesseract  = Tesseract(language: "eng")
        tesseract.delegate = self;

        tesseract.setVariableValue("abcdefghijklmnopqrstuwxyz,()/01234567890", forKey:"tessedit_char_whitelist") //limit search
        tesseract.image =  image //image to check
        tesseract.recognize()
        ocrResult =  tesseract.recognizedText
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            var alert = UIAlertController(title:"Ingreadients found:", message: self.ocrResult,  preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "GReat!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    
    func shouldCancelImageRecognitionForTesseract(tesseract: Tesseract) -> Bool {
        println("progress_____________: \(tesseract.progress)");
        return false;  // return YES, if you need to interrupt tesseract before it finishes
    }
    
}