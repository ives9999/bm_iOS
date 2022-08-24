//
//  MyTableVC2.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import UIKit

protocol BaseTableViewDelegates: UITableViewDelegate, UITableViewDataSource {
    func cellForRow(atBaseTableIndexPath: IndexPath)-> UITableViewCell
}

class MyTable2VC<T: BaseCell<U>, U: Table>: UITableView, BaseTableViewDelegates {
    
    //let cellId: String = "BaseCellID"
    
    var page: Int = 1
    var perPage: Int = PERPAGE
    var totalCount: Int = 100000
    var totalPage: Int = 1
    var msg: String = ""
    //var baseViewDelegate: BaseViewController?
    
    var items = [U]() {
        didSet {
            reloadData()
        }
    }
    
    //var rows: [U] = [U]()
    
    typealias didSelectClosure = ((U, IndexPath) -> Void)?
    var didSelect: didSelectClosure
    
    typealias selectedClosure = ((U) -> Bool)?
    var selected: selectedClosure
    
    init(didSelect: didSelectClosure, selected: selectedClosure) {
        
        self.didSelect = didSelect
        self.selected = selected
        super.init(frame: CGRect.zero, style: .plain)
        
        register(T.nibName, forCellReuseIdentifier: T.identifier)
        //registerCell()
                
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //func registerCell() {
        
        //register(T.self, forCellReuseIdentifier: cellId)
//        let nibName: String = String(describing: T.self)
//        let cellNibName = UINib(nibName: nibName, bundle: nil)
        //register(cellNibName, forCellReuseIdentifier: cellId)
    //}
    
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
            reloadData()
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
                        
                        for row in tables2.rows {
                            row.filterRow()
                            
                            if let b: Bool = selected?(row) {
                                row.selected = b
                            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func cellForRow(atBaseTableIndexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: atBaseTableIndexPath) as? BaseCell<U>
        //let cell = self.dequeueReusableCell(withIdentifier: cellId, for: atBaseTableIndexPath) as? BaseCell<U>
        
        let item = items[atBaseTableIndexPath.row]
        item.no = atBaseTableIndexPath.row
        
        cell?.item = item
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellForRow(atBaseTableIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelect?(items[indexPath.row], indexPath)
    }
}

class BaseCell<U: Table>: UITableViewCell {
    
    var item: U? {
        didSet {
            configureSubViews()
        }
    }

    var no: Int?
    
    func configureSubViews() {
        if (item != nil) {
            backgroundColor = item!.selected ? UIColor(CELL_SELECTED) : UIColor.clear
        }
        
        setSelectedBackgroundColor()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSelectedBackgroundColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED1)
        selectedBackgroundView = bgColorView
    }
}

extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nibName: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}












