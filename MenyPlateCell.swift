//
//  MenyPlateCell.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class MenuPlateCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
  
    @IBOutlet weak var outletLabel: UILabel!
   
    @IBOutlet weak var priceLabel: UILabel!
 
    @IBOutlet weak var addButton: Button!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
  
    
    private var plate: Plate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.imageColor = UIColor.black
        addButton.backgrColor = UIColor.green
    }
    
    func fillCell(plate: Plate) {
        self.plate = plate
        
        nameLabel.text = plate.name
        outletLabel.text = plate.outlet
        priceLabel.text = "Eiweiss:\(plate.protein)g"
        categoryImageView.image = plate.categoryImage
           caloriesLabel.text = "Kcal:\(plate.calories)"
    }
    

    @IBAction func addButtonTapped(_ sender: Any) {
        
        if let plate = plate, let meal = AppController.shared.selectedMeal {
            AppController.shared.bag.add(plate, for: meal)
            
        }
    }

}
