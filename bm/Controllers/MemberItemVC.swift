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
        showTop2!.setTitle(mainMemberEnum.rawValue)
        
        self.view.addSubview(tableView)
        //tableView.backgroundColor = UIColor.red
        tableView.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //let validate: Int = Member.instance.validate
        
        let enums: [MemberItemEnum] = MemberItemEnum.allValues(mainMemberEnum)
        for myEnum in enums {
            rows.append(MainMemberTable(title: myEnum.rawValue, icon: myEnum.getIcon()))
        }
        tableView.items = rows
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        if let _item: MainMemberTable = item as? MainMemberTable {
            let memberItemEnum: MemberItemEnum? = MemberItemEnum.toEnum(rawValue: _item.title)
            if memberItemEnum != nil {
                to(mainMemberEnum: mainMemberEnum, memberItemEnum: memberItemEnum!)
            }
        }
    }
    
    func to(mainMemberEnum: MainMemberEnum, memberItemEnum: MemberItemEnum) {
        if (mainMemberEnum == MainMemberEnum.info) {
            if (memberItemEnum == MemberItemEnum.info) {
                toRegister()
            } else if (memberItemEnum == MemberItemEnum.change_password) {
                toPassword(type: "change_password")
            } else if (memberItemEnum == MemberItemEnum.email_validate) {
                toValidate(type: "email")
            } else if (memberItemEnum == MemberItemEnum.mobile_validate) {
                toValidate(type: "mobile")
            }
        } else if (mainMemberEnum == MainMemberEnum.order) {
            if (memberItemEnum == MemberItemEnum.cart) {
                toMemberCartList()
            } else if (memberItemEnum == MemberItemEnum.order) {
                toMemberOrderList()
            }
        } else if (mainMemberEnum == MainMemberEnum.like) {
            if (memberItemEnum == MemberItemEnum.team) {
                toTeam(member_like: true)
            } else if (memberItemEnum == MemberItemEnum.arena) {
                toArena(member_like: true, isShowPrev: true)
            } else if (memberItemEnum == MemberItemEnum.teach) {
                toTeach(member_like: true)
            } else if (memberItemEnum == MemberItemEnum.coach) {
                toCoach(member_like: true)
            } else if (memberItemEnum == MemberItemEnum.course) {
                toCourse(member_like: true, isShowPrev: true)
            } else if (memberItemEnum == MemberItemEnum.product) {
                toProduct(member_like: true)
            } else if (memberItemEnum == MemberItemEnum.store) {
                toStore(member_like: true)
            }
        } else if (mainMemberEnum == MainMemberEnum.join) {
            if (memberItemEnum == MemberItemEnum.team) {
                toMemberTeamList()
            } else if (memberItemEnum == MemberItemEnum.tempPlay) {
                toMemberSignuplist(able_type: "temp")
            } else if (memberItemEnum == MemberItemEnum.course) {
                toMemberSignuplist(able_type: "course")
            }
        } else if (mainMemberEnum == MainMemberEnum.manager) {
            if (memberItemEnum == MemberItemEnum.team) {
                toManagerTeam(manager_token: Member.instance.token)
            } else if (memberItemEnum == MemberItemEnum.requestManager) {
                toRequestManagerTeam()
            } else if (memberItemEnum == MemberItemEnum.course) {
                toManagerCourse(manager_token: Member.instance.token)
            } else if (memberItemEnum == MemberItemEnum.match) {
                toManagerMatch(manager_token: Member.instance.token)
            }
        }
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

enum MemberItemEnum: String {
    
    case info = "帳戶資料"
    case change_password = "更改密碼"
    case email_validate = "EMail認證"
    case mobile_validate = "手機認證"
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
    case match = "賽事"
    
    //static let allValues: [MemberInfoItemEnum] = [data, change_password]
    static func allValues(_ mainMemberEnum: MainMemberEnum)-> [MemberItemEnum] {
        switch mainMemberEnum {
        case MainMemberEnum.info:
            var arr: [MemberItemEnum] = [.info, .change_password]
            let validate: Int = Member.instance.validate
            if (validate & EMAIL_VALIDATE <= 0) {
                arr.append(.email_validate)
            }
            if (validate & MOBILE_VALIDATE <= 0) {
                arr.append(.mobile_validate)
            }
            return arr
        case MainMemberEnum.order: return [.cart, .order]
        case MainMemberEnum.like: return [.team, .arena, .teach, .coach, .course, .product, .store]
        case MainMemberEnum.join: return [.team, .tempPlay, .course]
        case MainMemberEnum.manager: return [.team, .requestManager, .course]
        
        default: return [.info, .change_password]
        }
    }
    
    static func toEnum(rawValue: String)-> MemberItemEnum? {
        if let thisEnum: MemberItemEnum = MemberItemEnum(rawValue: rawValue) {
            return thisEnum
        } else {
            return nil
        }
    }
    
    func getIcon()-> String {
        switch self {
        case .info: return "info_svg"
        case .email_validate: return "validate_svg"
        case .mobile_validate: return "validate_svg"
        case .change_password: return "change_password_svg"
        case .cart: return "cart_svg"
        case .order: return "order_svg"
        case .team: return "team_on_svg"
        case .arena: return "arena_on_svg"
        case .teach: return "teach_svg"
        case .coach: return "coach_svg"
        case .course: return "course_on_svg"
        case .product: return "product_svg"
        case .store: return "store_svg"
        case .tempPlay: return "tempPlay_svg"
        case .requestManager: return "request_manager_svg"
        case .match: return "match_g_svg"
        }
    }
}
