//
//  File.swift
//  bm
//
//  Created by ives on 2021/6/14.
//  Copyright © 2021 bm. All rights reserved.
//

extension BaseViewController {
    
    func toArena(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toArena") as? ArenaVC {
                viewController.member_like = member_like
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toArena") as! ArenaVC
            viewController.member_like = member_like
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toCoach(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-fEf-Ib-3oR") as? CoachVC {
                viewController.member_like = member_like
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-fEf-Ib-3oR") as! CoachVC
            viewController.member_like = member_like
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toCourse(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "Course") as? CourseVC {
                viewController.member_like = member_like
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Course") as! CourseVC
            viewController.member_like = member_like
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toEditContent(key: String, title: String, content: String?, _delegate: BaseViewController?) {
        
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-Rnr-RQ-nbw") as? ContentEditVC {
                viewController.key = key
                
                if (content != nil) {
                    viewController.content = content
                }
                
                if (_delegate != nil) {
                    viewController.delegate = _delegate
                }
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-Rnr-RQ-nbw") as! ContentEditVC
            viewController.key = key
            
            if (content != nil) {
                viewController.content = content
            }
            
            if (_delegate != nil) {
                viewController.delegate = _delegate
            }
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toEditCourse(token: String) {
        
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "editCourse") as? EditCourseVC {
                viewController.course_token = token
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "editCourse") as! EditCourseVC
            viewController.course_token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    //manager_token is member token
    func toManagerCourse(manager_token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-HrW-2D-NhE")  as? ManagerCourseVC {
                viewController.manager_token = manager_token
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-HrW-2D-NhE") as! ManagerCourseVC
            viewController.manager_token = manager_token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toMemberOrderList() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_MEMBER_ORDER_LIST)  as? MemberOrderListVC {
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_MEMBER_ORDER_LIST) as! MemberOrderListVC
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
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: IDEN_MULTI_SELECT) as! MultiSelectVC
            if key != nil {
                viewController.key = key
            }
            viewController.delegate = self
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toLogin() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Member", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "login") as? LoginVC {
                //viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "login") as! LoginVC
            //viewController.delegate = self
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toOrder(product_token: String, login: @escaping (_ baseViewController: BaseViewController)-> Void, register:  @escaping (_ baseViewController: BaseViewController)-> Void) {
        
        var msg: String = ""
        if !Member.instance.isLoggedIn {
            warning(msg: "必須先登入會員，才能進行購買", showCloseButton: true, buttonTitle: "登入") {
                self.goHomeThen(completion: login)
            }
        } else {
            for key in MEMBER_MUST_ARRAY {
                let type: String = Member.instance.info[key]!["type"]!
                let tmp = Member.instance.getData(key: key)
                if type == "Int" {
                    if let value: Int = tmp as? Int {
                        if value == 0 {
                            msg += MEMBER_MUST_ARRAY_WARNING[key]! + "\n"
                        }
                    }
                } else if type == "String" {
                    if let value = tmp as? String {
                        if value.count == 0 {
                            msg += MEMBER_MUST_ARRAY_WARNING[key]! + "\n"
                        }
                    }
                }
            }
            if msg.count > 0 {
                warning(msg: msg, showCloseButton: true, buttonTitle: "填寫") {
                    self.goHomeThen(completion: register)
                }
            } else {
                if #available(iOS 13.0, *) {
                    let storyboard = UIStoryboard(name: "More", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(identifier: TO_ORDER)  as? OrderVC {
                        viewController.product_token = product_token
                        show(viewController, sender: nil)
                    }
                } else {
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_ORDER) as! OrderVC
                    viewController.product_token = product_token
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func toPayment(order_token: String, ecpay_token: String?=nil, tokenExpireDate: String?=nil) {
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
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_PRODUCT) as! ProductVC
            viewController.member_like = member_like
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
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectArena(key: String? = nil, city: Int, selected: String? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toSelectArena") as? SelectArenaVC {
                if key != nil {
                    viewController.key = key
                }
                if selected != nil {
                    viewController.selected = selected!
                }
                viewController.city = city
                viewController.delegate = delegate
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
            viewController.city = city
            viewController.delegate = delegate
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
//    func toSelectCity(key: String? = nil, selected: String? = nil, delegate: BaseViewController) {
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: "Select", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_CITY) as? SelectCityVC {
//                if key != nil {
//                    viewController.key = key
//                }
//                if selected != nil {
//                    viewController.selected = selected
//                }
//                viewController.delegate = delegate
//                show(viewController, sender: nil)
//            }
//        } else {
//            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_CITY) as! SelectCityVC
//            if key != nil {
//                viewController.key = key
//            }
//            if selected != nil {
//                viewController.selected = selected
//            }
//            viewController.delegate = delegate
//            self.navigationController!.pushViewController(viewController, animated: true)
//        }
//    }
    
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
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-8Wp-Vh-56J") as! DegreeSelectVC
            
            if selecteds != nil {
                viewController.selecteds = selecteds!
            }
            viewController.delegate = delegate
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectManagers(selecteds: [String]? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Select", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SELECT_MANAGERS)  as? SelectManagersVC {
                
                viewController.key = MANAGERS_KEY
                if selecteds != nil {
                    viewController.selecteds = selecteds!
                }
                viewController.delegate = delegate
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SELECT_MANAGERS) as! SelectManagersVC
            viewController.key = MANAGERS_KEY
            if selecteds != nil {
                viewController.selecteds = selecteds!
            }
            viewController.delegate = delegate
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
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toSelectWeekday(key: String? = nil, selecteds: [Int]? = nil, delegate: BaseViewController) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-OKL-6q-hzR") as? WeekdaysSelectVC {
                if key != nil {
                    viewController.key = key
                }
                if selecteds != nil {
                    viewController.selecteds = selecteds!
                }
                viewController.delegate = delegate
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-OKL-6q-hzR") as! WeekdaysSelectVC
            if key != nil {
                viewController.key = key
            }
            if selecteds != nil {
                viewController.selecteds = selecteds!
            }
            viewController.delegate = delegate
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowArena(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_ARENA)  as? ShowArenaVC {
                viewController.token = token
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
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_COACH) as! ShowCoachVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowCourse(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_COURSE)  as? ShowCourseVC {
                viewController.token = token
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_COURSE) as! ShowCourseVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowStore(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_STORE)  as? ShowStoreVC {
                viewController.token = token
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
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_TEACH) as! ShowTeachVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toShowTeam(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Team", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_TEAM)  as? ShowTeamVC {
                viewController.token = token
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_TEAM) as! ShowTeamVC
            viewController.token = token
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }

    func toShowProduct(token: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_PRODUCT)  as? ShowProductVC {
                viewController.token = token
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_PRODUCT) as! ShowProductVC
            viewController.token = token
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
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func toStore(member_like: Bool=false) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "More", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "toStore") as? StoreVC {
                viewController.member_like = member_like
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "toStore") as! StoreVC
            viewController.member_like = member_like
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

    func toTeam(member_like: Bool=false, params: [String: Any]?=nil) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Team", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "Team") as? TeamVC {
                viewController.member_like = member_like
                if (params != nil) {
                    viewController.params = params!
                }
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
}


