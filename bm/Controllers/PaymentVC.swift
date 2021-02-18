//
//  PaymentVC.swift
//  bm
//
//  Created by ives on 2021/2/5.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import ECPayPaymentGatewayKit

class PaymentVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    
    var ecpay_token: String = ""
    var order_token: String = ""
    var tokenExpireDate: String = ""
    var superOrder: SuperOrder? = nil
        
    override func viewDidLoad() {
        myTablView = tableView
        sections = ["商品", "訂單", "付款", "訂購人"]
        rows = [
            [["name":"商品名稱", "value":"value"],["name":"商品屬性", "value":"attributes"]],
            [["name":"訂單編號", "value":"no"],["name":"商品金額", "value":"amount"],["name":"商品數量", "value":"quantity"],["name":"運費", "value":"shipping_fee"]],
            [["name":"訂單總金額", "value":"amount"],["name":"訂單建立時間", "value":"create_at"],["name":"付款方式", "value":"gateway"],["name":"到貨方式", "value":"method"]],
            [["name":"訂購人姓名", "value":"order_name"], ["name":"訂購人電話", "value":"order_tel"], ["name":"訂購人EMail", "value":"order_email"], ["name":"訂購人住址", "value":"order_address"]]
        ]
        super.viewDidLoad()
        titleLbl.textColor = UIColor.black
        
        refresh()
        
        //let name: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)!
        
//        if ecpay_token.count > 0 {
//            //
//            ECPayPaymentGatewayManager.sharedInstance().createPayment(
//                token: ecpay_token,
//                useResultPage: 1,
//                appStoreName: name,
//                language: "zh-TW") { (state) in
//                if let creditPayment: CreatePaymentCallbackState = state as? CreatePaymentCallbackState {
//                    if let order = creditPayment.OrderInfo {
//                        print(order)
//                    }
//                    if let card = creditPayment.CardInfo {
//                        print(card)
//                    }
//                }
//
//                switch state.callbackStateStatus {
//                case .Success:
//                    print("Success")
//
//                case .Fail:
//                    print("Faile")
//
//                case .Cancel:
//                    print("Cancel")
//
//                case .Unknown:
//                    print("Unknown")
//                }
//            }
//        }
    }
    
    override func refresh() {
        if order_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": order_token, "member_token": Member.instance.token]
            OrderService.instance.getOne(t: SuperOrder.self, params: params) { (success) in
                if (success) {
                    let superModel: SuperModel = OrderService.instance.superModel
                    self.superOrder = (superModel as! SuperOrder)
                    self.superOrder!.printRow()
                    
                    self.titleLbl.text = self.superOrder?.product.name
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        let field: String = row["name"] as! String
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = field
        return cell
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        //print("purchase")
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //goHome()
        prev()
    }
}
