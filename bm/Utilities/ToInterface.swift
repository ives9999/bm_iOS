//
//  File.swift
//  bm
//
//  Created by ives on 2021/6/14.
//  Copyright © 2021 bm. All rights reserved.
//

extension BaseViewController {
    
    func toAddCart(product_token: String?=nil, cartItem_token: String?=nil, login: @escaping (_ baseViewController: BaseViewController)-> Void, register:  @escaping (_ baseViewController: BaseViewController)-> Void) {
        
        var msg: String = ""
        if !Member.instance.isLoggedIn {
            warning(msg: "必須先登入會員，才能進行購買", showCloseButton: true, buttonTitle: "登入") {
                self.goHomeThen(completion: login)
            }
        } else {
            msg = Member.instance.checkMust()

            if (msg.count > 0) {
                warning(msg: msg, showCloseButton: true, buttonTitle: "填寫") {
                    self.goHomeThen(completion: register)
                }
            }
            msg = Member.instance.checkValidate(must: 3)
            if msg.count > 0 {
                warning(msg)
            } else {
                if #available(iOS 13.0, *) {
                    let storyboard = UIStoryboard(name: "More", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(identifier: TO_ADD_CART)  as? AddCartVC {
                        viewController.product_token = product_token
                        viewController.cartItem_token = cartItem_token
                        viewController.modalPresentationStyle = .fullScreen
                        show(viewController, sender: nil)
                    }
                } else {
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_ADD_CART) as! AddCartVC
                    viewController.product_token = product_token
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func toArena(member_like: Bool=false, isShowPrev: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toArena") as? ArenaVC {
                viewController.member_like = member_like
                viewController.isShowPrev = isShowPrev
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toArena") as! ArenaVC
            viewController.member_like = member_like
            viewController.isShowPrev = isShowPrev
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toCoach(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-fEf-Ib-3oR") as? CoachVC {
                viewController.member_like = member_like
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-fEf-Ib-3oR") as! CoachVC
            viewController.member_like = member_like
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toCourse(member_like: Bool=false, isShowPrev: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "Course") as? CourseVC {
                viewController.member_like = member_like
                viewController.isShowPrev = isShowPrev
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Course") as! CourseVC
            viewController.member_like = member_like
            viewController.isShowPrev = isShowPrev
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toEditContent(key: String, title: String, content: String?, _delegate: BaseViewController?) {
        
        let v: ContentEditVC = ContentEditVC()
        v.key = key
        v.title = title
        if (content != nil) {
            v.content = content
        }
        if (_delegate != nil) {
            v.delegate = _delegate
        }
        v.modalPresentationStyle = .fullScreen
        show(v, sender: nil)
        
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-Rnr-RQ-nbw") as? ContentEditVC {
//                viewController.key = key
//
//                viewController.title = title
//                if (content != nil) {
//                    viewController.content = content
//                }
//
//                if (_delegate != nil) {
//                    viewController.delegate = _delegate
//                }
//                viewController.modalPresentationStyle = .fullScreen
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-Rnr-RQ-nbw") as! ContentEditVC
//            viewController.key = key
//
//            if (content != nil) {
//                viewController.content = content
//            }
//
//            if (_delegate != nil) {
//                viewController.delegate = _delegate
//            }
//            viewController.modalPresentationStyle = .fullScreen
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
    }
    
    func toEditCourse(token: String, _delegate: BaseViewController? = nil) {
        
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "editCourse") as? EditCourseVC {
                viewController.token = token
                if (_delegate != nil) {
                    viewController.delegate = _delegate
                }
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "editCourse") as! EditCourseVC
            viewController.token = token
            if (_delegate != nil) {
                viewController.delegate = _delegate
            }
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toEditTeam(token: String, _delegate: BaseViewController? = nil) {
        
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Team", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "editTeam") as? EditTeamVC {
                viewController.token = token
                if (_delegate != nil) {
                    viewController.delegate = _delegate
                }
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "editTeam") as! EditTeamVC
            viewController.token = token
            if (_delegate != nil) {
                viewController.delegate = _delegate
            }
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    //manager_token is member token
    func toManagerCourse(manager_token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-HrW-2D-NhE")  as? ManagerCourseVC {
                viewController.manager_token = manager_token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-HrW-2D-NhE") as! ManagerCourseVC
            viewController.manager_token = manager_token
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }

    func toManagerSignup(able_type: String, able_token: String, able_title: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            
            if let viewController = storyboard.instantiateViewController(identifier: "toManagerSignup")  as? ManagerSignupVC {
                viewController.able_type = able_type
                viewController.able_token = able_token
                viewController.able_title = able_title
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toManagerSignup") as! ManagerSignupVC
            viewController.able_type = able_type
            viewController.able_token = able_token
            viewController.able_title = able_title
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toManagerSignupList(able_type: String, able_token: String, able_title: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            
            if let viewController = storyboard.instantiateViewController(identifier: "toManagerSignupList")  as? ManagerSignupListVC {
                viewController.able_type = able_type
                viewController.able_token = able_token
                viewController.able_title = able_title
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toManagerCourseSignupList") as! ManagerSignupListVC
            viewController.able_type = able_type
            viewController.able_token = able_token
            viewController.able_title = able_title
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    //manager_token is member token
    func toManagerTeam(manager_token: String) {
        
        let v: ManagerTeamVC = ManagerTeamVC()
        v.manager_token = manager_token
        v.modalPresentationStyle = .fullScreen
        show(v, sender: nil)
        
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "Team", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: "toManagerTeam")  as? ManagerTeamVC {
//                viewController.manager_token = manager_token
//                viewController.modalPresentationStyle = .fullScreen
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toManagerTeam") as! ManagerTeamVC
//            viewController.manager_token = manager_token
//            viewController.modalPresentationStyle = .fullScreen
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
    }
    
//    func toManagerTeamSignup(able_type: String, able_token: String, able_title: String) {
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "Member", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: "toManagerTeamSignup")  as? ManagerTeamSignupVC {
//                viewController.able_type = able_type
//                viewController.able_token = able_token
//                viewController.able_title = able_title
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toManagerTeamSignup") as! ManagerTeamSignupVC
//            viewController.able_type = able_type
//            viewController.able_token = able_token
//            viewController.able_title = able_title
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
//    }
    
    func toMember() {
        
        let vc: MemberVC = MemberVC()
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "Member", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: "toMember") as? MemberVC {
//                viewController.modalPresentationStyle = .fullScreen
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toMember") as! MemberVC
//            viewController.modalPresentationStyle = .fullScreen
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
    }
    
    func toMemberBank() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_BANK) as? MemberBankVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_BANK) as! MemberBankVC
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberCartList(source: String = "order") {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_CART_LIST) as? MemberCartListVC {
                viewController.source = source
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_CART_LIST) as! MemberCartListVC
            viewController.source = source
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }

    func toMemberCoinList() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_COIN_LIST) as? MemberCoinListVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_COIN_LIST) as! MemberCoinListVC
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberItem(_ mainMemberEnum: MainMemberEnum) {
        let vc: MemberItemVC = MemberItemVC()
        vc.mainMemberEnum = mainMemberEnum
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)
    }
    
    func toMemberSubscriptionKind() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_SUPSCRIPTION_KIND) as? MemberSubscriptionKindVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_SUPSCRIPTION_KIND) as! MemberSubscriptionKindVC
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberSubscriptionLog() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_SUBSCRIPTION_LOG) as? MemberSubscriptionLogVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_SUBSCRIPTION_LOG) as! MemberSubscriptionLogVC
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberScriptionPay(name: String, price: Int, kind: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_SUBSCRIPTION_PAY) as? MemberSubscriptionPayVC {
                viewController.modalPresentationStyle = .fullScreen
                viewController.name = name
                viewController.kind = kind
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_SUBSCRIPTION_PAY) as! MemberSubscriptionPayVC
            viewController.modalPresentationStyle = .fullScreen
            viewController.name = name
            viewController.kind = kind
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberOrderList() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_ORDER_LIST)  as? MemberOrderListVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_ORDER_LIST) as! MemberOrderListVC
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberSignuplist(able_type: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_SIGNUPLIST)  as? MemberSignupListVC {
                viewController.able_type = able_type
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_SIGNUPLIST) as! MemberSignupListVC
            viewController.able_type = able_type
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberTeamList() {
        let vc = MemberTeamListVC()
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)
    }
    
    func toMore() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toMore") as? MoreVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toMore") as! MoreVC
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMultiSelect(key: String? = nil, _delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: IDEN_MULTI_SELECT) as? MultiSelectVC {
                if key != nil {
                    viewController.key = key
                }
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: IDEN_MULTI_SELECT) as! MultiSelectVC
            if key != nil {
                viewController.key = key
            }
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toLogin(memberVC: MemberVC? = nil) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "login") as? LoginVC {
                if (memberVC != nil) {
                    viewController.memberVC = memberVC
                }
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "login") as! LoginVC
            //viewController.delegate = self
            if (memberVC != nil) {
                viewController.memberVC = memberVC
            }
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toManagerTeamMember(token: String) {
        if #available(iOS 13.0, *) {
            
            let v: ManagerTeamMemberVC = ManagerTeamMemberVC()
            v.token = token
            v.modalPresentationStyle = .fullScreen
            show(v, sender: nil)
            
//            let storyboard = UIStoryboard(name: "Course", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_COURSE)  as? ShowCourseVC {
//                viewController.token = token
//                viewController.modalPresentationStyle = .fullScreen
//                show(viewController, sender: nil)
//            }
        } else {
            let v: ManagerTeamMemberVC = ManagerTeamMemberVC()
            v.token = token
            v.modalPresentationStyle = .fullScreen
            //let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_COURSE) as! ShowCourseVC
            //viewController.token = token
            self.navigationController!.pushViewController(v, animated: true)
        }
    }
    
    func toOrder(login: @escaping (_ baseViewController: BaseViewController)-> Void, register:  @escaping (_ baseViewController: BaseViewController)-> Void, product_token: String?=nil) {

        let msg: String = ""
        if !Member.instance.isLoggedIn {
            warning(msg: "必須先登入會員，才能進行購買", showCloseButton: true, buttonTitle: "登入") {
                self.goHomeThen(completion: login)
            }
        } else {
            for key in MEMBER_MUST_ARRAY {
//                let type: String = Member.instance.info[key]!["type"]!
//                let tmp = Member.instance.getData(key: key)
//                if type == "Int" {
//                    if let value: Int = tmp as? Int {
//                        if value == 0 {
//                            msg += MEMBER_MUST_ARRAY_WARNING[key]! + "\n"
//                        }
//                    }
//                } else if type == "String" {
//                    if let value = tmp as? String {
//                        if value.count == 0 {
//                            msg += MEMBER_MUST_ARRAY_WARNING[key]! + "\n"
//                        }
//                    }
//                }
            }
            if msg.count > 0 {
                warning(msg: msg, showCloseButton: true, buttonTitle: "填寫") {
                    self.goHomeThen(completion: register)
                }
            } else {
                if #available(iOS 13.0, *) {
                    let storyboard = UIStoryboard(name: "Member", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(identifier: TO_ORDER)  as? OrderVC {
                        if product_token != nil {
                            viewController.product_token = product_token
                        }
                        viewController.modalPresentationStyle = .fullScreen
                        show(viewController, sender: nil)
                    }
                } else {
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_ORDER) as! OrderVC
                    viewController.modalPresentationStyle = .fullScreen
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    // forget_password, change_password
    func toPassword(type: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "passwo") as? PasswordVC {
                viewController.type = type
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController =  self.storyboard!.instantiateViewController(withIdentifier: "passwo") as! PasswordVC
            viewController.type = type
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toPayment(order_token: String, ecpay_token: String?=nil, tokenExpireDate: String?=nil, source: String = "order") {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_PAYMENT)  as? PaymentVC {
                if ecpay_token != nil {
                    viewController.ecpay_token = ecpay_token!
                }
                
                viewController.order_token = order_token
                
                if tokenExpireDate != nil {
                    viewController.tokenExpireDate = tokenExpireDate!
                }
                
                viewController.source = source
                
                //viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_PAYMENT) as! PaymentVC
            if ecpay_token != nil {
                viewController.ecpay_token = ecpay_token!
            }
            viewController.order_token = order_token
            if tokenExpireDate != nil {
                viewController.tokenExpireDate = tokenExpireDate!
            }
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }

    func toProduct(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_PRODUCT) as? ProductVC {
                viewController.member_like = member_like
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_PRODUCT) as! ProductVC
            viewController.member_like = member_like
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toRegister() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_REGISTER) as? RegisterVC {
                //viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_REGISTER) as! RegisterVC
            //viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toRequestManagerTeam() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_REQUEST_MANAGER_TEAM) as? RequestManagerTeamVC {
                //viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_REGISTER) as! RequestManagerTeamVC
            //viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSearch() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "TempPlay", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toSearch") as? SearchVC {
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toSearch") as! SearchVC
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectArea(key: String? = nil, city_id: Int? = nil, selected: String? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_AREA) as? SelectAreaVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected
                }
                if city_id != nil {
                    viewController.city_id = city_id
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_AREA) as! SelectAreaVC
            if key != nil {
                viewController.key = key
                //viewController.city
            }
            if selected != nil {
                viewController.selected = selected
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectAreas(key: String? = nil, city_ids: [Int]? = nil, selecteds: [String]? = nil, _delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_AREAS) as? SelectAreasVC {
                if key != nil {
                    viewController.key = key
                }
                if selecteds != nil {
                    viewController.selecteds = selecteds!
                }
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_AREAS) as! SelectAreasVC
            if key != nil {
                viewController.key = key
            }
            if selecteds != nil {
                viewController.selecteds = selecteds!
            }
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectArena(key: String? = nil, city_id: Int, selected: String? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toSelectArena") as? SelectArenaVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected!
                }
                viewController.city = city_id
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toSelectArena") as! SelectArenaVC
            if key != nil {
                viewController.key = key
            }
            if selected != nil {
                viewController.selected = selected!
            }
            viewController.city = city_id
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectCity(key: String? = nil, selected: String? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_CITY) as? SelectCityVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_CITY) as! SelectCityVC
            if key != nil {
                viewController.key = key
            }
            if selected != nil {
                viewController.selected = selected
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectCitys(key: String? = nil, selecteds: [String]? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_CITYS) as? SelectCitysVC {
                if key != nil {
                    viewController.key = key
                }
                if selecteds != nil {
                    viewController.selecteds = selecteds!
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_CITYS) as! SelectCitysVC
            if key != nil {
                viewController.key = key
            }
            if selecteds != nil {
                viewController.selecteds = selecteds!
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectDate(key: String? = nil, selected: String? = nil) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-bUa-fD-2pO") as? DateSelectVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected!
                }
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-bUa-fD-2pO") as! DateSelectVC
            if key != nil {
                viewController.key = key
            }
            if selected != nil {
                viewController.selected = selected!
            }
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectDegree(selecteds: [DEGREE]? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Team", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-8Wp-Vh-56J") as? DegreeSelectVC {
                
                if selecteds != nil {
                    viewController.selecteds = selecteds!
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-8Wp-Vh-56J") as! DegreeSelectVC
            
            if selecteds != nil {
                viewController.selecteds = selecteds!
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectManager(manager_id: Int = 0, manager_token: String = "", delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_MANAGERS)  as? SelectManagerVC {
                
                viewController.key = MANAGERS_KEY
                //if selecteds != nil {
                viewController.manager_id = manager_id
                viewController.manager_token = manager_token
                //}
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_MANAGERS) as! SelectManagerVC
            viewController.key = MANAGERS_KEY
            //if selecteds != nil {
            viewController.manager_id = manager_id
            viewController.manager_token = manager_token
            //}
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectSingle(key: String?, selected: String?, delegate: BaseViewController, able_type: String?=nil) {
        
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toSelectSingle") as? SingleSelectVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toSelectSingle") as! SingleSelectVC
            if key != nil {
                viewController.key = key
            }
            if selected != nil {
                viewController.selected = selected
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    //input["type":PLAY_START,"time":time]
    func toSelectTime(key: String? = nil, selected: String? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toSelectTime") as? SelectTimeVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected!
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toSelectTime") as! SelectTimeVC
            if key != nil {
                viewController.key = key
            }
            if selected != nil {
                viewController.selected = selected!
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectWeekdays(key: String? = nil, selecteds: Int = 0, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-OKL-6q-hzR") as? WeekdaysSelectVC {
                if key != nil {
                    viewController.key = key
                }
                if selecteds > 0 {
                    viewController.selecteds = selecteds
                }
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-OKL-6q-hzR") as! WeekdaysSelectVC
            if key != nil {
                viewController.key = key
            }
            if selecteds > 0 {
                viewController.selecteds = selecteds
            }
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowArena(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_ARENA)  as? ShowArenaVC {
                viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_ARENA) as! ShowArenaVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowCoach(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_COACH)  as? ShowCoachVC {
                viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_COACH) as! ShowCoachVC
            viewController.token = token
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowCourse(token: String) {
        if #available(iOS 13.0, *) {
            
            let v: ShowCourseVC = ShowCourseVC()
            v.token = token
            v.modalPresentationStyle = .fullScreen
            show(v, sender: nil)
            
//            let storyboard = UIStoryboard(name: "Course", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_COURSE)  as? ShowCourseVC {
//                viewController.token = token
//                viewController.modalPresentationStyle = .fullScreen
//                show(viewController, sender: nil)
//            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_COURSE) as! ShowCourseVC
            //viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowPNVC() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_PN)  as? ShowPNVC {
                //viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_PN) as! ShowPNVC
            //viewController.token = token
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowStore(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_STORE)  as? ShowStoreVC {
                viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_STORE) as! ShowStoreVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowTeach(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_TEACH)  as? ShowTeachVC {
                viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_TEACH) as! ShowTeachVC
            //viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowTeam(token: String) {
        
        let v: ShowTeamVC = ShowTeamVC()
        v.token = token
        v.modalPresentationStyle = .fullScreen
        show(v, sender: nil)
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "Team", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_TEAM)  as? ShowTeamVC {
//                viewController.token = token
//                viewController.modalPresentationStyle = .fullScreen
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_TEAM) as! ShowTeamVC
//            viewController.token = token
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
    }

    func toShowProduct(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_PRODUCT)  as? ShowProductVC {
                viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_PRODUCT) as! ShowProductVC
            viewController.token = token
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSingleSelect(key: String? = nil, title: String? = nil, rows:[[String: String]] = [[String: String]](), selected: String? = nil, _delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: IDEN_SINGLE_SELECT) as? SingleSelectVC {
                if key != nil {
                    viewController.key = key
                }
                if title != nil {
                    viewController.title = title
                }
                if rows.count > 0 {
                    viewController.rows1 = rows
                }
                if selected != nil {
                    viewController.selected = selected
                }
                viewController.delegate = _delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: IDEN_SINGLE_SELECT) as! SingleSelectVC
            if key != nil {
                viewController.key = key
            }
            if title != nil {
                viewController.title = title
            }
            if rows.count > 0 {
                viewController.rows1 = rows
            }
            if selected != nil {
                viewController.selected = selected
            }
            viewController.delegate = _delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSignupList(able_type: String, able_token: String, isLast: Bool = false) {
        
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-yIz-IN-JqC") as? SignupListVC {
                viewController.able_type = able_type
                viewController.able_token = able_token
                //viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-yIz-IN-JqC") as! SignupListVC
            viewController.able_type = able_type
            viewController.able_token = able_token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toStore(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toStore") as? StoreVC {
                viewController.member_like = member_like
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toStore") as! StoreVC
            viewController.member_like = member_like
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    //目前還是使用ShowVC
//    func toShowTeach(token: String) {
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "More", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_TEACH)  as? ShowArenaVC {
//                viewController.token = token
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_ARENA) as! ShowArenaVC
//            viewController.token = token
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
//    }

    func toTeach(member_like: Bool=false, params: [String: String]?=nil) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-By4-ki-Kov") as? TeachVC {
                viewController.member_like = member_like
                if (params != nil) {
                    viewController.params = params!
                }
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-By4-ki-Kov") as! TeachVC
            viewController.member_like = member_like
            if (params != nil) {
                viewController.params = params!
            }
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toTeam(member_like: Bool=false, params: [String: String]?=nil) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Team", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "Team") as? TeamVC {
                viewController.member_like = member_like
                if (params != nil) {
                    viewController.params = params!
                }
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Team") as! TeamVC
            viewController.member_like = member_like
            if (params != nil) {
                viewController.params = params!
            }
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toValidate(type: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-XsO-Wn-cpI") as? ValidateVC {
                viewController.type = type
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController =  self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-XsO-Wn-cpI") as! ValidateVC
            viewController.type = type
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toWebView(token: String? = nil, delegate: BaseViewController? = nil) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_WEBVIEW) as? WebViewVC {
                viewController.token = token
                viewController.delegate = delegate
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_WEBVIEW) as! WebViewVC
            viewController.token = token
            viewController.delegate = delegate
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toYoutubePlayer(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_YOUTUBE_PLAYER)  as? YoutubePlayerVC {
                viewController.token = token
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_YOUTUBE_PLAYER) as! YoutubePlayerVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
}


