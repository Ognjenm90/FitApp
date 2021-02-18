//
//  BagCell.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class BagCell: UITableViewCell {
    
    @IBOutlet weak var platesCountLabel: UILabel!
    @IBOutlet weak var outletLabel: UILabel!
   
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillCell(bag: Bag) {
        platesCountLabel.text = String(bag.plates.count)
        proteinLabel.text = "Eiweiss:\(bag.protein)g"
        caloriesLabel.text = "Kcal:\(bag.calorie)"
        if let outlet = bag.maxOutletComponent {
            outletLabel.text = "\(outlet.value) \(outlet.name.rawValue)"
        }
    }
}

