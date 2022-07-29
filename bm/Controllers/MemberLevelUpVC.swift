//
//  MemberLevelUp.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberLevelUpVC: BaseViewController {
    
    @IBOutlet weak var top: Top!
    @IBOutlet weak var bottomThreeView: BottomThreeView!
    
    lazy var tableView: MyTableVC2<MemberLevelUpCell, OneRow> = {
        let tableView = MyTableVC2<MemberLevelUpCell, OneRow>(didSelect: didSelect(item:at:))
        return tableView
    }()
    
    //var myTableView: MyTableVC2<MemberLevelUpCell, OneRow>
    
    var oneRows: [OneRow] = [OneRow]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "進階會員")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        setupBottomThreeView()
        
        initRows()
    }
    
    func didSelect(item: OneRow, at indexPath: IndexPath) {
        print(item.title + "\(indexPath.row)")
    }
    
    func initRows() {
        var oneRow: OneRow = OneRow()
        oneRow.title = "金牌"
        oneRows.append(oneRow)
        
        oneRow = OneRow()
        oneRow.title = "銀牌"
        oneRows.append(oneRow)
        
        oneRow = OneRow()
        oneRow.title = "銅牌"
        oneRows.append(oneRow)
        
        oneRow = OneRow()
        oneRow.title = "鐵牌"
        oneRows.append(oneRow)
        
        tableView.items = oneRows
    }
    
    func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("訂閱")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退訂")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
}

class MemberLevelUpCell: BaseTableViewCell<OneRow> {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    
    override var item: OneRow? {
        didSet {
            titleLbl?.text = item?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func update(row: OneRow) {
//
//        titleLbl.text = row.title
//    }
    
}
