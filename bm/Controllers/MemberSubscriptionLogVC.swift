//
//  MemberLevelLogVC.swift
//  bm
//
//  Created by ives on 2022/8/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberSubscriptionLogVC: BaseViewController {
    
    lazy var tableView: MyTable2VC<MemberSubscriptionLogCell, MemberSubscriptionLogTable> = {
        let tableView = MyTable2VC<MemberSubscriptionLogCell, MemberSubscriptionLogTable>(didSelect: didSelect(item:at:), selected: tableViewSetSelected(row:))
        return tableView
    }()
    
    var rows: [MemberSubscriptionLogTable] = [MemberSubscriptionLogTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "訂閱會員付款紀錄")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
                
        refresh()
    }
    
    override func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("退訂")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("查詢")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscriptionLog(member_token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.rows = self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func tableViewSetSelected(row: MemberSubscriptionLogTable)-> Bool {
        return false
    }
    
    func didSelect<T: MemberSubscriptionKindTable>(item: T, at indexPath: IndexPath) {}
}

class MemberSubscriptionLogCell: BaseCell<MemberSubscriptionLogTable> {
    
    @IBOutlet weak var noLbl: SuperLabel!
    @IBOutlet weak var priceLbl: SuperLabel!
    @IBOutlet weak var dateLbl: SuperLabel!
    
    override func configureSubViews() {
        
        super.configureSubViews()
        noLbl?.text = String(item!.no)
        priceLbl?.text = "NT$: " + String(item!.amount) + " 元"
        dateLbl?.text = item?.created_at.noSec()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
