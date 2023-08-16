//
//  MemberLevelUp.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberSubscriptionKindVC: BaseViewController {
    
    var showTop2: ShowTop2?
    var showBottom2: ShowBottom2?
    
    let titleLbl = {
        let view = SuperLabel()
        view.setTextTitle()
        view.text = "訂閱會員介紹"
        
        return view
    }()
    
    let descLbl = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.numberOfLines = 0
        view.text = """
        訂閱會員將享有羽球密碼的各種優惠\n
        1.鑽石會員享有12張開箱球拍券。\n
        2.白金會員享有7張開箱球拍券。\n
        3.金牌會員享有3張開箱球拍券。\n
        4.銀牌會員享有2張開箱球拍券。\n
        5.銅牌會員享有1張開箱球拍券。\n
        6.鐵盤會員沒有開箱球拍券。\n
        7.基本會員沒有開箱球拍券。\n
        """
        //view.setLineHeight(lineHeight: 2)
        
        return view
    }()
    
    lazy var tableView2: MyTable2VC<MemberSubscriptionKindCell, MemberSubscriptionKindTable, MemberSubscriptionKindVC> = {
        let tableView = MyTable2VC<MemberSubscriptionKindCell, MemberSubscriptionKindTable, MemberSubscriptionKindVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var rows: [MemberSubscriptionKindTable] = [MemberSubscriptionKindTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTop()
        initBottom()
        anchor()
        
        tableView2.anchor(parent: view, showTop: descLbl, showBottom: showBottom2!)
        
        refresh()
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("訂閱會員")
        showTop2!.showRefresh()
    }
    
    func initBottom() {
        showBottom2 = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom2!)
        showBottom2!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: true)
        showBottom2!.setSubmitBtnTitle("取消訂閱")
        showBottom2!.setCancelBtnTitle("回上一頁")
    }
    
    func anchor() {
        self.view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(descLbl)
        descLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    override func refresh() {
        
        page = 1
        tableView2.getDataFromServer(page: page)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscriptionKind(member_token: Member.instance.token, page: page, perPage: tableView2.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.rows = self.showTableView(tableView: self.tableView2, jsonData: MemberService.instance.jsonData!)
                //self.showTop2!.setTitle("訂閱會員")
            }
        }
    }
    
    func tableViewSetSelected(row: MemberSubscriptionKindTable)-> Bool {
        //print("\(row.eng_name) => \(Member.instance.subscription)")
        return row.eng_name == Member.instance.subscription ? true : false
    }
    
    //1.如果按下原本訂閱的選項，不動作
    //2.如果已經有訂閱需要先退訂
    //3.如果按下「基本」表示要退訂
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        
        guard let _item = item as? MemberSubscriptionKindTable else { return }
        
        let kind: MEMBER_SUBSCRIPTION_KIND = MEMBER_SUBSCRIPTION_KIND.stringToEnum(_item.eng_name)
        
        //如果點選原來訂閱的選項，不做任何動作
        if kind == MEMBER_SUBSCRIPTION_KIND.stringToEnum(Member.instance.subscription) {
            return
        }
        
        //如果點選基本選項，執行退訂
        if kind == MEMBER_SUBSCRIPTION_KIND.basic {
            threeBtnPressed()
            return
        }
        
        //如果點選其他選項，警告要先退訂
        if MEMBER_SUBSCRIPTION_KIND.stringToEnum(Member.instance.subscription) != MEMBER_SUBSCRIPTION_KIND.basic {
            warning("您已經有訂閱，如果要更改，請先執行「退訂」，再重新訂閱，謝謝")
            return
        }
        
        //toMemberScriptionPay(name: _item.name, price: _item.price, kind: _item.eng_name)
        
        subscription(kind)
    }
    
    override func cancel() {
        prev()
    }
    
//    override func setupBottomThreeView() {
//        bottomThreeView.delegate = self
//        bottomThreeView.submitButton.setTitle("查詢")
//        bottomThreeView.cancelButton.setTitle("回上一頁")
//        bottomThreeView.threeButton.setTitle("退訂")
//        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
//    }
//
//    override func submitBtnPressed() {
//        toMemberSubscriptionLog()
//    }
    
    override func submit() {
        
        if MEMBER_SUBSCRIPTION_KIND.stringToEnum(Member.instance.subscription) == MEMBER_SUBSCRIPTION_KIND.basic {
            warning("基本會員無法退訂")
        } else {
            
            warning(msg: "是否真的要退訂？", closeButtonTitle: "取消", buttonTitle: "確定") {
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.unSubscription { success in
                    Global.instance.removeSpinner(superView: self.view)
                    self.jsonData = MemberService.instance.jsonData
                    //print(self.jsonData?.prettyPrintedJSONString)
                    
                    do {
                        if (self.jsonData != nil) {
                            let table: OrderUpdateResTable = try JSONDecoder().decode(OrderUpdateResTable.self, from: self.jsonData!)
                            if (!table.success) {
                                self.warning(table.msg)
                            } else {
                                self.info("已經完成退訂")
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                        self.warning(self.msg)
                        print(error)
                    }
                }
            }
        }
    }
    
    func subscription(_ kind: MEMBER_SUBSCRIPTION_KIND) {
        
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscription(kind: kind.enumToEng()) { Success in
            Global.instance.removeSpinner(superView: self.view)
            
            self.jsonData = MemberService.instance.jsonData
            //print(self.jsonData?.prettyPrintedJSONString)
            
            do {
                if (self.jsonData != nil) {
                    let table: OrderUpdateResTable = try JSONDecoder().decode(OrderUpdateResTable.self, from: self.jsonData!)
                    if (!table.success) {
                        self.warning(table.msg)
                    } else {
                        let orderTable: OrderTable? = table.model
                        if (orderTable != nil) {
                            let ecpay_token: String = orderTable!.ecpay_token
                            let ecpay_token_ExpireDate: String = orderTable!.ecpay_token_ExpireDate
                            self.info(msg: "訂閱已經成立，是否前往付款？", showCloseButton: true, buttonTitle: "付款") {
                                self.toPayment(order_token: orderTable!.token, ecpay_token: ecpay_token, tokenExpireDate: ecpay_token_ExpireDate)
                            }
                        }
                    }
                } else {
                    self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                }
            } catch {
                self.msg = "解析JSON字串時，得到空值，請洽管理員"
                self.warning(self.msg)
                print(error)
            }
            
        }
    }
}

class MemberSubscriptionKindCell: BaseCell<MemberSubscriptionKindTable, MemberSubscriptionKindVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let lotteryLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "300"
        
        return view
    }()
    
//    @IBOutlet weak var titleLbl: SuperLabel!
//    @IBOutlet weak var priceLbl: SuperLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func commonInit() {
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        self.contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(lotteryLbl)
        lotteryLbl.snp.makeConstraints { make in
            make.left.equalTo(nameLbl.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        
        noLbl.text = String(item!.no) + "."
        nameLbl.text = item?.name
        lotteryLbl.text = "每次開箱球拍券：\(item!.lottery)張"
        priceLbl.text = "NT$: " + String(item!.price) + " 元/月"
    }
}

