//
//  FormItemCellType.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation
import UIKit

enum FormItemCellType {
    case textField
    case more
    case dateTime
    case weekday
    case time
    
    static func registerCells(for tableView: UITableView) {
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textField")
        
        let moreNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreNib, forCellReuseIdentifier: "more")
        
        let dateTimeNib = UINib(nibName: "DateTimeCell", bundle: nil)
        tableView.register(dateTimeNib, forCellReuseIdentifier: "dateTime")
        
        let weekdayNib = UINib(nibName: "WeekdayCell", bundle: nil)
        tableView.register(weekdayNib, forCellReuseIdentifier: "weekday")
        let timeNib = UINib(nibName: "TimeCell", bundle: nil)
        tableView.register(timeNib, forCellReuseIdentifier: "time")
    }
    
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch self {
        case .textField:
            cell = tableView.dequeueReusableCell(withIdentifier: "textField", for: indexPath)
        case .more:
            cell = tableView.dequeueReusableCell(withIdentifier: "more", for: indexPath)
        case .dateTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "dateTime", for: indexPath)
        case .weekday:
            cell = tableView.dequeueReusableCell(withIdentifier: "weekday", for: indexPath)
        case .time:
            cell = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath)
        }
        
        return cell
    }
}






















