/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

open class QDSelectKeyboard: QDKeyboard, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: -------------- Private --------------
    
    class TextObj: QDKBObjectProtocol {

        var text : String
        var font : UIFont?
        var color : UIColor?
        
        init(_ text : String, font: UIFont?, color: UIColor?) {
            self.text = text
            self.font = font
            self.color = color
        }
        
        func equal(_ object: Any?) -> Bool {
            return text == (object as! TextObj).text
        }
        
        func getAttributeText() -> NSAttributedString {
            return NSAttributedString.init(text, font: font ?? UIFont.systemFont(ofSize: 15), color: color ?? UIColor.black, aligment: .center)
        }
        
    }
    
    class TextProtocolObj: QDKBObjectProtocol {
        
        var obj : QDKbTextProtocol
        var font : UIFont?
        var color : UIColor?
        
        init(_ obj : QDKbTextProtocol, font: UIFont?, color: UIColor?) {
            self.obj = obj
            self.font = font
            self.color = color
        }
        
        func equal(_ object: Any?) -> Bool {
            return obj.equal((object as? TextProtocolObj)?.obj)
        }
        
        func getAttributeText() -> NSAttributedString {
            return NSAttributedString.init(obj.getText(), font: font ?? UIFont.systemFont(ofSize: 15), color: color ?? UIColor.black, aligment: .center)
        }
        
    }
    
    fileprivate weak var delegate : QDKeyboardProtocol?
    
    private var pickerView = UIPickerView()
    
    private var list: [QDKBObjectProtocol]!
    
    private var aligment: NSTextAlignment = .center
    
    private var font: UIFont?
    
    private var color: UIColor?
    
    private var rowHeight: CGFloat?
    
    private func initialize() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addFixView(pickerView)
    }
    
    open override var backgroundColor: UIColor? {
        get {
            return pickerView.backgroundColor
        }
        set {
            pickerView.backgroundColor = newValue
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight ?? 30
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel.init()
        }
        let obj = list[row]
        label!.baselineAdjustment = .alignCenters
        label!.attributedText = obj.getAttributeText()
        return label!
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let obj = list[row]
        if let object = obj as? TextObj {
            delegate?.keyboardSelected(self, value: object.text)
        } else if let object = obj as? TextProtocolObj {
            delegate?.keyboardSelected(self, value: object.obj)
        } else {
            delegate?.keyboardSelected(self, value: obj)
        }
    }
    
    public override func reloadGUI() {
        pickerView.reloadAllComponents()
    }
    
    private init(field: UITextField?, list: [QDKBObjectProtocol]!, font: UIFont? = nil, color: UIColor? = nil, rowHeight: CGFloat? = 30, delegate: QDKeyboardProtocol?) {
        super.init(field)
        self.font = font
        self.color = color
        self.list = list
        self.delegate = delegate
        initialize()
        
    }
    
    // MARK: -------------- Public --------------
    
    public convenience init(_ field: UITextField?, list: [QDKBObjectProtocol]!, rowHeight: CGFloat? = 30, delegate: QDKeyboardProtocol?) {
        self.init(field: field, list: list, rowHeight: rowHeight, delegate: delegate)
    }
    
    public convenience init(_ field: UITextField?, list: [String]!, font: UIFont? = nil, color: UIColor? = nil, rowHeight: CGFloat? = 30, delegate: QDKeyboardProtocol?) {
        var objs = [TextObj]()
        for item in list {
            objs.append(TextObj(item, font: font, color: color))
        }
        self.init(field: field, list: objs, font: font, color: color, rowHeight: rowHeight, delegate: delegate)
    }
    
    public convenience init(_ field: UITextField?, list: [QDKbTextProtocol]!, font: UIFont? = nil, color: UIColor? = nil, rowHeight: CGFloat? = 30, delegate: QDKeyboardProtocol?) {
        var objs = [TextProtocolObj]()
        for item in list {
            objs.append(TextProtocolObj(item, font: font, color: color))
        }
        self.init(field: field, list: objs, font: font, color: color, rowHeight: rowHeight, delegate: delegate)
    }
    
    public func update(_ texts : [String]) {
        var list = [TextObj]()
        for item in texts {
            list.append(TextObj(item, font: font, color: color))
        }
        self.list = list
        reloadGUI()
    }
    
    public func update(_ objs : [QDKbTextProtocol]) {
        var list = [TextProtocolObj]()
        for item in objs {
            list.append(TextProtocolObj(item, font: font, color: color))
        }
        self.list = list
        reloadGUI()
    }
    
    public func update(_ data : [QDKBObjectProtocol]) {
        self.list = data
        reloadGUI()
    }
    
    public override func select(_ data: Any) {
        if let data = data as? QDKBObjectProtocol {
            let index : Int? = list.firstIndex { (item) -> Bool in
                return item.equal(data)
            }
            if index != nil {
                pickerView.selectRow(index!, inComponent: 0, animated: true)
            } else {
                fatalError("Cannot find object")
            }
        } else if let obj = data as? QDKbTextProtocol {
            let data = TextProtocolObj(obj, font: font, color: color)
            select(data)
        } else if let obj = data as? String {
            let data = TextObj(obj, font: font, color: color)
            select(data)
        } else {
            fatalError("Wrong object type")
        }
    }
    
}
