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
    case date
    case time
    case color
    case status
    case content
    case privacy
    case password
    case sex
    case plain
    case tag
    case color1
    case clothesSize
    case number
    case weight
    case section
    
    static func registerCell(for tableView: UITableView) {
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textField")
        
        let contentNib = UINib(nibName: "ContentCell", bundle: nil)
        tableView.register(contentNib, forCellReuseIdentifier: "content")
        
        let moreNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreNib, forCellReuseIdentifier: "more")
        
        let dateTimeNib = UINib(nibName: "DateTimeCell", bundle: nil)
        tableView.register(dateTimeNib, forCellReuseIdentifier: "dateTime")
        
        let weekdayNib = UINib(nibName: "WeekdayCell", bundle: nil)
        tableView.register(weekdayNib, forCellReuseIdentifier: "weekday")
        let dateNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.register(dateNib, forCellReuseIdentifier: "date")
        let timeNib = UINib(nibName: "TimeCell", bundle: nil)
        tableView.register(timeNib, forCellReuseIdentifier: "time")
        let colorNib = UINib(nibName: "ColorCell", bundle: nil)
        tableView.register(colorNib, forCellReuseIdentifier: "color")
        let statusNib = UINib(nibName: "StatusCell", bundle: nil)
        tableView.register(statusNib, forCellReuseIdentifier: "status")
        let privacyNib = UINib(nibName: "PrivacyCell", bundle: nil)
        tableView.register(privacyNib, forCellReuseIdentifier: "privacy")
        let passwordNib = UINib(nibName: "PasswordCell", bundle: nil)
        tableView.register(passwordNib, forCellReuseIdentifier: "password")
        let sexNib = UINib(nibName: "SexCell", bundle: nil)
        tableView.register(sexNib, forCellReuseIdentifier: "sex")
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainNib, forCellReuseIdentifier: "plain")
        
        let tagNib = UINib(nibName: "TagCell", bundle: nil)
        tableView.register(tagNib, forCellReuseIdentifier: "tag")
        
        let color1Nib = UINib(nibName: "Color1Cell", bundle: nil)
        tableView.register(color1Nib, forCellReuseIdentifier: "color1")
        
        let clothesSizeNib = UINib(nibName: "ClothesSizeCell", bundle: nil)
        tableView.register(clothesSizeNib, forCellReuseIdentifier: "clothesSize")
        
        let numberNib = UINib(nibName: "NumberCell", bundle: nil)
        tableView.register(numberNib, forCellReuseIdentifier: "number")
        
        let weightNib = UINib(nibName: "WeightCell", bundle: nil)
        tableView.register(weightNib, forCellReuseIdentifier: WEIGHT_KEY)
    }
    
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch self {
        case .textField:
            cell = tableView.dequeueReusableCell(withIdentifier: "textField", for: indexPath)
        case .more:
            cell = tableView.dequeueReusableCell(withIdentifier: "more", for: indexPath)
        case .content:
            cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath)
        case .dateTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "dateTime", for: indexPath)
        case .weekday:
            cell = tableView.dequeueReusableCell(withIdentifier: "weekday", for: indexPath)
        case .date:
            cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath)
        case .time:
            cell = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath)
        case .color:
            cell = tableView.dequeueReusableCell(withIdentifier: "color", for: indexPath)
        case .status:
            cell = tableView.dequeueReusableCell(withIdentifier: "status", for: indexPath)
        case .privacy:
            cell = tableView.dequeueReusableCell(withIdentifier: "privacy", for: indexPath)
        case .password:
            cell = tableView.dequeueReusableCell(withIdentifier: "password", for: indexPath)
        case .sex:
            cell = tableView.dequeueReusableCell(withIdentifier: "sex", for: indexPath)
        case .plain:
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
        case .tag:
            cell = tableView.dequeueReusableCell(withIdentifier: "tag", for: indexPath)
        case .color1:
            cell = tableView.dequeueReusableCell(withIdentifier: "color1", for: indexPath)
        case .clothesSize:
            cell = tableView.dequeueReusableCell(withIdentifier: "clothesSize", for: indexPath)
        case .number:
            cell = tableView.dequeueReusableCell(withIdentifier: "number", for: indexPath)
        case .weight:
            cell = tableView.dequeueReusableCell(withIdentifier: WEIGHT_KEY, for: indexPath)
        case .section:
            cell = UITableViewCell()
        }
        
        return cell
    }
}






















