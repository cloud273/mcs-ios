/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

// MARK: -------------- Abstract class - Do not use --------------

public protocol QDKbTextProtocol: Any  {
    
    func getText() -> String
    
    func equal(_ other: Any?) -> Bool
}

public protocol QDKBObjectProtocol: Any {
    
    func getAttributeText() -> NSAttributedString
    
    func equal(_ other: Any?) -> Bool
    
}

@objc public protocol QDKeyboardProtocol: Any  {
    
    func keyboardSelected(_ keyboard : Any, value : Any?)
    
}

open class QDKeyboard: UIView {
    
    public var id : String?
    
    weak public var field : UITextInputTraits?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private static func getSize() -> CGSize {
        let frame = UIScreen.main.bounds
        let width = frame.width
        var height : CGFloat = 0
        let deviceHeight = max(frame.height, frame.width)
        if UIDevice.current.orientation.isPortrait {
            if deviceHeight >= 1024 {
                height = 264
            } else {
                height = 224
            }
        } else {
            if deviceHeight >= 1024 {
                height = 352
            } else {
                height = 170
            }
        }
        return CGSize.init(width: width, height: height)
    }
    
    public init(_ field : UITextField?) {
        
        super.init(frame: CGRect.init(origin: CGPoint.zero, size: QDKeyboard.getSize()))
        
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.clipsToBounds = true
        
        field?.inputView = self
        
         self.field = field
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceChangeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func deviceChangeOrientation(noti : Notification) {
        reloadGUI()
    }
    
    public func reloadGUI() {
        
    }
    
    public func select(_ data : Any) {
        
    }
    
}
