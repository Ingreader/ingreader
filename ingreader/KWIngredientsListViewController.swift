//
//  KWIngredientsListViewController.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 18.02.2015.
//  Copyright (c) 2015 silk. All rights reserved.
//

import UIKit

class KWIngredientsListViewController: UITableViewController {
    var ocrResult = NSString()
    var ingredients = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var processor:KWOcrResultProcessor = KWOcrResultProcessor(ocrInput: ocrResult)
        ingredients = processor.ingredients
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension KWIngredientsListViewController: UITableViewDataSource{

    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellId: NSString = "IngredientCell"
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell
            if var ingredient = self.ingredients[indexPath.row] as? NSString {
                cell.textLabel?.text = ingredient
            }
            
            return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
}