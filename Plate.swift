//
//  Plate.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

enum ComponentName: String {
    case grams = "Gramm"
    case milliliters = "Mililiter"
}

typealias OutletComponent = (name: ComponentName, value: Int)

struct Plate {
    enum Category: String {
        case meat = "mit Fleisch"
        case candy = "Suessigkeiten"
        case vegetables = "Gemuse"
        case fruit = "Obst";
        case drink = "Trinken"
        case other 
    }
    
    var id: Int
    var name: String
    var outlet: String
    var protein: String
    var calories:String
    var category: Category
    
    var categoryImage: UIImage? {
        
        switch category {
        case .vegetables:
            return UIImage(named: "CategoryVeget")
        case .fruit:
            return UIImage(named: "CategoryFruit")
        case .drink:
            return UIImage(named: "CategoryDrink")
        case .candy:
            return UIImage(named: "CategoryCandy")
            
        case .meat:
            return UIImage(named: "CategoryMeat")
        case .other:
            return UIImage(named: "CategoryOther")
        }
    }
    
    var outletComponents: [OutletComponent] {
        var components: [OutletComponent] = []
        
        let rawComponents = outlet.components(separatedBy: "/")
        for rawComponent in rawComponents {
            guard let value = Int(rawComponent.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)) else {
                continue
            }
            
            var component = ComponentName.grams
            if rawComponents.contains("ml") {
                component = .milliliters
            }
            
            components.append((component, value))
        }
        
        return components
    }
}
