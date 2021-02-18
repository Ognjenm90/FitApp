//
//  BagSeque.swift
//  FitApp
//
//  Created by Ognjen Milovanovic on 11.05.19.
//  Copyright © 2019 Ognjen Milivanovic. All rights reserved.
//

import UIKit

class BagSegue: UIStoryboardSegue {
    
    static let identifier = "ShowBagSegue"
    
    private var selfRetainer: BagSegue? = nil
    
    override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        source.present(destination, animated: true, completion: nil)
    }
}

extension BagSegue: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BagPresenter()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
        return BagDismisser()
    }
}

class BagPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        guard let _ = transitionContext.viewController(forKey: .from) as? UINavigationController,
            
            let toController = transitionContext.viewController(forKey: .to)  as? UINavigationController,
            let bagController = toController.topViewController as? BagViewController else {
                return
        }
        
        //  dark view
        
        let darkView = UIView(frame: container.bounds)
        darkView.backgroundColor = .clear
        
        container.addSubview(darkView)
        bagController.darkView = darkView
        
        //  controller view
        
        container.addSubview(toView)
        
        let percent: CGFloat = 0.8
        let offset: CGFloat = container.bounds.height * (1 - percent)
        toView.frame.size = CGSize(width: container.bounds.width, height: container.bounds.height - offset + 16)
        toView.frame.origin = CGPoint(x: 0, y: container.frame.height)
        
        toView.clipsToBounds = true
        toView.layer.cornerRadius = 20
        
        
        
        // Start animation
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            
            darkView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            toView.frame.origin.y = offset
            
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}

private class BagDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        
        guard let fromController = transitionContext.viewController(forKey: .from) as? UINavigationController,
            let bagController = fromController.topViewController as? BagViewController,
            let toController = transitionContext.viewController(forKey: .to) as? UINavigationController,
            let menuController = toController.topViewController as? MenuViewController else {
                return
        }
        
        //        let bagViewHeight: CGFloat = 89
        
        //        menuController.bagViewCanUpdate = true
        menuController.updateBagView()
        
        UIView.animate(withDuration: 0.2, animations: {
            fromView.frame.origin.y = container.bounds.height //- bagViewHeight
            bagController.darkView?.alpha = 0
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}
