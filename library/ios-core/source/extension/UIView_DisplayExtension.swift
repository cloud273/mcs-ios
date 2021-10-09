/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

private class ViewManagement: NSObject, UIGestureRecognizerDelegate {
    
    static let instance = ViewManagement()
    
    var map: [UIGestureRecognizer: UIView] = [:]
    
    func add(_ gesture: UIGestureRecognizer, excluseView: UIView) {
        gesture.delegate = self
        map[gesture] = excluseView
    }
    
    func clear(_ excluseView: UIView) {
        for (gesture, view) in map {
            if view == excluseView {
                map.removeValue(forKey: gesture)
                break
            }
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = map[gestureRecognizer] {
            let point = gestureRecognizer.location(in: view)
            return !view.bounds.contains(point)
        }
        return true
    }
}

public extension UIView {
    
    func showKeyboard(_ completion: ((Bool) -> Void)? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let window = UIApplication.shared.keyWindow!
        let screen = UIViewController.presentedViewController()?.view ?? window
        let bounds = screen.bounds
        let container = UIView(frame: bounds)
        container.backgroundColor = UIColor.clear
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        screen.addFixView(container)
        
        container.addSubview(self)
        _ = addWidthConstraint(container)
        _ = addCenterXConstraint()
        let contraint = addInnerEdgeConstraint(types: [.bottom], offset: -self.bounds.height).first!
        contraint.identifier = "bottom"
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.autoHideKeyboard))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        container.addGestureRecognizer(tap)
        ViewManagement.instance.add(tap, excluseView: self)
        screen.layoutIfNeeded()
        container.layoutIfNeeded()
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            contraint.constant = 0
            container.layoutIfNeeded()
        }, completion: { (success : Bool) in
            if completion != nil {
                completion!(success)
            }
        })
    }
    
    func hideKeyboard(_ completion: ((Bool) -> Void)? = nil) {
        ViewManagement.instance.clear(self)
        let container = self.superview!
        var contraint: NSLayoutConstraint!
        for item in container.constraints {
            if item.identifier == "bottom" {
                contraint = item
                break
            }
        }
        UIView.animate(withDuration: 0.25, animations: {
            contraint.constant = self.bounds.height
            container.layoutIfNeeded()
        }, completion: { (success : Bool) in
            container.removeFromSuperview()
            if completion != nil {
                completion!(success)
            }
        })
    }
    
    @objc private func autoHideKeyboard() {
        self.hideKeyboard()
    }
    
}

public extension UIView {
    
    func show(_ tapToClose: Bool, completion: ((Bool) -> Void)? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let window = UIApplication.shared.keyWindow!        
        let screen = UIViewController.presentedViewController()?.view ?? window
        let bounds = screen.bounds
        let container = UIView(frame: bounds)
        container.backgroundColor = UIColor.init(rgb: 0, a: 0.8)
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        screen.addFixView(container)
        let scrollView = UIScrollView.init()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(scrollView)
        _ = scrollView.addCenterConstraint()
        scrollView.addFixView(self)
        _ = addWidthConstraint(scrollView)
        _ = addHeightConstraint(scrollView, offset: -10)
        
        let constraint1 = scrollView.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, multiplier: 1, constant: -20)
        constraint1.priority = .defaultHigh
        constraint1.isActive = true
        let constraint2 = scrollView.heightAnchor.constraint(lessThanOrEqualTo: container.heightAnchor, multiplier: 1, constant: -40)
        constraint2.priority = .defaultHigh
        constraint2.isActive = true
        
        if (tapToClose) {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.autoHide))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            container.addGestureRecognizer(tap)
            ViewManagement.instance.add(tap, excluseView: self)
        }
        
        container.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            container.alpha = 1
        }, completion: { (success : Bool) in
            if completion != nil {
                completion!(success)
            }
        })
    }
    
    func hide(_ completion: ((Bool) -> Void)? = nil) {
        ViewManagement.instance.clear(self)
        let view = self.superview!.superview!
        view.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 0
        }, completion: { (success : Bool) in
            view.removeFromSuperview()
            if completion != nil {
                completion!(success)
            }
        })
    }
    
    @objc private func autoHide() {
        self.hide()
    }
    
}
