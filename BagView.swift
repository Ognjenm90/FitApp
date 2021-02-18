//
//  BagView.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 12.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class BagContainerView: UIView{
  @IBOutlet weak var bagView: BagView!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        // Add shadow
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Add round corners
        bagView.layer.masksToBounds = true
        bagView.layer.cornerRadius = 20
       bagView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func update(bag: Bag) {
        bagView.update(bag: bag)
    }
    
    
}


class BagView: UIView{
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var outletLabel: UILabel!
    @IBOutlet weak var platesCountLabel: UILabel!
    @IBOutlet weak var bagImageView: UIImageView!
    @IBOutlet weak var bagImageViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bagImageViewContainer.backgroundColor = UIColor.yellow
        bagImageViewContainer.layer.cornerRadius = bagImageViewContainer.frame.height / 2
    }
    
    func update(bag: Bag) {
        platesCountLabel.text = String(bag.plates.count)
        proteinLabel.text = "Eiweiss:\(bag.protein)g"
        caloriesLabel.text = "Kcal:\(bag.calorie)g"
        if let outlet = bag.maxOutletComponent {
            outletLabel.text = "\(outlet.value) \(outlet.name.rawValue)"
        }
    }
    }
    

