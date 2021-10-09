/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import UIKit
import MobileCoreServices

public class QDImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var completion: ((Bool, String?, Any?) -> Void)!
    
    func setup(_ mediaTypes:[String], sourceType: UIImagePickerController.SourceType, edit: Bool, completion: @escaping (Bool, String?, Any?) -> Void) {
        self.delegate = self
        self.allowsEditing = edit
        self.mediaTypes = mediaTypes
        self.sourceType = sourceType
        self.completion = completion
    }
    
    class func create(_ sourceType: UIImagePickerController.SourceType, edit: Bool, completion: @escaping (Bool, String?, Any?) -> Void) -> QDImagePickerController? {
        var result: QDImagePickerController? = nil
        let typeImage = kUTTypeImage as String
        let mediaTypes = QDImagePickerController.availableMediaTypes(for: sourceType)
        if QDImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes?.contains(typeImage) ?? false {
            result = QDImagePickerController.init()
            result?.setup([typeImage], sourceType: sourceType, edit: edit, completion: completion)
        }
        return result
    }
    
    func hide() {
        dismiss(animated: true)
    }
    
    func show(_ controller: UIViewController, view: UIView? = nil) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize.init(width: 200, height: 200)
        self.popoverPresentationController?.permittedArrowDirections = .down
        if let view = view {
            self.popoverPresentationController?.sourceView = view
            self.popoverPresentationController?.sourceRect = view.bounds
        } else {
            self.popoverPresentationController?.sourceView = controller.view
            self.popoverPresentationController?.sourceRect = controller.view.bounds
        }
        controller.present(self, animated: true, completion: nil)
    }
    
    public class func show(_ controller: UIViewController, view: UIView? = nil, sourceType: UIImagePickerController.SourceType, edit: Bool, completion: @escaping (Bool, String?, Any?) -> Void) {
        if let picker = self.create(sourceType, edit: edit, completion: completion) {
            picker.show(controller, view: view)
        } else {
            UIAlertController.show(controller, title: "Unsupported", message: "Sorry, your device doesn't support this feature")
        }
    }
    
    public class func show(_ controller: UIViewController, from view: UIView? = nil, edit: Bool = true, title: String = "Please select an option", camera: String = "Camera", albumn: String = "Albumn", remove: String? = nil, cancel: String = "Cancel", completion: @escaping (Bool, String?, Any?) -> Void) {
        let sheet = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction.init(title: camera, style: .default, handler: { (_) in
            self.show(controller, view: view, sourceType: .camera, edit: edit, completion: completion)
        }))
        sheet.addAction(UIAlertAction.init(title: albumn, style: .default, handler: { (_) in
            self.show(controller,  view: view, sourceType: .savedPhotosAlbum, edit: edit, completion: completion)
        }))
        if let remove = remove {
            sheet.addAction(UIAlertAction.init(title: remove, style: .destructive, handler: { (_) in
                completion(true, nil, nil)
            }))
        }
        sheet.addAction(UIAlertAction.init(title: cancel, style: .cancel, handler: { (_) in
            
        }))
        sheet.show(controller, from: view)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let type = info[UIImagePickerController.InfoKey.mediaType] as? String
        var object = info[UIImagePickerController.InfoKey.editedImage]
        if object == nil {
            object = info[UIImagePickerController.InfoKey.originalImage]
            if object == nil {
                let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                if let anUrl = url {
                    object = try? Data(contentsOf: anUrl)
                }
            }
        }
        completion(true, type, object)
        self.hide()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion(false, nil, nil)
        self.hide()
    }
    
}

//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
