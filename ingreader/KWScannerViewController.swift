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
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageView.contentMode =  .scaleAspectFit
        self.ocrProgress.progress = 0.0
        self.ocrProgress.isHidden = true
    }
    
    @IBAction func takePicture(_: AnyObject) {

        let imagePickerActionSheet = UIAlertController(title: "Take photo or select exsiting?",
            message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                style: .default) { (alert) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self.present(imagePicker,
                        animated: true,
                        completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose Existing",
            style: .default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker,
                    animated: true,
                    completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel",
            style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        present(imagePickerActionSheet, animated: true,
            completion: nil)
    }

    @IBAction func owsiar(_: AnyObject) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.ocrProgress.isHidden = false
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.recognizeImage(self.selectedImage)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.ocrProgress.isHidden = true
            }
        }
    }
    
    @IBAction func sharpening(_: AnyObject) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let result = KWFilters.sharpenImage(self.imageView.image!)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.selectedImage = result
                self.imageView.image = result
            }
        }
    }
    
    @IBAction func monochrome(_: AnyObject) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if (self.imageView.image != nil) {
                let result = KWFilters.binarizeImage(self.imageView.image!)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.selectedImage = result
                    self.imageView.image = result
                }
            }
        }
    }
    
    @IBAction func binarize(_: AnyObject) {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let result = KWFilters.customBinarizeImage(self.imageView.image!)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.selectedImage = result
                self.imageView.image = result
            }
        }
    }

    
    
    func recognizeImage (_ image: UIImage) -> Void {

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        let tesseract = G8Tesseract(language:"eng")
        tesseract?.delegate = self
        tesseract?.engineMode = .tesseractCubeCombined
        tesseract?.pageSegmentationMode = .auto
        tesseract?.maximumRecognitionTime = 60.0
        tesseract?.image = image.blackwhite()
        tesseract?.charWhitelist = "abcdefghijklmnopqrstuwxyz,()/01234567890" //limit search
        tesseract?.image =  image //image to check
        tesseract?.recognize()


        
        ocrResult =  tesseract!.recognizedText as NSString
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
              self.performSegue(withIdentifier: "Present Ingredients List", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Present Ingredients List" {
            let viewController:KWIngredientsListViewController = segue.destination as! KWIngredientsListViewController
            viewController.ocrResult = self.ocrResult;
        }
    }
        
    //Image proecessing
    func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        
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
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }

}

extension KWScannerViewController {
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
            self.selectedImage = image
            let scaledImage = scaleImage(self.selectedImage, maxDimension: 640)
            self.imageView.image = scaledImage
            self.ocrButton.isEnabled = true
            dismiss(animated: true, completion: nil)
    }
    
}

extension KWScannerViewController{
    func shouldCancelImageRecognition(for tesseract: G8Tesseract) -> Bool {
        let percent = CFloat(tesseract.progress)/100.0
        //let progressPercentString = NSString(format:"%.03f", (CFloat(tesseract.progress)/100.0))
        //        _ = CFloat(progressPercentString.doubleValue)
        DispatchQueue.main.async {
            self.ocrProgress.setProgress(percent, animated: true)
        }
        return false;  // return YES, if you need to interrupt tesseract before it finishes
    }
}
