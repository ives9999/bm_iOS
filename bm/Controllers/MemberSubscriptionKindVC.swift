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
    
    lazy var tableView2: MyTable2VC<MemberSubscriptionKindCell, MemberSubscriptionKindTable, MemberSubscriptionKindVC> = {
        let tableView = MyTable2VC<MemberSubscriptionKindCell, MemberSubscriptionKindTable, MemberSubscriptionKindVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    lazy var tableView3: UITableView = {
        let view: UITableView = UITableView()
        view.backgroundColor = UIColor(MY_BLACK)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        
        view.register(DescCell.self, forCellReuseIdentifier: "DescCell")
        view.register(MemberSubscriptionKindCell.self, forCellReuseIdentifier: "MemberSubscriptionKindCell")
        
        return view
    }()
    
    var items = [MemberSubscriptionKindTable]() {
        didSet {
            reloadData()
        }
    }
    
    var rows: [MemberSubscriptionKindTable] = [MemberSubscriptionKindTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTop()
        initBottom()
        initTableView()
        anchor()
        
        //tableView2.anchor(parent: view, showTop: descLbl, showBottom: showBottom2!)
        
        refresh()
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("\(MEMBER_SUBSCRIPTION_KIND.stringToEnum(Member.instance.subscription).rawValue)會員")
        showTop2!.showLog()
    }
    
    func initBottom() {
        showBottom2 = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom2!)
        showBottom2!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: true)
        showBottom2!.setSubmitBtnTitle("取消訂閱")
        showBottom2!.setCancelBtnTitle("回上一頁")
    }
    
    func initTableView() {
        tableView3.dataSource = self
        tableView3.delegate = self
    }
    
    func anchor() {
        
        self.view.addSubview(tableView3)
        tableView3.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom)
            make.bottom.equalTo(showBottom2!.snp.top).offset(-20)
            make.left.right.equalToSuperview()
        }
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer(page: 1)
        //tableView2.getDataFromServer(page: page)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscriptionKind(member_token: Member.instance.token, page: page, perPage: tableView2.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                
                self.parseJSON(jsonData: MemberService.instance.jsonData)
                //self.rows = self.showTableView(tableView: self.tableView2, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func reloadData() {
        tableView3.reloadData()
    }
    
    func parseJSON(jsonData: Data?) {
        
        var rows: [MemberSubscriptionKindTable] = [MemberSubscriptionKindTable]()
        do {
            if (jsonData != nil) {
                //print(jsonData!.prettyPrintedJSONString)
                let tables2: Tables2 = try JSONDecoder().decode(Tables2<MemberSubscriptionKindTable>.self, from: jsonData!)
                if (tables2.success) {
                    if tables2.rows.count > 0 {
                        
                        for row in tables2.rows {
                            row.filterRow()
                            
                            if self.tableViewSetSelected(row: row) {
                                row.selected = true
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
        
        if (rows.count > 0) {
            if (page == 1) {
                items = [MemberSubscriptionKindTable]()
            }
            items += rows
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

    
    override func log() {
        toMemberSubscriptionLog()
    }
    
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

extension MemberSubscriptionKindVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 0
        } else {
            return self.items.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DescCell", for: indexPath) as? DescCell {
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MemberSubscriptionKindCell", for: indexPath) as? MemberSubscriptionKindCell {
                if items.count >= indexPath.row {
                    cell.item = self.items[indexPath.row - 1]
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
}

extension MemberSubscriptionKindVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && items.count >= indexPath.row {
            let item: MemberSubscriptionKindTable = items[indexPath.row - 1]
            didSelect(item: item, at: indexPath)
        }
    }
}

class DescCell: UITableViewCell {
    
    let titleLbl = {
        let view = SuperLabel()
        view.setTextTitle()
        view.text = "訂閱會員介紹"
        
        return view
    }()
    
    let descLbl = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: "FFFFFF", alpha: 0.56)
        view.setTextSize(16)
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
        view.setLineHeight(lineHeight: 0.5)
        
        return view
    }()
    
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
    
    func commonInit() {
        self.contentView.backgroundColor = UIColor(MY_BLACK)
        anchor()
    }
    
    func anchor() {
        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        self.contentView.addSubview(descLbl)
        descLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}

class MemberSubscriptionKindCell: BaseCell<MemberSubscriptionKindTable, MemberSubscriptionKindVC> {
    
    var containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(hex: BOTTOM_VIEW_BACKGROUND, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    var leftContainerView: UIView = UIView()
    
    var icon: IconWithBGRoundCorner = IconWithBGRoundCorner(icon: "", frameWidth: 48, frameHeight: 48, iconWidth: 32, iconHeight: 32)
    
    var centerContainerView: UIView = UIView()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextBold()
        view.setTextSize(16)
        view.text = "xxx"
        
        return view
    }()
    
    let lotteryLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(TEXT_DESC)
        view.setTextSize(12)
        view.text = "xxx"
        
        return view
    }()
    
    var rightContainerView: UIView = UIView()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_GREEN)
        view.setTextBold()
        view.setTextSize(24)
        view.textAlignment = .right
        view.text = "300"
        
        return view
    }()
    
    let ntLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_GREEN)
        view.setTextSize(12)
        view.textAlignment = .right
        view.text = "NT$"
        
        return view
    }()
    
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
        super.commonInit()
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
            containerView.addSubview(leftContainerView)
            leftContainerView.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().offset(-16)
                make.width.height.equalTo(48)
            }
            
                leftContainerView.addSubview(icon)
                icon.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
        
            containerView.addSubview(rightContainerView)
            //rightContainerView.backgroundColor = UIColor.red
            rightContainerView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().offset(-16)
                make.right.equalToSuperview().offset(-16)
                make.width.equalTo(100)
            }
        
                rightContainerView.addSubview(priceLbl)
                priceLbl.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(4)
                    make.right.equalToSuperview()
                }
        
                rightContainerView.addSubview(ntLbl)
                ntLbl.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-2)
                    make.bottom.equalToSuperview()
                }
        
            containerView.addSubview(centerContainerView)
            //centerContainerView.backgroundColor = UIColor.green
            centerContainerView.snp.makeConstraints { make in
                make.left.equalTo(leftContainerView.snp.right).offset(8)
                make.top.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().offset(-16)
                //make.width.equalTo(300)
                make.right.equalTo(rightContainerView.snp.left)
            }
        
                centerContainerView.addSubview(nameLbl)
                nameLbl.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(4)
                    make.left.equalToSuperview()
                }

                centerContainerView.addSubview(lotteryLbl)
                lotteryLbl.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-4)
                }
        
        


    }
    
    override func configureSubViews() {
        
        //super.configureSubViews()
        
        icon.setIcon("subscription_\(item!.eng_name)")
        nameLbl.text = item!.name
        lotteryLbl.text = "每次開箱球拍券：\(item!.lottery)張"
        priceLbl.text = (item!.price == 0) ? "免費" : "\(String(item!.price))/月"
        
        if item!.selected {
            setSelectedStyle()
        }
        
        setClickBackgroundColor()
    }
    
    func setSelectedStyle() {
        containerView.backgroundColor = UIColor(CELL_SELECTED)
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor(MY_GREEN).cgColor
    }
    
    func setClickBackgroundColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED)
        selectedBackgroundView = bgColorView
    }
}

