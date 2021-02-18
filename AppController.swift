//
//  AppController.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import Foundation


class AppController {
    
    static let shared = AppController()
    
    let menu = MenuService()
    let bag = BagService()
    
    var selectedMeal: Meal?
    var selectedBag: Bag? {
        guard let meal = selectedMeal, let rawBag = bag.get(for: meal) else {
            return nil
        }
        
        let plates = rawBag.platesIDs.compactMap { id -> Plate? in
            return menu.getPlate(id, for: meal)
        }
        
        return Bag(plates: plates, meal: meal)
    }
    
    init() {
        selectedMeal = menu.getMeals().first
    }
}

