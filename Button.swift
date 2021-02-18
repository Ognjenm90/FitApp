//
//  Button.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    var backgrColor: UIColor?
    var imageColor = UIColor.green
    
    private let backgrInset: CGFloat = 5
    private let backgrTag = 1010
    
    
    
    private func addSubstrateView() {
        subviews.forEach { subview in
            if subview.tag == backgrTag {
                subview.removeFromSuperview()
            }
        }
        
      
        
        let frame = CGRect(x: backgrInset / 2,
                           y: backgrInset / 2,
                           width: self.frame.width - backgrInset,
                           height: self.frame.height - backgrInset)
        let backgr = UIView(frame: frame)
       backgr.backgroundColor = UIColor.green
       backgr.layer.cornerRadius = frame.height / 2
       backgr.tag = backgrTag
       backgr.isUserInteractionEnabled = false
        self.addSubview(backgr)
        self.sendSubviewToBack(backgr)
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
        addSubstrateView()
    }
}

