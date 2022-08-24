//
//  MemberLevelUpPayVC.swift
//  bm
//
//  Created by ives on 2022/8/14.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberLevelUpPayVC: BaseViewController {
    
    @IBOutlet weak var prizeLbl: SuperLabel!
    
    var name: String = ""
    var price: Int = 0
    var kind: String = "steal"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.delegate = self
        
        //tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        bottomThreeView.delegate = self
        setupBottomThreeView()
        
        let kind_enum: MEMBER_LEVEL = MEMBER_LEVEL.stringToEnum(kind)
        let kind_chinese: String = kind_enum.rawValue
        
        top.setTitle(title: kind_chinese + "會員付款")
        
        //let lottery_eng: Int = kind_enum.lottery()
        //let lottery_chineds: String = lottery_eng.numberToChinese()
        
        var prize: String = kind_chinese + "福利\n"
        prize += kind_chinese + "福利有 " + kind_enum.lottery().numberToChinese() + "張 抽獎券，每月系統會舉行抽獎，抽獎券越多，越容易中獎\n"
        
        prizeLbl.setLineHeight(lineHeight: 10)
        prizeLbl.text = prize
        
        //prizeLbl.setSpecialTextColor(fullText: prize, changeText: "三張", color: UIColor(MY_RED))
        prizeLbl.setSpecialTextColorAndBold(fullText: prize, changeText: "三張", color: UIColor(MY_RED), ofSize: 36)

        
        refresh()
    }
    
    override func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("訂閱")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退訂")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
    
    override func submitBtnPressed() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscription(kind: kind) { Success in
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
