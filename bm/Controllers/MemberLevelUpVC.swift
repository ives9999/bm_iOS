//
//  MemberLevelUp.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberLevelUpVC: BaseViewController {
    
    lazy var tableView: MyTable2VC<MemberLevelUpCell, MemberLevelKindTable> = {
        let tableView = MyTable2VC<MemberLevelUpCell, MemberLevelKindTable>(didSelect: didSelect(item:at:), selected: tableViewSetSelected(row:))
        return tableView
    }()
    
    var rows: [MemberLevelKindTable] = [MemberLevelKindTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "進階會員")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        setupBottomThreeView()
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.levelKind(member_token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.rows = self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func tableViewSetSelected(row: MemberLevelKindTable)-> Bool {
        return row.eng_name == Member.instance.level ? true : false
    }
    
    func didSelect<T: MemberLevelKindTable>(item: T, at indexPath: IndexPath) {
        toMemberLevelUpPay(name: item.name, price: item.price, kind: item.eng_name)
    }
    
    override func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("退訂")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.isHidden = true
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
}

class MemberLevelUpCell: BaseCell<MemberLevelKindTable> {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var priceLbl: SuperLabel!
    
    override func configureSubViews() {
        
        super.configureSubViews()
        titleLbl?.text = item?.name
        priceLbl?.text = "NT$: " + String(item!.price) + " 元/月"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

