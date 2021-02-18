//
//  BagService.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import Foundation

class BagService {
    
    static let notificationBagChanged = Notification.Name("NotificationBagChanged")
    
    typealias Bag = (mealID: Int, platesIDs: [Int])
    typealias BagValue = (mealID: Int, plateID: Int)
    
    private let bagKey = "BagKey"
    private let separator = "|"
    
    func get(for meal: Meal) -> Bag? {
        guard let bagValues = UserDefaults.standard.value(forKey: bagKey) as? [String], !bagValues.isEmpty else {
            return nil
        }
        
        let platesIDs: [Int] = bagValues.compactMap { string -> Int? in
            
            guard let bagValue = generateBagValue(from: string), bagValue.mealID == meal.id else {
                return nil
            }
            
            return bagValue.plateID
        }
        
        return (meal.id, platesIDs)
    }
    
    func add(_ plate: Plate, for meal: Meal) {
        let bagValue = generateString(from: (meal.id, plate.id))
        
        if var bag = UserDefaults.standard.value(forKey: bagKey) as? [String] {
            bag.append(bagValue)
            UserDefaults.standard.setValue(bag, forKey: bagKey)
        } else {
            UserDefaults.standard.setValue([bagValue], forKey: bagKey)
        }
        
        postNotification(bag: get(for: meal))
    }
    
    func remove(_ plate: Plate, for meal: Meal) {
        let bagValue = generateString(from: (meal.id, plate.id))
        
        guard var bag = UserDefaults.standard.value(forKey: bagKey) as? [String], let index = bag.firstIndex(of: bagValue) else {
            return
        }
        
        bag.remove(at: index)
        UserDefaults.standard.setValue(bag, forKey: bagKey)
        
        postNotification(bag: get(for: meal))
    }
    
    func removeAll(for meal: Meal) {
        guard var strings = UserDefaults.standard.value(forKey: bagKey) as? [String] else {
            return
        }
        
        strings.removeAll { string -> Bool in
            if let value = generateBagValue(from: string), value.mealID == meal.id {
                return true
            }
            
            return false
        }
        
        UserDefaults.standard.setValue(strings, forKey: bagKey)
        
        postNotification(bag: get(for: meal))
    }
    
    // MARK: Notificationen
    
    private func postNotification(bag: Bag? = nil) {
        NotificationCenter.default.post(name: BagService.notificationBagChanged, object: bag)
    }
    
    // MARK: Private hilfe für String
    
    private func generateString(from bagValue: BagValue) -> String {
        return "\(bagValue.mealID)\(separator)\(bagValue.plateID)"
    }
    
    private func generateBagValue(from string: String) -> BagValue? {
        let components = string.components(separatedBy: separator)
        guard components.count > 1, let mealID = Int(components[0]), let plateID = Int(components[1]) else {
            return nil
        }
        
        return (mealID, plateID)
    }
}
