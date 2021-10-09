/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import CoreGraphics
import Foundation
import UIKit

public extension UIImage {
    
    func data() -> Data? {
        
        var result : Data? = self.pngData()
        if result == nil {
            result = self.jpegData(compressionQuality: 1)
        }
        return result
        
    }
    
}

// MARK: - Scaling

public extension UIImage {
    /// Returns whether the image contains an alpha component.
    var qdContainsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo
        
        return (
            alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
    }
    
    /// Returns whether the image is opaque.
    var qdIsOpaque: Bool { return !qdContainsAlphaComponent }
}

public extension UIImage {
    
    /// Returns a new version of the image scaled to the specified size.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    func qdImageScaled(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, qdIsOpaque, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fit within
    /// a specified size.
    ///
    /// The resulting image contains an alpha component used to pad the width or height with the necessary transparent
    /// pixels to fit the specified size. In high performance critical situations, this may not be the optimal approach.
    /// To maintain an opaque image, you could compute the `scaledSize` manually, then use the `af_imageScaledToSize`
    /// method in conjunction with a `.Center` content mode to achieve the same visual result.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    func qdImageAspectScaled(toFit size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fill a
    /// specified size. Any pixels that fall outside the specified size are clipped.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    func qdImageAspectScaled(toFill size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, qdIsOpaque, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

// MARK: - Rounded Corners

public extension UIImage {
    /// Returns a new version of the image with the corners rounded to the specified radius.
    ///
    /// - parameter radius:                   The radius to use when rounding the new image.
    /// - parameter divideRadiusByImageScale: Whether to divide the radius by the image scale. Set to `true` when the
    ///                                       image has the same resolution for all screen scales such as @1x, @2x and
    ///                                       @3x (i.e. single image from web server). Set to `false` for images loaded
    ///                                       from an asset catalog with varying resolutions for each screen scale.
    ///                                       `false` by default.
    ///
    /// - returns: A new image object.
    func qdImageRounded(withCornerRadius radius: CGFloat, divideRadiusByImageScale: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let scaledRadius = divideRadiusByImageScale ? radius / scale : radius
        
        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: scaledRadius)
        clippingPath.addClip()
        
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    /// Returns a new version of the image rounded into a circle.
    ///
    /// - returns: A new image object.
    func qdImageRoundedIntoCircle() -> UIImage {
        let radius = min(size.width, size.height) / 2.0
        var squareImage = self
        
        if size.width != size.height {
            let squareDimension = min(size.width, size.height)
            let squareSize = CGSize(width: squareDimension, height: squareDimension)
            squareImage = qdImageAspectScaled(toFill: squareSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(squareImage.size, false, 0.0)
        
        let clippingPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: squareImage.size),
            cornerRadius: radius
        )
        
        clippingPath.addClip()
        
        squareImage.draw(in: CGRect(origin: CGPoint.zero, size: squareImage.size))
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}

