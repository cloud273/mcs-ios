/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public class QDDateKeyboard: QDKeyboard {
    
    weak private var delegate : QDKeyboardProtocol?
    
    private let datePicker = UIDatePicker()
    
    open override var backgroundColor: UIColor? {
        get {
            return datePicker.backgroundColor
        }
        set {
            datePicker.backgroundColor = newValue
        }
    }
    
    public final var textColor: UIColor? {
        get {
            return datePicker.value(forKey: "textColor") as? UIColor
        }
        set {
            datePicker.setValue(newValue, forKey: "textColor")
        }
    }
    
    public init(_ field : UITextField?, minDate: Date?, maxDate : Date? , mode: UIDatePicker.Mode = .date, minuteInterval: Int = 1, locale: Locale? = nil, delegate : QDKeyboardProtocol?) {
        
        super.init(field)
        
        self.delegate = delegate
        
        datePicker.datePickerMode = mode
        
        datePicker.minuteInterval = 1
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.minimumDate = minDate
        
        datePicker.maximumDate = maxDate
        
        datePicker.minuteInterval = minuteInterval
        
        datePicker.locale = locale
            
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.addFixView(datePicker)
        
        datePicker.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)
        
        super.backgroundColor = .clear
    }
    
    public override func select(_ data: Any) {
        datePicker.setDate(data as! Date, animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func valueChange() {
        delegate?.keyboardSelected(self, value: datePicker.date)
    }
    
}
