/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

open class QDViewController: UIViewController {
    
    private weak var refreshControl: UIRefreshControl?
    
    public func setRefreshToScrollView(_ scrollview : UIScrollView) {
        refreshControl?.removeFromSuperview()
        let refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        scrollview.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    public func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc open func refresh() {
        endRefresh()
    }
    
    public func endRefresh() {
        refreshControl?.endRefreshing()
    }
    
    private var topConstraint: NSLayoutConstraint?
    
    open func show(_ completion: (() -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow!
        let rootVc = window.rootViewController!
        view.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(view)
        willMove(toParent: rootVc)
        rootVc.addChild(self)
        didMove(toParent: rootVc)
        _ = view.addInnerEdgeConstraint(types: [.leading, .trailing], offset: 0)
        _ = view.addHeightConstraint(window)
        topConstraint = view.addInnerEdgeConstraint(types: [.top], offset: window.bounds.size.height).first!
        window.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.topConstraint?.constant = 0
            self.view.superview?.layoutIfNeeded()
        }) { (_) in
            completion?()
        }
    }
    
    open func hide(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.topConstraint?.constant = self.view.bounds.size.height
            self.view.superview?.layoutIfNeeded()
        }) { (_) in
            self.view.removeFromSuperview()
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.didMove(toParent: nil)
            completion?()
        }
    }
    
    
}

