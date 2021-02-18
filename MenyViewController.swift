//
//  ViewController.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    struct Section {
        var name: String
        var plates: [Plate]
    }
    
    var bagViewCanUpdate = true
    
    var sections: [Section] = []
    
  
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
   
    
    
    @IBOutlet weak var bagContainerView: BagContainerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBagView(notification:)), name: BagService.notificationBagChanged, object: nil)
        
        updateBagView()
    }
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: bagContainerView.bounds.height, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: bagContainerView.bounds.height, right: 0)
        
        addBagView()
        
       
    }
    
    private func constructSections() -> [Section]? {
        
        guard let meal = AppController.shared.selectedMeal else {
            return nil
        }
        
        var sections: [Section] = []
        let plates = AppController.shared.menu.getPlates(for: meal)
        
        // auf kategorien teilen
        
        var currentSection: Plate.Category?
        var currentSectionPlates: [Plate] = []
        for plate in plates {
            
            if let category = currentSection {
                
                // wenn neue unterteilung
                if category != plate.category {
                    sections.append(Section(name: category.rawValue, plates: currentSectionPlates))
                    
                    //loöschen kategorien
                    currentSection = plate.category
                    currentSectionPlates = []
                }
            } else {
                currentSection = plate.category
            }
            
            guard let sectionName = currentSection else { continue }
            
            if plate.category == sectionName {
                currentSectionPlates.append(plate)
            }
        }
        
        if let currentSection = currentSection {
            sections.append(Section(name: currentSection.rawValue, plates: currentSectionPlates))
        }
        
        return sections
    }
    
    // MARK: BagView
    
    private func addBagView() {
        self.bagContainerView.alpha = 0
        
        // Add tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(bagViewTapped))
        bagContainerView.addGestureRecognizer(tap)
    }
    
    func showBagView() {
        
        UIView.animate(withDuration: 0.3) {
            self.bagContainerView.alpha = 1
        }
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: bagContainerView.bounds.height, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: bagContainerView.bounds.height, right: 0)
    }
    
    func hideBagView() {
        
        UIView.animate(withDuration: 0.3) {
            self.bagContainerView.alpha = 0
        }
        
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func updateBagView(notification: Notification? = nil) {
        guard bagViewCanUpdate else { return }
        
        guard let bag = AppController.shared.selectedBag, bag.plates.count > 0 else {
            hideBagView()
            return
        }
        
        showBagView()
        bagContainerView.update(bag: bag)
    }
    
    @objc private func bagViewTapped() {
        
        guard let destionation = storyboard?.instantiateViewController(withIdentifier: "NavigationBagViewController") else {
            return
        }
        
        let segue = BagSegue(identifier: BagSegue.identifier, source: self, destination: destionation)
        self.prepare(for: segue, sender: self)
        segue.perform()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return constructSections()!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return constructSections()![section].plates.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let tableHeader = tableView.dequeueReusableCell(withIdentifier: String(describing: Header.self)) as? Header else {
            return UIView()
        }
        
        tableHeader.nameLabel.text = constructSections()![section].name
        
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuPlateCell.self)) as? MenuPlateCell else {
            return UITableViewCell()
        }
        
        cell.fillCell(plate: constructSections()![indexPath.section].plates[indexPath.row])
        
        return cell
    }
}

