

//
//  KWOcrResultProcessor.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 18.02.2015.
//  Copyright (c) 2015 silk. All rights reserved.
//

import Foundation

class KWOcrResultProcessor {    
 var ocrResult = NSString()
 var ingredients = [String]()
    
    
   required init(ocrInput: NSString ) {
        self.ocrResult = ocrInput
        removeNewLines()
        splitResult()
        sanitize()
    }

    func removeNewLines(){
        self.ocrResult = self.ocrResult.replacingOccurrences(of: "\n", with: "", options: [], range: NSMakeRange(0, self.ocrResult.length)) as NSString
    }
    
    func splitResult() {
//        ingredients =  self.ocrResult.componentsSeparatedByString(",");
      ingredients =  self.ocrResult.components(separatedBy: ",");
    }
    
    func sanitize() {
        let notEmptyPredicate = NSPredicate(format:"length > 0")
        let notIngredientsPredicate = NSPredicate(format:"!(SELF CONTAINS[cd] %@)", "ingredients")
        
        ingredients =  ((ingredients as NSArray).filtered(using: notEmptyPredicate) as NSArray) as! Array<String>
        ingredients =  ((ingredients as NSArray).filtered(using: notIngredientsPredicate) as NSArray) as! Array<String>

    }
}
