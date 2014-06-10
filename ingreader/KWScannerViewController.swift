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
        self.recognizeImage(image)
        self.dismissViewControllerAnimated(true, completion:nil)


    }
    
    func recognizeImage (image: UIImage) -> Void {
    
        // language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory; eng+ita will search for a eng.traineddata and ita.traineddata.
        
        //Like in the Template Framework Project:
        // Assumed that .traineddata files are in your "tessdata" folder and the folder is in the root of the project.
        // Assumed, that you added a folder references "tessdata" into your xCode project tree, with the ‘Create folder references for any added folders’ options set up in the «Add files to project» dialog.
        // Assumed that any .traineddata files is in the tessdata folder, like in the Template Framework Project
        
   
        
        let tesseract:Tesseract  = Tesseract(language: "eng")
        tesseract.delegate = self;

      //  tesseract.setVariableValueForKey("0123456789", "tessedit_char_whitelist") //limit search
        tesseract.image =  image //image to check
        let result = tesseract.recognize
        let pref = getenv("TESSDATA_PREFIX")
        println("OUTPUT ---\(pref)---")
        println("\(tesseract.recognizedText)")
    }
    
    
    func shouldCancelImageRecognitionForTesseract(tesseract: Tesseract) -> Bool {
        println("progress_____________: \(tesseract.progress)");
        return false;  // return YES, if you need to interrupt tesseract before it finishes
    }
    
}