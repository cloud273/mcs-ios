/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension UIView {
    
    enum EdgeContraint : Int {
        case leading
        case top
        case trailing
        case bottom
    }
    
    func addXViews(_ views: [UIView], xOffset: CGFloat = 0, yOffset: CGFloat = 0, offset: CGFloat = 0, fixed: Bool = true) {
        var lastView = self
        for view in views {
            self.addSubview(view)
            _ = view.addInnerEdgeConstraint(self, types: [.top, .bottom], offset: yOffset)
            if lastView == self {
                _ = view.addInnerEdgeConstraint(lastView, types: [.leading], offset: xOffset)
            } else {
                view.leadingAnchor.constraint(equalTo: lastView.trailingAnchor, constant: offset).isActive = true
            }
            lastView = view
        }
        if lastView != self && fixed {
            _ = lastView.addInnerEdgeConstraint(self, types: [.trailing], offset: xOffset)
        }
    }
    
    func addYViews(_ views: [UIView], xOffset: CGFloat = 0, yOffset: CGFloat = 0, offset: CGFloat = 0, fixed: Bool = true) {
        var lastView = self
        for view in views {
            self.addSubview(view)
            _ = view.addInnerEdgeConstraint(self, types: [.leading, .trailing], offset: xOffset)
            if lastView == self {
                _ = view.addInnerEdgeConstraint(lastView, types: [.top], offset: yOffset)
            } else {
                view.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: offset).isActive = true
            }
            lastView = view
        }
        if lastView != self && fixed {
            _ = lastView.addInnerEdgeConstraint(self, types: [.bottom], offset: yOffset)
        }
    }
    
    func addFixView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        _ = view.addInnerEdgeConstraint(self, types: [.leading, .top, .trailing, .bottom], offset: 0)
    }
    
    func addInnerEdgeConstraint(_ view: UIView? = nil, types: [EdgeContraint], offset: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let view = view ?? self.superview!
        var result = [NSLayoutConstraint]()
        var constraint :NSLayoutConstraint!
        if types.contains(.leading) {
            constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        if types.contains(.top) {
            constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        if types.contains(.trailing) {
            constraint = view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        if types.contains(.bottom) {
            constraint = view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        return result
    }
    
    func addInnerEdgeConstraint(_ view: UILayoutGuide, types: [EdgeContraint], offset: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = [NSLayoutConstraint]()
        var constraint :NSLayoutConstraint!
        if types.contains(.leading) {
            constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        if types.contains(.top) {
            constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        if types.contains(.trailing) {
            constraint = view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        if types.contains(.bottom) {
            constraint = view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: offset)
            constraint.priority = priority
            result.append(constraint)
            constraint.isActive = true
        }
        return result
    }
    
    func addBelowContraint(_ view: UIView, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addBelowContraint(_ view: UILayoutGuide, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addAboveContraint(_ view: UIView, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addAboveContraint(_ view: UILayoutGuide, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addRightContraint(_ view: UIView, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addRightContraint(_ view: UILayoutGuide, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addLeftContraint(_ view: UIView, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = view.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addLeftContraint(_ view: UILayoutGuide, offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = view.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addAspectConstraint(_ value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: value, constant: 0)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addHeightConstraint(_ value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalToConstant: value)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addHeightConstraint(_ view: UIView, offset: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addWidthConstraint(_ value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalToConstant: value)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addWidthConstraint(_ view: UIView, offset: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addCenterXConstraint(_ view: UIView? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let view = view ?? self.superview!
        var constraint: NSLayoutConstraint!
        constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addCenterYConstraint(_ view: UIView? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let view = view ?? self.superview!
        var constraint: NSLayoutConstraint!
        constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addCenterConstraint(_ view: UIView? = nil, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return [addCenterXConstraint(view, priority: priority), addCenterYConstraint(view, priority: priority)]
    }
    
}
