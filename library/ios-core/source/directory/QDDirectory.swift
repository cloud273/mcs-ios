/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public class QDDirectory: NSObject {
    
    static public func document() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    static public func library() -> String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
    
    static public func temporary() -> String {
        return NSTemporaryDirectory()
    }
    
    static public func cache() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    static public func applicationSupport() -> String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
    }
    
    static private func createFolder(_ dir : String) -> Bool {
        let fileManager = FileManager.default
        var directory : ObjCBool = false
        if fileManager.fileExists(atPath: dir, isDirectory: &directory) == false || directory.boolValue == false {
            do {
                try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                return false
            }
        }
        return true
    }
    
    static public func createFolderAt(_ folder : String, parentFolder: String) -> String? {
        let dir = parentFolder.appending("/" + folder)
        if createFolder(dir) {
            return dir
        }
        return nil
    }
    
    static public func createFolderAtDocument(_ folder : String) -> String? {
        return createFolderAt(folder, parentFolder: document())
    }
    
    static public func createFolderAtLibrary(_ folder : String) -> String? {
        return createFolderAt(folder, parentFolder: library())
    }
    
    static public func createFolderAtTemporay(_ folder : String) -> String? {
        return createFolderAt(folder, parentFolder: temporary())
    }
    
    static public func createFolderAtCache(_ folder : String) -> String? {
        return createFolderAt(folder, parentFolder: cache())
    }
    
    static public func createFolderAtApplicationSupport(_ folder : String) -> String? {
        return createFolderAt(folder, parentFolder: applicationSupport())
    }
    
}
