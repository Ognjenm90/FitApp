//
//  Bag.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import Foundation

struct Bag {
    var plates: [Plate]
    var meal: Meal
    
    var protein: String {
        var protein = 0
        for plate in plates {
            if let proteins = Int(plate.protein) {
                protein += proteins
            }
            
        }
        
        return String(protein)
    }
    var calorie: String {
        var calorie = 0
        for plate in plates {
            if let calories = Int(plate.calories) {
                calorie += calories
            }
            
        }
        
        return String(calorie)
    }
    
    var outletComponents: [OutletComponent] {
        var gramms: Int = 0
        var milliliters: Int = 0
        
        plates.forEach { plate in
            plate.outletComponents.forEach({ (name: ComponentName, value: Int) in
                
                switch name {
                case .grams:
                    gramms += value
                case .milliliters:
                    milliliters += value
                }
            })
        }
        
        return [(name: ComponentName.grams, value: gramms), (name: ComponentName.milliliters, value: milliliters)]
    }
    
    var maxOutletComponent: OutletComponent? {
        
        let sorted = outletComponents.sorted { (first, second) -> Bool in
            return first.value > second.value
        }
        
        return sorted.first
    }
}
