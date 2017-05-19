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
    var ingredients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let processor:KWOcrResultProcessor = KWOcrResultProcessor(ocrInput: ocrResult)
        ingredients = processor.ingredients
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension KWIngredientsListViewController {

    
    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellId: NSString = "IngredientCell"
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId as String)! as UITableViewCell
            if let ingredient = self.ingredients[indexPath.row] as? String {
                cell.textLabel?.text = ingredient as String
            }
            
            return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
}
