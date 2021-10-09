/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension UIView {
    
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
}

public extension UIView {
    
    func rotate(_ key: String) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: key)
    }
    
    func stopAnimation(_ key: String) {
        self.layer.removeAnimation(forKey: key)
    }
    
    func stopAllAnimation() {
        self.layer.removeAllAnimations()
    }
    
}
