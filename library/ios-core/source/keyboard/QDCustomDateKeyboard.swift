/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public class QDCustomDateKeyboard: QDKeyboard, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    public enum DisplayMode : Int {
        case time // 6 | 53 | PM
        case date // November | 15 | 2007
        case dateAndTime //  Jan | 01 | 2015 | 6 | 53 | PM)
        case expireCard // November | 2007
    }
    
    public enum MinuteMode : Int {
        case one = 1
        case five = 5
        case ten = 10
        case fifteen = 15
        case twenty = 20
        case thirty = 30
    }
    
    private class DateObject {
        
        private var _year : Int! = 1970
        private var _month : Int! = 1
        private var _day: Int! = 1
        private var _hour : Int! = 12
        private var _minute : Int! = 0
        private var _apm : Int! = 0
        private var _24mode: Bool
        
        private func valueOf(_ value: Int , between minValue : Int, _ maxValue : Int) -> Int {
            return min(max(minValue, value), maxValue)
        }
        
        var year : Int {
            get {
                return _year
            }
            set {
                self.day = _day
                _year = newValue
            }
        }
        var month : Int {
            get {
                return valueOf(_month, between: 1, 12)
            }
            set {
                self.day = _day
                _month = valueOf(newValue, between: 1, 12)
            }
        }
        var day: Int {
            get {
                let maxValue = Date.numberOfDayIn(month: month, year: year)
                return valueOf(_day, between: 1, maxValue)
            }
            set {
                let maxValue = Date.numberOfDayIn(month: month, year: year)
                _day = valueOf(newValue, between: 1, maxValue)
            }
        }
        var hour : Int {
            get {
                if _24mode {
                    return valueOf(_hour, between: 0, 23)
                } else {
                    return valueOf(_hour, between: 1, 12)
                }
            }
            set {
                if _24mode {
                    _hour = valueOf(newValue, between: 0, 23)
                } else {
                    _hour = valueOf(newValue, between: 1, 12)
                }
                
            }
        }
        var minute : Int {
            get {
                return valueOf(_minute, between: 0, 59)
            }
            set {
                _minute = valueOf(newValue, between: 0, 59)
            }
        }
        var apm : Int {
            get {
                return valueOf(_apm, between: 0, 1)
            }
            set {
                _apm = valueOf(newValue, between: 0, 1)
            }
        }
        
        private init(_ year : Int, month : Int, day: Int, hour : Int, minute : Int, apm : Int, is24Mode: Bool) {
            _24mode = is24Mode
            self.year = year
            self.month = month
            self.day = day
            self.hour = hour
            self.minute = minute
            self.apm = apm
            
        }
        
        init(_ date : Date, is24Mode: Bool) {
            _24mode = is24Mode
            let component = date.getComponents()
            year = component.year
            month = component.month
            day = component.day
            if _24mode {
                hour = component.hour
            } else {
                let tmp = component.hour % 12
                if tmp == 0 {
                    hour = 12
                } else {
                    hour = tmp
                }
            }
            minute = component.minute
            apm = component.hour / 12
        }
        
        func date(_ mode : DisplayMode) -> Date {
            switch mode {
            case .date:
                return Date.date(String(format: "%4d %2d %2d", year, month, day), format: "yyyy MM dd")!
            case .expireCard:
                return Date.date(String(format: "%4d %2d %2d", year, month, 01), format: "yyyy MM dd")!
            default:
                if _24mode {
                    return Date.date(String(format: "%4d %2d %2d %2d:%2d", year, month, day, hour, minute), format: "yyyy MM dd HH:mm")!
                } else {
                    return Date.date(String(format: "%4d %2d %2d %2d:%2d %@", year, month, day, hour, minute, (apm == 0) ? "AM" : "PM"), format: "yyyy MM dd hh:mm a")!
                }
                
            }
            
        }
        
        func value(_ field : String) -> Int? {
            var value : Int?
            switch field {
            case "year":
                value = year
                break
            case "month":
                value = month
                break
            case "day":
                value = day
                break
            case "hour":
                value = hour
                break
            case "minute":
                value = minute
                break
            case "apm":
                value = apm
                break
            default:
                value = 0
                break
            }
            return value
        }
        
        func setValue(_ value : Int, field : String) {
            switch field {
            case "year":
                year = value
                break
            case "month":
                month = value
                break
            case "day":
                day = value
                break
            case "hour":
                hour = value
                break
            case "minute":
                minute = value
                break
            case "apm":
                apm = value
                break
            default:
                
                break
            }
        }
        
        func copy() -> DateObject {
            return DateObject.init(year, month: month, day: day, hour: hour, minute: minute, apm: apm, is24Mode: _24mode)
        }
        
    }
    
    private class Row {
        
        var text : String
        var value : Int
        
        init(_ value : Int, text : String) {
            self.value = value
            self.text = text
        }
        
    }
    
    private class Group  {
        
        var width : CGFloat
        var data : [Row]
        var id : String
        var loop : Int
        
        init(_ id : String, data : [Row], loop : Int = 1, width : CGFloat) {
            self.id = id
            self.data = data
            self.loop = loop
            self.width = width
        }
    }
    
    // MARK: -------------- Private --------------
    
    private weak var delegate : QDKeyboardProtocol?
    private var pickerView = UIPickerView()
    
    private var mode : DisplayMode!
    private var minDate : Date!
    private var maxDate : Date!
    private var minuteInterval: MinuteMode!
    private var locale: String!
    private var is24Mode: Bool!
    
    private var selectDate : DateObject!
    
    private var years, months, days, hours, minutes, apms: [Row]!
    private var list : [Group]!
    
    open override var backgroundColor: UIColor? {
        get {
            return pickerView.backgroundColor
        }
        set {
            pickerView.backgroundColor = newValue
        }
    }
    
    private func initialize() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addFixView(pickerView)
    }
    
    private func monthSymbol (_ isShort : Bool = true) -> [String] {
        let formater = DateFormatter()
        formater.locale = Locale.init(identifier: locale)
        let array: [String]
        if isShort {
            array = formater.shortMonthSymbols
        } else {
            array = formater.monthSymbols
        }
        var result = [String]()
        for str in array {
            result.append(str.capitalized)
        }
        return result
    }
    
    private func apmSymbol() -> [String] {
        let formater = DateFormatter()
        formater.locale = Locale.init(identifier: locale)
        return [formater.amSymbol.uppercased(), formater.pmSymbol.uppercased()]
    }
    
    private func loadData() {
        years = []
        let minYear = min(minDate.getDayMonthYear().year, 1970)
        let maxYear = max(maxDate.getDayMonthYear().year, 2099)
        for y in minYear ... maxYear {
            years.append(Row(y, text: String(y)))
        }
        months = []
        var symbols = monthSymbol(mode! == .dateAndTime)
        for i in 1 ... 12 {
            months.append(Row((i), text: symbols[i-1]))
        }
        days = []
        let num = Date.numberOfDayIn(month: selectDate.month, year: selectDate.year)
        for i in 1 ... num {
            days.append(Row(i, text: String(i)))
        }
        hours = []
        if is24Mode {
            for i in 1 ... 24 {
                hours.append(Row(i, text: String(i)))
            }
        } else {
            for i in 1 ... 12 {
                hours.append(Row(i, text: String(i)))
            }
        }
        
        minutes = []
        for i in 0 ... 59 {
            if (i % minuteInterval.rawValue == 0) {
                var str = String(i)
                if str.count < 2 {
                    str = "0" + str
                }
                minutes.append(Row(i, text: str))
            }
        }
        symbols = apmSymbol()
        apms = [Row(0, text: symbols[0]), Row(1, text: symbols[1])]
        
        switch mode! {
        case .time:
            let ratio : CGFloat = UIScreen.main.bounds.width / 320
            list = [
                    Group("hour" , data : hours, loop : 1000, width: ratio * 60),
                    Group("minute" , data : minutes, loop : 1000, width: ratio * 60)
                    ]
            if !is24Mode {
                list.append(Group("apm" , data : apms, width: ratio * 80))
            }
            break
        case .date:
            let ratio : CGFloat = UIScreen.main.bounds.width / 320
            list = [
                    Group("month" , data : months, loop : 1000, width: ratio * 140),
                    Group("day" , data : days, loop : 1000, width: ratio * 40),
                    Group("year" , data : years, width: ratio * 80)
                    ]
        case .dateAndTime:
            let ratio : CGFloat = UIScreen.main.bounds.width / 320
            list = [
                    Group("month" , data : months, loop : 1000, width: ratio * 55),
                    Group("day" , data : days, loop : 1000, width: ratio * 37),
                    Group("year" , data : years, width: ratio * 65),
                    Group("hour" , data : hours, loop : 1000, width: ratio * 37),
                    Group("minute" , data : minutes, loop : 1000, width: ratio * 37)
                    ]
            if !is24Mode {
                list.append(Group("apm" , data : apms, width: ratio * 80))
            }
        default:
            let ratio : CGFloat = UIScreen.main.bounds.width / 320
            list = [
                Group("month" , data : months, loop : 1000, width: ratio * 140),
                Group("year" , data : years, width: ratio * 80)
            ]
        }
    }
    
    private func selectPicker(center : Bool = false , animated : Bool = false) {
        let count = pickerView.numberOfComponents
        for component in 0 ..< count {
            let group = list[component]
            let value : Int = selectDate.value(group.id)!
            var row : Int = 0
            for i in 0 ..< group.data.count {
                if value == group.data[i].value {
                    row = i
                    break
                }
            }
            var cycle : Int
            if center {
                cycle = group.loop / 2
            } else {
                let selectedRow = pickerView.selectedRow(inComponent: component)
                cycle = selectedRow / group.data.count
            }
            row = row + cycle * group.data.count
            pickerView.selectRow(row, inComponent: component, animated: animated)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return list.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let group = list[component]
        return group.width
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let group = list[component]
        return group.data.count * group.loop
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let group = list[component]
        let obj = group.data[row % group.data.count]
        let dateObj = selectDate.copy()
        dateObj.setValue(obj.value, field: group.id)
        let date = dateObj.date(mode)
        var color : UIColor
        if date.timeIntervalSince(minDate) >= 0 && date.timeIntervalSince(maxDate) <= 0 {
            color = .black
        } else {
            color = .gray
        }
        return NSAttributedString(obj.text, font: .systemFont(ofSize: 17), color: color, aligment: .left)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let lastMonth = selectDate.month
        let lastYear = selectDate.year
        
        var outbound : Bool = false
        var reload : Bool = false
        let group = list[component]
        let value = group.data[row % group.data.count].value
        selectDate.setValue(value, field: group.id)
        var date = selectDate.date(mode)
        if date < minDate {
            setDate(minDate)
            date = selectDate.date(mode)
            outbound = true
        } else if date > maxDate {
            setDate(maxDate)
            date = selectDate.date(mode)
            outbound = true
        }
        if lastMonth != selectDate.month || lastYear != selectDate.year {
            loadData()
            reload = true
        }
        pickerView.reloadAllComponents()
        if outbound || reload {
            selectPicker(animated: outbound)
        }
        delegate?.keyboardSelected(self, value: date)
    }
    
    public override func reloadGUI() {
        loadData()
        pickerView.reloadAllComponents()
    }
    
    private func setDate(_ date: Date) {
        var candidate = date
        if (minuteInterval != .one) {
            let round = minuteInterval.rawValue
            let minute = DateObject.init(date, is24Mode: is24Mode).minute
            let tmp = (minute / round) * round - minute
            if tmp != 0 {
                let offset = tmp + round
                candidate = candidate.dateByAdd(minute: offset)!
                if candidate > maxDate {
                    candidate = candidate.dateByAdd(minute: -round)!
                    if candidate < minDate {
                        fatalError("can not correct select data")
                    }
                }
            }
        }
        selectDate = DateObject.init(candidate, is24Mode: is24Mode)
    }
    
    private func setRange(_ minDate: Date, maxDate: Date) {
        if maxDate.timeIntervalSince(minDate) >= 3600 {
            if mode == .dateAndTime {
                self.minDate = minDate
                self.maxDate = maxDate
            } else {
                self.minDate = minDate.beginDate()
                self.maxDate = maxDate.endDate()
            }
        } else {
            self.minDate = Date.date(year: 1970, month: 1, day: 1)!
            self.maxDate = Date.date(year: 2099, month: 12, day: 31)!.endDate()
        }
    }
    
    // MARK: -------------- Public --------------
    
    public init(_ field: UITextField?, minDate: Date! = Date.date(year: 1970, month: 1, day: 1)!, maxDate : Date! = Date.date(year: 2099, month: 12, day: 31)!.endDate(), mode : DisplayMode = .date, locale: String = "en_US", minuteInterval: MinuteMode! = .one, is24Mode: Bool = true, delegate : QDKeyboardProtocol?) {
        super.init(field)
        self.locale = locale
        self.mode = mode
        self.is24Mode = is24Mode
        self.minuteInterval = minuteInterval
        self.delegate = delegate
        setRange(minDate, maxDate: maxDate)
        initialize()
        setDate(Date())
        loadData()
        selectPicker(center : true)
        super.backgroundColor = .clear
    }
    
    public func updateRange(_ minDate: Date?, maxDate: Date?) {
        setRange(minDate ?? self.minDate, maxDate: maxDate ?? self.maxDate)
        loadData()
        selectPicker(animated: true)
        
    }
    
    public override func select(_ data: Any) {
        setDate(data as! Date)
        selectPicker(animated: true)
    }
    
}
