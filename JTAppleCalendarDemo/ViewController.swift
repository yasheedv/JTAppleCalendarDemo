//
//  ViewController.swift
//  JTAppleCalendarDemo
//
//  Created by Yasheed Muhammed on 4/26/18.
//  Copyright © 2018 Yasheed Muhammed. All rights reserved.
//

import UIKit
import JTAppleCalendar
class ViewController: UIViewController {

    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    let outsideMonthColor = UIColor.clear//UIColor.init(rgb:0x584a66)
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor.init(rgb:0x3a294b)
    let currentDateSelectedViewColor = UIColor.init(rgb:0x4e3f5d)
    let selectedViewColor = UIColor.init(rgb:0xF5A623)
    let rangeColor = UIColor.init(rgb:0xfee9cf)
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let formatter = DateFormatter()
    
    // date range selection
    var firstDate: Date?
    var lastDate: Date?
    var rangeSelectedDates: [Date] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCalnedarView()
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setUpCalnedarView(){
        self.calendarView.minimumLineSpacing = 2.0
        self.calendarView.minimumInteritemSpacing = 0.0
        //self.calendarView.scrollToDate(Date(),animateScroll: false,preferredScrollPosition: .bottom)
        //self.calendarView.selectDates([Date()])
        self.calendarView.cellSize = 44
        self.calendarView.scrollingMode = .none
        setUpRangeSelection()
        
    }
    func setUpRangeSelection(){
        self.calendarView.allowsMultipleSelection = true
        self.calendarView.isRangeSelectionUsed = true
//        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
//        panGensture.minimumPressDuration = 0.2
//        self.calendarView.addGestureRecognizer(panGensture)
    }
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        let todaysDate = Date()
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString = formatter.string(from: todaysDate)
        let monthsDateString = formatter.string(from: cellState.date)
        if todayDateString == monthsDateString && cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = UIColor.red
        } else if cellState.date < todaysDate && cellState.dateBelongsTo == .thisMonth{
            validCell.dateLabel.textColor = UIColor.lightGray
        }else {
            if cellState.isSelected {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = self.selectedMonthColor
                }
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = self.monthColor
                } else {
                    validCell.dateLabel.textColor = self.outsideMonthColor
                }
            }
        }
        
    }
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
//            if cellState.dateBelongsTo != .thisMonth {
//                validCell.selectedView.isHidden = true
//                validCell.leftView.isHidden = true
//                validCell.rightView.isHidden = true
//                validCell.backgroundColor = UIColor.clear
//            } else {
//                validCell.selectedView.isHidden = false
//            }
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
            validCell.leftView.isHidden = true
            validCell.rightView.isHidden = true
            validCell.backgroundColor = UIColor.clear
            validCell.dateLabel.isHidden = false

        }
    }
    func handleDateRangeSelection(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CustomCell else { return }
        if calendarView.allowsMultipleSelection {
            if cellState.isSelected {
                if cellState.dateBelongsTo == .thisMonth {
                    cell.selectedView.isHidden = false
                } else {
                    cell.selectedView.isHidden = true
                }
                switch cellState.selectedPosition() {
                    
                case .full:
                    cell.dateLabel.isHidden = false
                    cell.backgroundColor = UIColor.clear
                    cell.selectedView.backgroundColor = self.selectedViewColor
                    cell.leftView.isHidden = true
                    cell.rightView.isHidden = true
                case .right:
                    //cell.selectedView.isHidden = false
                    if cellState.dateBelongsTo != .thisMonth {
                        cell.leftView.isHidden = true
                    } else {
                        cell.leftView.isHidden = false
                    }
                    cell.backgroundColor = UIColor.white
                    cell.selectedView.backgroundColor = self.selectedViewColor
                case .left:
                    //cell.selectedView.isHidden = false
                    if cellState.dateBelongsTo != .thisMonth {
                        cell.rightView.isHidden = true
                    } else {
                        cell.rightView.isHidden = false
                    }
                    cell.backgroundColor = UIColor.white
                    cell.selectedView.backgroundColor = self.selectedViewColor
                case .middle:
                    if cellState.dateBelongsTo != .thisMonth {
                        cell.dateLabel.isHidden = true
                    } else {
                        cell.dateLabel.isHidden = false
                    }
                    cell.backgroundColor = self.rangeColor
                    cell.leftView.isHidden = true
                    cell.rightView.isHidden = true
                    cell.selectedView.backgroundColor = self.rangeColor // Or what ever you want for your dates that land in the middle
                default:
                    cell.backgroundColor = UIColor.white
                    cell.dateLabel.isHidden = false
                    cell.leftView.isHidden = true
                    cell.rightView.isHidden = true
                    cell.selectedView.isHidden = true
                    cell.selectedView.backgroundColor = nil // Have no selection when a cell is not selected
                }
            }
            
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        self.year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        self.month.text = formatter.string(from: date)
    }

}

extension ViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Date()//formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2081 12 01")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate,calendar: Calendar.current, generateInDates:.forAllMonths,generateOutDates:.tillEndOfRow,hasStrictBoundaries: true)
        
        return parameters
    }
    
}
extension ViewController:JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)

//        if cellState.dateBelongsTo != .thisMonth {
//            cell.isHidden = true
//        } else {
//            cell.isHidden = false
//        }
        cell.layoutIfNeeded()
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)
        cell.layoutIfNeeded()


    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)

        if firstDate != nil {
            if date < self.firstDate! {
                self.firstDate = date
            } else {
                self.lastDate = date
            }
            calendarView.selectDates(from: firstDate!, to: self.lastDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
            self.lastDate = date
        }
        
        //self.rangingStarted(cellState: cellState)
        cell?.bounce()
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)
        self.calendarView.deselectDates(from: self.firstDate!, to: self.lastDate!, triggerSelectionDelegate: false)
        if date != self.firstDate && date != self.lastDate {
            if date < self.firstDate! {
                self.firstDate = date
            } else {
                self.lastDate = date
            }
            calendarView.selectDates(from: firstDate!, to: self.lastDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            cell?.bounce()
        } else {
            self.firstDate = nil
            self.lastDate = nil
        }
        

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeader", for: indexPath) as! CalendarHeader
        self.formatter.dateFormat = "yyyy"
        header.yearLabel.text = formatter.string(from: range.start)
        self.formatter.dateFormat = "MMMM"
        header.monthLabel.text = formatter.string(from: range.start)
        return header
    }
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 107)
    }
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString = formatter.string(from: Date())
        let monthsDateString = formatter.string(from: cellState.date)
        
        if cellState.dateBelongsTo != .thisMonth || (cellState.date < Date() && todayDateString != monthsDateString){
            return false
        } else {
            return true
        }
    }
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo == .thisMonth {
            return true
        } else {
            return false
        }
    }
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
