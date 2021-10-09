/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public class QDDocumentScanPickerController: NSObject {
    
    private class Collection: NSObject {
        
        static let instance = Collection()
        
        private var objs: [String: QDDocumentScanPickerController] = [:]
        
        func add(_ obj: QDDocumentScanPickerController) {
            objs[obj.description] = obj
        }
        
        func remove(_ obj: QDDocumentScanPickerController) {
            objs.removeValue(forKey: obj.description)
        }
        
    }
    
    private var scanner: ImageScannerController
    private var completion: ((Bool, Error?, UIImage?) -> Void)
    
    private init(_ completion: @escaping (Bool, Error?, UIImage?) -> Void) {
        self.scanner = ImageScannerController()
        self.completion = completion
        super.init()
        scanner.imageScannerDelegate = self
    }
    
    func hide() {
        scanner.dismiss(animated: true)
    }
    
    private func show(_ controller: UIViewController, view: UIView? = nil) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize.init(width: 200, height: 200)
        scanner.popoverPresentationController?.permittedArrowDirections = .down
        if let view = view {
            scanner.popoverPresentationController?.sourceView = view
            scanner.popoverPresentationController?.sourceRect = view.bounds
        } else {
            scanner.popoverPresentationController?.sourceView = controller.view
            scanner.popoverPresentationController?.sourceRect = controller.view.bounds
        }
        controller.present(scanner, animated: true, completion: nil)
    }
    
    public class func show(_ controller: UIViewController, view: UIView? = nil, completion: @escaping (Bool, Error?, UIImage?) -> Void) {
        let scanner = QDDocumentScanPickerController.init(completion)
        scanner.show(controller, view: view)
        Collection.instance.add(scanner)
    }
    
}

extension QDDocumentScanPickerController: ImageScannerControllerDelegate {
    
    public func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        completion(true, nil, results.scannedImage)
        Collection.instance.remove(self)
        scanner.dismiss(animated: true, completion: nil)
    }
    
    public func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        completion(false, nil, nil)
        Collection.instance.remove(self)
        scanner.dismiss(animated: true, completion: nil)
    }
    
    public func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        completion(false, error, nil)
        Collection.instance.remove(self)
        scanner.dismiss(animated: true, completion: nil)
    }
    
}
