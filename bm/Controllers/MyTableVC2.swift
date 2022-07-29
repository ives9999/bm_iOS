//
//  MyTableVC2.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import UIKit

class MyTableVC2<T: BaseTableViewCell<U>, U>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let cellId: String = "BaseCellID"
    
    var items = [U]() {
        didSet {
            reloadData()
        }
    }
    
    typealias didSelectClosure = ((U, IndexPath) -> Void)?
    var didSelect: didSelectClosure
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? BaseTableViewCell<U>
        cell?.backgroundColor = UIColor.clear
        cell?.item = items[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelect?(items[indexPath.row], indexPath)
    }
}

class BaseTableViewCell<U>: UITableViewCell {
    var item: U?
}
