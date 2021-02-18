//
//  BagPlateCell.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class BagPlateCell: UITableViewCell {
    
   
    @IBOutlet weak var outletLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var proteinLabel: UILabel!
    
   
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillCell(plate: Plate) {
        nameLabel.text = plate.name
        outletLabel.text = plate.outlet
        proteinLabel.text = "Eiweiss:\(plate.protein)"
        categoryImageView.image = plate.categoryImage
        caloriesLabel.text = "Kcal:\(plate.calories)"
    }
}
