//
//  MenuService.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 20.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import Foundation

class MenuService {
    
    typealias JSON = [String: Any]
    
    private enum MealKey: String {
        case id
        case name
        case menu
    }
    
    private enum PlateKey: String {
        case id
        case name
        case outlet
        case protein
        case calories
        case category
    }
    
    private let jsonNames: [String]
    
    init() {
        
        // resourse path zeigen
        guard let resourcesPath = Bundle.main.resourcePath else {
            jsonNames = []
            return
        }
        
        // Get Meals jsons filenames
        var mealFileNames: [String] = []
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: resourcesPath)
            for file in files where file.contains("Meal") && file.contains("json") {
                mealFileNames.append(file.replacingOccurrences(of: ".json", with: ""))
            }
        } catch let error {
            print(error)
        }
        
        jsonNames = mealFileNames
    }
    
    func getPlates(for meal: Meal) -> [Plate] {
        
        var plates: [Plate] = []
        
        guard let json = getMealJSON(caffeID: meal.id),
            let menuJSON = json[MealKey.menu.rawValue] as? JSON,
            let plateJSONs = menuJSON["Food"] as? [JSON] else {
                return plates
        }
        
        plates = plateJSONs.compactMap({ json -> Plate? in
            
            guard let id = json[PlateKey.id.rawValue] as? Int,
                let name = json[PlateKey.name.rawValue] as? String,
                let outlet = json[PlateKey.outlet.rawValue] as? String,
                let protein = json[PlateKey.protein.rawValue] as? String,
                 let calories = json[PlateKey.calories.rawValue] as? String,
                let rawCategory = json[PlateKey.category.rawValue] as? String else {
                    return nil
            }
            
            let category = Plate.Category(rawValue: rawCategory) ?? .other
            
            return Plate(id: id, name: name, outlet: outlet, protein: protein,calories: calories , category: category)
        })
        
        return plates
    }
    
    func getMeals() -> [Meal] {
        
        let meals = getMealsJSONs().compactMap { json -> Meal? in
            
            guard let id = json[MealKey.id.rawValue] as? Int,
                let name = json[MealKey.name.rawValue] as? String else {
                    return nil
            }
            
            return Meal(id: id, name: name)
        }
        
        return meals
    }
    
    func getMeal(_ id: Int) -> Meal? {
        let meals = getMeals()
        
        return meals.first(where: { meal -> Bool in
            return meal.id == id
        })
    }
    
    func getPlate(_ id: Int, for meal: Meal) -> Plate? {
        let plates = getPlates(for: meal)
        
        return plates.first(where: { plate -> Bool in
            return plate.id == id
        })
    }
    
    // MARK: Private hilfe
    
    private func getMealsJSONs() -> [JSON] {
        
        var jsons: [JSON] = []
        for jsonName in jsonNames {
            guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else { continue }
            
            do {
                let data = try Data(contentsOf: url)
                let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let json = dict as? JSON {
                    jsons.append(json)
                }
                
            } catch let error {
                print(error)
            }
        }
        
        return jsons
    }
    
    private func getMealJSON(caffeID: Int) -> JSON? {
        let jsons = getMealsJSONs()
        
        for json in jsons {
            if let id = json[MealKey.id.rawValue] as? Int, id == caffeID {
                return json
            }
        }
        
        return nil
    }
}
