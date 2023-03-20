//
//  MemberItemVC.swift
//  bm
//
//  Created by ives on 2023/3/20.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MemberItemVC: BaseViewController {
    
    var mainMemberEnum: MainMemberEnum = MainMemberEnum.info
    
    var showTop2: ShowTop2?
    
    lazy var tableView: MyTable2VC<MemberItemCell, MainMemberTable, MemberItemVC> = {
        let tableView = MyTable2VC<MemberItemCell, MainMemberTable, MemberItemVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer, myDelegate: self, isRefresh: false)
        
        return tableView
    }()
    
    var rows: [MainMemberTable] = [MainMemberTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle(title: mainMemberEnum.rawValue)
        
        self.view.addSubview(tableView)
        //tableView.backgroundColor = UIColor.red
        tableView.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let enums: [MemberItemEnum] = MemberItemEnum.allValues(mainMemberEnum)
        for myEnum in enums {
            rows.append(MainMemberTable(title: myEnum.rawValue, icon: myEnum.getIcon()))
        }
        tableView.items = rows
    }
    
    func tableViewSetSelected(row: MainMemberTable)-> Bool {
        return false
    }
    
    func getDataFromServer(page: Int) {
    }
}

class MemberItemCell: BaseCell<MainMemberTable, MemberItemVC> {
    
    let containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(BOTTOM_VIEW_BACKGROUND)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    let iconIV: UIImageView = UIImageView()
    let titleLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        
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
        anchor()
    }
    
    func anchor() {
        //self.containerView.heightConstraint?.constant = 60
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        containerView.addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        containerView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(50)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        if item != nil {
            iconIV.image = UIImage(named: item!.icon)
            titleLbl.text = item!.title
        }
    }
}

//enum MemberItemEnum {
//    case info
//    case order
//    case like
//    case join
//    case team
//}

enum MemberItemEnum: String {
    
    case data = "帳戶資料"
    case change_password = "更改密碼"
    case cart = "購物車"
    case order = "訂單查詢"
    case team = "球隊"
    case arena = "球館"
    case teach = "教學"
    case coach = "教練"
    case course = "課程"
    case product = "商品"
    case store = "體育用品店"
    case tempPlay = "臨打"
    case requestManager = "球隊申請管理權"
    
    //static let allValues: [MemberInfoItemEnum] = [data, change_password]
    static func allValues(_ mainMemberEnum: MainMemberEnum)-> [MemberItemEnum] {
        switch mainMemberEnum {
        case MainMemberEnum.info: return [.data, .change_password]
        case MainMemberEnum.order: return [.cart, .order]
        case MainMemberEnum.like: return [.team, .arena, .teach, .coach, .course, .product, .store]
        case MainMemberEnum.join: return [.team, .tempPlay, .course]
        case MainMemberEnum.manager: return [.team, .requestManager, .course]
        
        default: return [.data, .change_password]
        }
    }
    
    func getIcon()-> String {
        switch self {
        case .data: return "info_svg"
        case .change_password: return "info_svg"
        case .cart: return "cart_svg"
        case .order: return "order_svg"
        case .team: return "team_on_svg"
        case .arena: return "arena_on_svg"
        case .teach: return "teach_on_svg"
        case .coach: return "coach_on_svg"
        case .course: return "course_on_svg"
        case .product: return "product_svg"
        case .store: return "store_svg"
        case .tempPlay: return "tempPlay_svg"
        case .requestManager: return "request_manager_svg"
        }
    }
}
