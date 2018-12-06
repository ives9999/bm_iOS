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
    
    static func registerCells(for tableView: UITableView) {
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textField")
        
        let moreNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreNib, forCellReuseIdentifier: "more")
        
        let dateTimeNib = UINib(nibName: "DateTimeCell", bundle: nil)
        tableView.register(dateTimeNib, forCellReuseIdentifier: "dateTime")
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
        }
        
        return cell
    }
}






















