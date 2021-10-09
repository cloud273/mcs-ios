/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import FSCalendar
import QDWhiteLabel

class McsBaseCalendarViewController: McsViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var maxDate: Date?
    private var minDate: Date?
    private var _calendar: FSCalendar!
    var calendar: FSCalendar! {
        get {
            return _calendar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(scrollView)
        setupCollectionView()
        setupCalendar()
    }
    
    func setupCollectionView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let offset : CGFloat = 10
        layout.sectionInset = UIEdgeInsets.init(top: offset, left: offset, bottom: offset, right: offset)
        layout.minimumInteritemSpacing = offset
        layout.minimumLineSpacing = offset
    }
    
    func setCalendarDates(_ minDate: Date?, maxDate: Date?) {
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    func setupCalendar() {
        _calendar = FSCalendar.init(frame: CGRect.zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = Date()
        calendar.allowsMultipleSelection = false
        calendar.firstWeekday = 1
        calendar.locale = Locale.init(identifier: McsDatabase.instance.language.rawValue)
        let appearance = calendar.appearance
        appearance.caseOptions = (FSCalendarCaseOptions.headerUsesUpperCase).union(.weekdayUsesSingleUpperCase)
        appearance.headerTitleFont = "small-font".whiteLabelFont!
        appearance.headerTitleColor = "red-color".whiteLabelColor!
        appearance.weekdayFont = "small-font".whiteLabelFont!
        appearance.weekdayTextColor = "title-blue-color".whiteLabelColor!
        appearance.titleTodayColor = "red-color".whiteLabelColor!
        appearance.todayColor = .clear
        appearance.titleFont = "normal-font".whiteLabelFont!
        appearance.titleSelectionColor = "white-color".whiteLabelColor!
        appearance.titleDefaultColor = "black-color".whiteLabelColor!
        appearance.selectionColor = "black-color".whiteLabelColor!
        calendarView.addFixView(calendar)
    }
    
    func numberOfCollectionCoumn() -> CGFloat {
        return 1
    }
    
    func heightOfCollectionCell(_ width: CGFloat) -> CGFloat {
        return 40
    }

}

extension McsBaseCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        containerHeightConstraint.constant = bounds.height
        calendarView.layoutIfNeeded()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return minDate ?? Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return maxDate ?? Date()
    }
    
}

extension McsBaseCalendarViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let column = numberOfCollectionCoumn()
        let width = (collectionView.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * (column - 1)) / column - 1
        let height = heightOfCollectionCell(width)
        return CGSize.init(width: width, height: height)
    }
    
}
