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
            [
                ["name":"商品名稱", "value":"", "key":"product_name"],
                ["name":"商品屬性", "value":"", "key":"product_attributes"]],
            [
                ["name":"訂單編號", "value":"", "key":"order_no"],
                ["name":"商品數量", "value":"", "key":"quantity"],
                ["name":"商品金額", "value":"product_price", "key":"amount"],
                ["name":"運費", "value":"shipping_fee", "key":"shipping_fee"],
                ["name":"訂單總金額", "value":"", "key":"amount"],
                ["name":"訂單建立時間", "value":"", "key":"created_at"],
                ["name":"訂單狀態", "value":"", "key":"process"]
            ],
            [
                ["name":"付款方式", "value":"", "key":"gateway_ch"],
                ["name":"到貨方式", "value":"method", "key":"method_ch"],
                ["name":"付款時間", "value":"", "key":"payment_at"]
            ],
            [
                ["name":"訂購人姓名", "value":"", "key":"order_name"],
                ["name":"訂購人電話", "value":"", "key":"order_tel"],
                ["name":"訂購人EMail", "value":"", "key":"order_email"], ["name":"訂購人住址", "value":"", "key":"order_address"]
            ]
        ]
        super.viewDidLoad()
        titleLbl.textColor = UIColor.black
        
        let cellNibName = UINib(nibName: "PaymentCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "PaymentCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
        
        //let name: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)!
        
//        if ecpay_token.count > 0 {
//            //
//            ECPayPaymentGatewayManager.sharedInstance().createPayment(
//                token: ecpay_token,
//                useResultPage: 1,
//                appStoreName: name,
//                language: "zh-TW") { (state) in
////                if let creditPayment: CreatePaymentCallbackState = state as? CreatePaymentCallbackState {
////                    if let order = creditPayment.OrderInfo {
////                        print(order)
////                    }
////                    if let card = creditPayment.CardInfo {
////                        print(card)
////                    }
////                }
//
//                switch state.callbackStateStatus {
//                case .Success:
//                    //print("Success")
//                    self.refresh()
//
//                case .Fail:
//                    //print("Faile")
//                    self.warning("付款失敗，請麻煩聯絡管理員")
//
//                case .Cancel:
//                    //print("Cancel")
//                    self.warning("您已經取消付款")
//
//                case .Unknown:
//                    //print("Unknown")
//                    self.warning("由於不知名的錯誤，造成付款失敗，請麻煩聯絡管理員")
//                }
//            }
//        }
    }
    
    override func refresh() {
        if order_token.count > 0 {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": order_token, "member_token": Member.instance.token]
            OrderService.instance.getOne(t: SuperOrder.self, params: params) { (success) in
                if (success) {
                    let superModel: SuperModel = OrderService.instance.superModel
                    self.superOrder = (superModel as! SuperOrder)
                    self.superOrder!.printRow()
                    
                    self.titleLbl.text = self.superOrder?.product.name
                    
                    self.setupOrderData()
                    self.tableView.reloadData()
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    private func setupOrderData() {
        
        if superOrder != nil {
            let mirror: Mirror = Mirror(reflecting: superOrder!)
            for property in mirror.children {
                let label = property.label
                for (idx, row) in rows!.enumerated() {
                    for (idx1, row1) in row.enumerated() {
                        let key: String = row1["key"] as! String
                        if key == label {
                            let type1 = getClassType(value: property.value)
                            if type1.contains("String") {
                                rows![idx][idx1]["value"] = property.value as! String
                            } else if type1.contains("Int") {
                                let tmp: Int = property.value as! Int
                                rows![idx][idx1]["value"] = String(tmp)
                            }
                        }
                    }
                }
            }
            var attributes: [String] = [String]()
            var unit: String = "件"
            if superOrder!.product_type == "clothes" {
                for item in superOrder!.order_clothes {
                    let color: String = item.color
                    let size: String = item.size
                    unit = item.unit
                    let quantity: String = String(item.quantity) + unit
                    let price: String = String(item.price)
                    let attribute =
                        "顏色：" + color + "," +
                        "尺寸：" + size + "," +
                        "數量：" + quantity + "," +
                        "價格：" + price
                    attributes.append(attribute)
                }
            } else if superOrder!.product_type == "racket" {
                for item in superOrder!.order_racket {
                    let color: String = item.color
                    let weight: String = item.weight
                    unit = item.unit
                    let quantity: String = String(item.quantity) + unit
                    let price: String = String(item.price)
                    let attribute =
                        "顏色：" + color + "," +
                        "重量：" + weight + "," +
                        "數量：" + quantity + "," +
                        "價格：" + price
                    attributes.append(attribute)
                }
            } else if superOrder!.product_type == "mejump" {
                for item in superOrder!.order_mejump {
                    let title: String = item.title
                    unit = item.unit
                    let quantity: String = String(item.quantity) + unit
                    let price: String = String(item.price)
                    let attribute =
                        "種類：" + title + "," +
                        "數量：" + quantity + "," +
                        "價格：" + price
                    attributes.append(attribute)
                }
            }
            rows![0][1]["value"] = attributes.joined(separator: "\n")
            rows![0][0]["value"] = superOrder!.product.name
            rows![3][3]["value"] = superOrder!.order_city+superOrder!.order_area+superOrder!.order_road
            rows![1][1]["value"] = (rows![1][1]["value"] as! String) + unit
            
            var tmp: String = rows![1][2]["value"] as! String
            if tmp.count > 0 {
                rows![1][2]["value"] = thousandNumber(tmp)
            }
            tmp = rows![1][3]["value"] as! String
            if tmp.count > 0 {
                rows![1][3]["value"] = thousandNumber(tmp)
            }
            tmp = rows![1][4]["value"] as! String
            if tmp.count > 0 {
                rows![1][4]["value"] = thousandNumber(tmp)
            }
            
            tmp = rows![1][5]["value"] as! String
            if tmp.count > 0 {
                rows![1][5]["value"] = tmp.noSec()
            }
            //print(rows)
        }
    }
    
    private func thousandNumber(_ tmp: String) -> String {
        let m: Int = Int(tmp) ?? 0
        let tmp = m.formattedWithSeparator
        let price: String = "NT$ \(tmp)"
        
        return price
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as? PaymentCell {
            cell.update(row: row)
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            
            let field: String = (row["name"] as! String) + ":" + (row["value"] as! String)
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = field
            return cell
        }
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
    
    private func getClassType(value: Any) -> String {
        var dynamicType = String(reflecting: type(of: value))
        dynamicType = dynamicType.replacingOccurrences(of: "Swift.", with: "")
        
        return dynamicType
    }
}
