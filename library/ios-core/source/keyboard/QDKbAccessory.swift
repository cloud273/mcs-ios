/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public protocol QDKbAccessoryProtocol : NSObjectProtocol {
    
    func accessoryRightTap(_ accessory : QDKbAccessory)
    
    func accessoryLeftTap(_ accessory : QDKbAccessory)
    
}

open class QDKbAccessory: UIView {

    public let height : CGFloat = 44.0
    
    public weak var delegate : QDKbAccessoryProtocol?
    
    weak public var field : UIView?
    
    private weak var rightBtn : UIButton!
    
    private weak var leftBtn : UIButton!
    
    private weak var nameLb : UILabel!
    
    @objc private func leftButtonPressed(_ sender: Any) {
        delegate?.accessoryLeftTap(self)
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        delegate?.accessoryRightTap(self)
    }
    
    public init?(_ field : UIView?, delegate : QDKbAccessoryProtocol?) {
        if let field = field, !field.isKind(of: UITextView.self) && !field.isKind(of: UITextField.self) {
            return nil
        }
        var frame = UIScreen.main.bounds
        frame.size.height = height
        super.init(frame: frame)
        self.delegate = delegate
        self.field = field
    
        // Create Views
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.titleLabel?.lineBreakMode = .byTruncatingMiddle
        leftBtn.isHidden = false
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        leftBtn.setImage(UIImage.init(named: "prev") ?? UIImage.init(named: "prev", in: Bundle.init(for: QDKbAccessory.self), compatibleWith: nil), for: .normal)
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.titleLabel?.lineBreakMode = .byTruncatingMiddle
        rightBtn.isHidden = false
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.setImage(UIImage.init(named: "next") ?? UIImage.init(named: "next", in: Bundle.init(for: QDKbAccessory.self), compatibleWith: nil), for: .normal)
        
        let nameLb = UILabel.init()
        nameLb.textAlignment = .center
        nameLb.textColor = .gray
        if let field = field as? UITextField {
            nameLb.text = field.placeholder
            field.inputAccessoryView = self
        } else if let field = field as? UITextView {
            field.inputAccessoryView = self
        }
        nameLb.translatesAutoresizingMaskIntoConstraints = false
        nameLb.font = .systemFont(ofSize: 14)
        
        let line = UIView.init()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        line.alpha = 0.6
        
        // Assemble View Hierarchy
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(nameLb)
        self.addSubview(line)
        
        // Configure Constraints
        nameLb.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLb.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLb.leadingAnchor.constraint(greaterThanOrEqualTo: leftBtn.trailingAnchor, constant: 10).isActive = true
        rightBtn.trailingAnchor.constraint(greaterThanOrEqualTo: nameLb.leadingAnchor, constant: 10).isActive = true
        
        leftBtn.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        leftBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        leftBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        rightBtn.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        rightBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        rightBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        line.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Remaining Configuration
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .init(r: 228, g: 228, b: 228)

        leftBtn.addTarget(self, action: #selector(leftButtonPressed(_:)), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
        
        self.leftBtn = leftBtn
        self.nameLb = nameLb
        self.rightBtn = rightBtn
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupNavigateAccessory(prev: String?, next: String?) {
        if let prev = prev {
            leftButton.setTitle(prev, for: .normal)
            leftButton.isHidden = false
        } else {
            leftButton.isHidden = true
        }
        if let next = next {
            rightButton.setTitle(next, for: .normal)
            rightButton.isHidden = false
        } else {
            rightButton.isHidden = true
        }
    }
    
    public var leftButton: UIButton {
        get {
            return leftBtn
        }
    }
    
    public var nameLabel: UILabel {
        get {
            return nameLb
        }
    }
    
    public var rightButton: UIButton {
        get {
            return rightBtn
        }
    }
    
}
