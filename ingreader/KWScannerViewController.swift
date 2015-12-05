//
//  KWScannerViewController.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 05.06.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

import Foundation
import UIKit

class KWScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ocrProgress: UIProgressView!
    @IBOutlet weak var ocrButton: UIBarButtonItem!
    var selectedImage = UIImage()
    var ocrResult = NSString()
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.contentMode =  .ScaleAspectFit
        self.ocrProgress.progress = 0.0
        self.ocrProgress.hidden = true
    }
    
    @IBAction func takePicture(_: AnyObject) {

        let imagePickerActionSheet = UIAlertController(title: "Take photo or select exsiting?",
            message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                style: .Default) { (alert) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker,
                        animated: true,
                        completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose Existing",
            style: .Default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker,
                    animated: true,
                    completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel",
            style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        presentViewController(imagePickerActionSheet, animated: true,
            completion: nil)
    }

    @IBAction func owsiar(_: AnyObject) {
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
    
    @IBAction func sharpening(_: AnyObject) {
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
    
    @IBAction func monochrome(_: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if (self.imageView.image != nil) {
                let result = KWFilters.binarizeImage(self.imageView.image!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.selectedImage = result
                    self.imageView.image = result
                }
            }
        }
    }
    
    @IBAction func binarize(_: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = KWFilters.customBinarizeImage(self.imageView.image!)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.selectedImage = result
                self.imageView.image = result
            }
        }
    }
    
    func recognizeImage (image: UIImage) -> Void {

        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
        }

        let tesseract = G8Tesseract(language:"eng")
        tesseract.delegate = self
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()

        tesseract.charWhitelist = "abcdefghijklmnopqrstuwxyz,()/01234567890" //limit search
        tesseract.image =  image //image to check
        tesseract.recognize()


        
        ocrResult =  tesseract.recognizedText
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
              self.performSegueWithIdentifier("Present Ingredients List", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Present Ingredients List" {
            let viewController:KWIngredientsListViewController = segue.destinationViewController as! KWIngredientsListViewController
            viewController.ocrResult = self.ocrResult;
        }
    }
        
    //Image proecessing
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }

}

extension KWScannerViewController {
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
            self.selectedImage = image
            let scaledImage = scaleImage(self.selectedImage, maxDimension: 640)
            self.imageView.image = scaledImage
            self.ocrButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension KWScannerViewController{
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract) -> Bool {
        let percent = CFloat(tesseract.progress)/100.0
        //let progressPercentString = NSString(format:"%.03f", (CFloat(tesseract.progress)/100.0))
        //        _ = CFloat(progressPercentString.doubleValue)
        dispatch_async(dispatch_get_main_queue()) {
            self.ocrProgress.setProgress(percent, animated: true)
        }
        return false;  // return YES, if you need to interrupt tesseract before it finishes
    }
}
