/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

// MARK: -------------- Cell/Header/Footer Data --------------

open class QDCellData {
    
    static public let CellIdentifier : String = "cell"
    
    open var id : Any?
    open var data : Any?
    open var editable : Bool
    open var cell : String
    open var accessory : UITableViewCell.AccessoryType?
    
    public init(_ id: Any? = nil, cell: String = CellIdentifier, data : Any?, editable : Bool = false, accessory: UITableViewCell.AccessoryType? = nil) {
        self.id = id
        self.cell = cell
        self.data = data
        self.editable = editable
        self.accessory = accessory
    }
    
}

// MARK: -------------- Section Data --------------

open class QDSectionData {
    
    open var header : QDCellData?
    open var cells : [QDCellData]!
    open var footer : QDCellData?
    
    public init(_ cells : [QDCellData]!, header : QDCellData? = nil, footer : QDCellData? = nil) {
        self.header = header
        self.footer = footer
        self.cells = cells
    }
    
    public func isEmpty() -> Bool {
        return cells.count == 0 && header == nil && footer == nil
    }
    
}

// MARK: -------------- Table Cell --------------

open class QDTableCell: UITableViewCell {
    
    open var id: Any?
    open var data: Any?
    
    open func setData(_ data : Any?) {
        self.data = data
    }
    
    func setId(_ id: Any?) {
        self.id = id
    }
    
}

// MARK: -------------- Table View Controller --------------
open class QDTableViewController: QDViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet public weak var tableView: UITableView!
    
    private var _list = [QDSectionData]()
    
    public var list : [QDSectionData]! {
        get {
            return _list
        }
        
        set {
            _list = newValue
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].cells.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section].header?.data as? String
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = list[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: data.cell, for: indexPath)
        if let accessory = data.accessory {
            cell.accessoryType = accessory
        } else {
            cell.accessoryType = .none
        }
        render(cell, id: data.id, data: data.data)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let data = list[indexPath.section].cells[indexPath.row]
        userDidTapAccessoryButton(data.id, data: data.data)
        userDidTapAccessoryButtonAt(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = list[indexPath.section].cells[indexPath.row]
        userDidTapCell(data.id, data: data.data)
        userDidTapCellAt(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = list[indexPath.section].cells[indexPath.row]
            userDidTapDeleteCell(data.id, data: data.data)
            userDidTapDeleteCellAt(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return list[indexPath.section].cells[indexPath.row].editable
        
    }
    
    open func userDidTapAccessoryButton(_ id: Any?, data: Any?) {
        
    }
    
    open func userDidTapAccessoryButtonAt(_ indexPath: IndexPath) {
        
    }
    
    open func userDidTapCell(_ id: Any?, data: Any?) {
        
    }
    
    open func userDidTapCellAt(_ indexPath: IndexPath) {
        
    }
    
    open func userDidTapDeleteCell(_ id: Any?, data: Any?) {
        
    }
    
    open func userDidTapDeleteCellAt(_ indexPath: IndexPath) {
        
    }
    
    open func render(_ cell : UITableViewCell!, id: Any?, data: Any?) -> Void {
        if let tableCell = cell as? QDTableCell {
            tableCell.setId(id)
            tableCell.setData(data)
        }
    }
}
