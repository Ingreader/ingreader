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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ocrProgress: UIProgressView!
    var selectedImage = UIImage()
    var ocrResult = NSString()
    
    }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.contentMode =  .ScaleAspectFit
        self.ocrProgress.progress = 0.0
        self.ocrProgress.hidden = true
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

    @IBAction func owsiar(AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
                    self.ocrProgress.hidden = false
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.recognizeImage(self.selectedImage)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.ocrProgress.hidden = true
            }
        }
    }
    
    @IBAction func sharpening(AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = KWFilters.sharpenImage(self.imageView.image!)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.selectedImage = result
                self.imageView.image = result
            }
        }
    }
    
    @IBAction func monochrome(AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
           let result = KWFilters.binarizeImage(self.imageView.image)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.selectedImage = result
                self.imageView.image = result
            }
        }
    }
    
    @IBAction func binarize(AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = KWFilters.customBinarizeImage(self.imageView.image)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.selectedImage = result
                self.imageView.image = result
            }
        }
    }
    

    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.selectedImage = image
        self.imageView.image = image
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func recognizeImage (image: UIImage) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        
        let tesseract:Tesseract  = Tesseract(language: "eng")
        tesseract.delegate = self

        tesseract.setVariableValue("abcdefghijklmnopqrstuwxyz,()/01234567890", forKey:"tessedit_char_whitelist") //limit search
        tesseract.image =  image //image to check
        tesseract.recognize()
        ocrResult =  tesseract.recognizedText
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            var alert = UIAlertController(title:"Ingreadients found:", message: self.ocrResult,  preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    


    }
    
}
extension KWScannerViewController: G8TesseractDelegate {
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract) -> Bool {
        var percent = CFloat(tesseract.progress)/100.0
        var progressPercentString = NSString(format:"%.03f", (CFloat(tesseract.progress)/100.0))
        var progressPercent = CFloat(progressPercentString.doubleValue)
        self.ocrProgress.setProgress(percent, animated: true)
        println("progress_____________: \(self.ocrProgress.progress) --  \(CFloat(progressPercentString.doubleValue)) --- \(progressPercentString)");
        return false;  // return YES, if you need to interrupt tesseract before it finishes
    }
}
