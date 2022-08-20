//
//  MyTableVC2.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import UIKit

class MyTable2VC<T: BaseTableViewCell<U>, U: Table>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let cellId: String = "BaseCellID"
    
    var page: Int = 1
    var perPage: Int = PERPAGE
    var totalCount: Int = 100000
    var totalPage: Int = 1
    
    var items = [U]() {
        didSet {
            reloadData()
        }
    }
    
    //var rows: [U] = [U]()
    
    typealias didSelectClosure = ((U, IndexPath) -> Void)?
    var didSelect: didSelectClosure
    
    var msg: String = ""
    
    init(didSelect: didSelectClosure) {
        self.didSelect = didSelect
        super.init(frame: CGRect.zero, style: .plain)
        
        registerCell()
                
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerCell() {
        
        //register(T.self, forCellReuseIdentifier: cellId)
        let nibName: String = String(describing: T.self)
        let cellNibName = UINib(nibName: nibName, bundle: nil)
        register(cellNibName, forCellReuseIdentifier: cellId)
    }
    
    func anchor(parent: UIView, top: Top, bottomThreeView: BottomThreeView) {
        
        parent.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
        bottomAnchor.constraint(equalTo: bottomThreeView.topAnchor).isActive = true
        
        backgroundColor = UIColor(MY_BLACK)
        
        estimatedRowHeight = 44
        rowHeight = UITableView.automaticDimension
        
        separatorStyle = .singleLine
        separatorColor = UIColor.lightGray
    }
    
    func parseJSON(jsonData: Data?)-> Bool {
        
        let _rows: [U] = genericTable2(jsonData: jsonData)
        if (_rows.count == 0) {
            return false
        } else {
            if (page == 1) {
                items = [U]()
            }
            items += _rows
        }
        
        return true
    }
    
    func genericTable2(jsonData: Data?)-> [U] {
        
        var rows: [U] = [U]()
        do {
            if (jsonData != nil) {
                //print(jsonData!.prettyPrintedJSONString)
                let tables2: Tables2 = try JSONDecoder().decode(Tables2<U>.self, from: jsonData!)
                if (tables2.success) {
                    if tables2.rows.count > 0 {
                        
                        for row in rows {
                            row.filterRow()
                            setItemSelected(row: row)
                        }
                        
                        if (page == 1) {
                            page = tables2.page
                            perPage = tables2.perPage
                            totalCount = tables2.totalCount
                            let _totalPage: Int = totalCount / perPage
                            totalPage = (totalCount % perPage > 0) ? _totalPage + 1 : _totalPage
                        }
                        
                        rows += tables2.rows
                    }
                } else {
                    msg = "解析JSON字串時，沒有成功，系統傳回值錯誤，請洽管理員"
                }
            } else {
                msg = "無法從伺服器取得正確的json資料，請洽管理員"
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        
        return rows
    }
    
    func setItemSelected(row: U) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? BaseTableViewCell<U>
        cell?.backgroundColor = UIColor.clear
        
        //cell?.setSelectedBackgroundColor()
        
        cell?.no = indexPath.row
        cell?.item = items[indexPath.row]
        if cell != nil {
            if cell!.item!.selected {
                cell!.setSelectedBackgroundColor()
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelect?(items[indexPath.row], indexPath)
    }
}

class BaseTableViewCell<U>: UITableViewCell {
    
    var item: U?
    var no: Int?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSelectedBackgroundColor() {
        backgroundColor = UIColor(CELL_SELECTED)
    }
    
//    func setSelectedBackgroundColor() {
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor(MY_RED)
//        selectedBackgroundView = bgColorView
//    }
}
