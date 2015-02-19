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
 var ingredients = NSArray()
    
   required init(ocrInput: NSString ) {
        self.ocrResult = ocrInput
        removeNewLines()
        splitResult()
        sanitize()
    }

    func removeNewLines(){
        self.ocrResult = self.ocrResult.stringByReplacingOccurrencesOfString("\n", withString: "", options: nil, range: NSMakeRange(0, self.ocrResult.length))
    }
    
    func splitResult() {
      ingredients =  self.ocrResult.componentsSeparatedByString(",");
    }
    
    func sanitize() {
        let notEmptyPredicate = NSPredicate(format:"length > 0")
        let notIngredientsPredicate = NSPredicate(format:"!(SELF CONTAINS[cd] %@)", "ingredients")
        
        ingredients =  (ingredients as NSArray).filteredArrayUsingPredicate(notEmptyPredicate!)
        ingredients =  (ingredients as NSArray).filteredArrayUsingPredicate(notIngredientsPredicate!)

    }
}