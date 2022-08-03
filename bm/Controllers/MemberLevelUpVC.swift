//
//  MemberLevelUp.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberLevelUpVC: BaseViewController {
    
    @IBOutlet weak var bottomThreeView: BottomThreeView!
    
    lazy var tableView: MyTable2VC<MemberLevelUpCell, MemberLevelKindTable> = {
        let tableView = MyTable2VC<MemberLevelUpCell, MemberLevelKindTable>(didSelect: didSelect(item:at:))
        return tableView
    }()
    
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
                self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    override func didSelect<T: Table>(item: T, at indexPath: IndexPath) {
        print(item.title + "\(indexPath.row)")
    }
    
    func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("訂閱")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退訂")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
}

class MemberLevelUpCell: BaseTableViewCell<MemberLevelKindTable> {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    
    override var item: MemberLevelKindTable? {
        didSet {
            titleLbl?.text = item?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

//class LevelKindResultTable: Codable {
//
//    var success: Bool = false
//    var grand_price: Int = 0
//    var grand_give: Int = 0
//    var grand_spend: Int = 0
//    var handle_fee: Int = 0
//    var transfer_fee: Int = 0
//    var return_coin: Int = 0
//    
//    init() {}
//    
//    required init(from decoder: Decoder) throws {
//        
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
//        grand_price = try container.decodeIfPresent(Int.self, forKey: .grand_price) ?? 0
//        grand_give = try container.decodeIfPresent(Int.self, forKey: .grand_give) ?? 0
//        grand_spend = try container.decodeIfPresent(Int.self, forKey: .grand_spend) ?? 0
//        handle_fee = try container.decodeIfPresent(Int.self, forKey: .handle_fee) ?? 0
//        transfer_fee = try container.decodeIfPresent(Int.self, forKey: .transfer_fee) ?? 0
//        return_coin = try container.decodeIfPresent(Int.self, forKey: .return_coin) ?? 0
//    }
//}
