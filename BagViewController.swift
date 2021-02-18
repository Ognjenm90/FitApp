//
//  BagViewController.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class BagViewController: UIViewController {
    
    let clearButtonHeight: CGFloat = 105
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var bag: Bag?
    
    var darkView: UIView? {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(close))
            darkView?.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBag(notification:)), name: BagService.notificationBagChanged, object: nil)
        updateBag()
        
        initUI()
    }
    
    func initUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: clearButtonHeight, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: clearButtonHeight, right: 0)
    }
    
    @objc private func updateBag(notification: Notification? = nil) {
        
       bag = AppController.shared.selectedBag
        tableView.reloadData()
        emptyView.isHidden = (bag?.plates.count ?? 0) > 0
    }
    
    // MARK: Actions
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        if let caffe = AppController.shared.selectedMeal {
            AppController.shared.bag.removeAll(for: caffe)
        }
        
        close()
    }
}

extension BagViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bag?.plates.count ?? -1) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bag = bag, indexPath.row == bag.plates.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BagCell.self)) as? BagCell {
            cell.fillCell(bag: bag)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BagPlateCell.self)) as? BagPlateCell,
            let plate = bag?.plates[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.fillCell(plate: plate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // wenn es lätztes cell ist, dann Aktion löschen
        
        return bag?.plates.count != indexPath.row
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete,
            let bag = bag, indexPath.row != bag.plates.count,
            let meal = AppController.shared.selectedMeal else {
                return
        }
        
        let plate = bag.plates[indexPath.row]
        
        
        AppController.shared.bag.remove(plate, for: meal)
        
    }
}
