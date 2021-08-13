//
//  PaymentVC.swift
//  bm
//
//  Created by ives on 2021/2/5.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import ECPayPaymentGatewayKit
import SwiftyJSON

class PaymentVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    
    var ecpay_token: String = ""
    var order_token: String = ""
    var tokenExpireDate: String = ""
    var orderTable: OrderTable? = nil
    
    let heightForSection: CGFloat = 34
    
    var productRows: [[String: String]] = []
    
    var orderRows: [[String: String]] = [
        ["title":"訂單編號", "key":ORDER_NO_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"商品金額", "key":AMOUNT_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"運費", "key":SHIPPING_FEE_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"稅", "key":TAX_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"訂單金額", "key":TOTAL_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"訂單建立時間", "key":CREATED_AT_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"訂單狀態", "key":ORDER_PROCESS_KEY, "value":"", "show":"", "cell":"text"]
    ]
    
    var gatewayRows: [[String: String]] = [
        ["title":"付款方式", "key":GATEWAY_METHOD_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"付款狀態", "key":GATEWAY_PROCESS_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"付款時間", "key":GATEWAY_AT_KEY, "value":"", "show":"", "cell":"text"]
    ]
    
    var shippingRows: [[String: String]] = [
        ["title":"到貨方式", "key":SHIPPING_METHOD_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"到貨狀態", "key":SHIPPING_PROCESS_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"出貨時間", "key":SHIPPING_AT_KEY, "value":"", "show":"", "cell":"text"]
    ]
    
    var invoiceRows: [[String: String]] = [
        ["title":"發票種類", "key":INVOICE_TYPE_KEY, "value":"", "show":"", "cell":"text"],
        ["title":"寄送EMail", "key":INVOICE_EMAIL_KEY, "value":"", "show":"", "cell":"text"]
    ]
    
    var memberRows: [[String: String]] = [
        ["title":"姓名","key":NAME_KEY,"value":"","show":"","cell":"text"],
        ["title":"電話","key":MOBILE_KEY,"value":"","show":"","cell":"text"],
        ["title":"EMail","key":EMAIL_KEY,"value":"","show":"","cell":"text"],
        ["title":"住址","key":ADDRESS_KEY,"value":"","show":"","cell":"text"]
    ]
    
    let memoRows: [[String: String]] = [
        ["title": "留言","key":MEMO_KEY,"value":"","show":"","cell":"text"]
    ]
    
    var gateway: GATEWAY = GATEWAY.credit_card
    var payment_no: String = ""
    var expire_at: String = ""
    var payment_url: String = ""
    var barcode1: String = ""
    var barcode2: String = ""
    var barcode3: String = ""
    var bank_code: String = ""
    var bank_account: String = ""
    
    override func viewDidLoad() {
        myTablView = tableView

        super.viewDidLoad()
        
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
        
        let cartListNib = UINib(nibName: "CartListCell", bundle: nil)
        tableView.register(cartListNib, forCellReuseIdentifier: "CartListCell")
        
        //refresh()
        
        if ecpay_token.count > 0 {

            let name: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)!

            ECPayPaymentGatewayManager.sharedInstance().createPayment(
                token: ecpay_token,
                useResultPage: 1,
                appStoreName: name,
                language: "zh-TW") { (state) in
                
                if let creditPayment: CreatePaymentCallbackState = state as? CreatePaymentCallbackState {
//                    if let order = creditPayment.OrderInfo {
//                        //print(order)
//                    }
//
//                    if let card = creditPayment.CardInfo {
//                        //print(card)
//                    }
                    
                    if let cvs = creditPayment.CVSInfo {
                        self.payment_no = cvs.PaymentNo!
                        self.expire_at = cvs.ExpireDate!.toString(format: "yyyy-MM-dd HH:mm:ss")
                        self.payment_url = cvs.PaymentURL!
                        self.gateway = GATEWAY.store_cvs
                    }
                    
                    if let barcode = creditPayment.BarcodeInfo {
                        self.barcode1 = barcode.Barcode1!
                        self.barcode2 = barcode.Barcode2!
                        self.barcode3 = barcode.Barcode3!
                        self.expire_at = barcode.ExpireDate!.toString(format: "yyyy-MM-dd HH:mm:ss")
                        self.gateway = GATEWAY.store_barcode
                    }
                    
                    if let ATM = creditPayment.ATMInfo {
                        self.bank_code = ATM.BankCode!
                        self.bank_account = ATM.vAccount!
                        self.expire_at = ATM.ExpireDate!.toString(format: "yyyy-MM-dd HH:mm:ss")
                    }
                }

                switch state.callbackStateStatus {
                case .Success:
                    //print("Success")
                    if (self.gateway == GATEWAY.credit_card) {
                        self.refresh()
                    } else {
                        self.updateOrder()
                    }

                case .Fail:
                    //print("Faile")
                    self.warning(state.callbackStateMessage)

                case .Cancel:
                    //print("Cancel")
                    self.warning("您已經取消付款")

                case .Unknown:
                    //print("Unknown")
                    self.warning("由於不知名的錯誤，造成付款失敗，請麻煩聯絡管理員")
                }
            }
        } else {
            refresh()
        }
    }
    
    override func refresh() {
        if order_token.count > 0 {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": order_token, "member_token": Member.instance.token]
            OrderService.instance.getOne(params: params) { (success) in
                if (success) {
                    
                    let jsonData: Data = OrderService.instance.jsonData!
                    do {
                        self.orderTable = try JSONDecoder().decode(OrderTable.self, from: jsonData)
                        self.initData()
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func updateOrder() {
        
        var params: [String: String] = ["token": order_token, "member_token": Member.instance.token]
        params["expire_at"] = expire_at
        if (gateway == GATEWAY.store_cvs) {
            params["payment_no"] = payment_no
            params["payment_url"] = payment_url
        } else if (gateway == GATEWAY.store_barcode) {
            params["barcode1"] = barcode1
            params["barcode2"] = barcode2
            params["barcode3"] = barcode3
        } else if (gateway == GATEWAY.ATM) {
            params["bank_code"] = bank_code
            params["bank_account"] = bank_account
        }
        
        OrderService.instance.update(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                self.refresh()
                //self.jsonData = OrderService.instance.jsonData
            } else {
                self.warning(OrderService.instance.msg)
            }
        }
    }
    
    func initData() {
        
        titleLbl.text = orderTable!.order_no
        titleLbl.textColor = UIColor.black
        
        mySections = [
            ["name": "商品", "isExpanded": true, "key": PRODUCT_KEY],
            ["name": "訂單", "isExpanded": true, "key": ORDER_KEY],
            ["name": "付款方式", "isExpanded": true, "key": GATEWAY_KEY],
            ["name": "寄送方式", "isExpanded": true, "key": SHIPPING_KEY],
            ["name": "電子發票", "isExpanded": true, "key": INVOICE_KEY],
            ["name": "訂購人資料", "isExpanded": true, "key": MEMBER_KEY],
            ["name": "其他留言", "isExpanded": true, "key": MEMO_KEY]
        ]
        
        orderTable!.filterRow()
        let orderItemsTable = orderTable!.items
        for orderItemTable in orderItemsTable {
            
            orderItemTable.filterRow()
            let productTable = orderItemTable.product
            
            var attribute_text: String = ""
            if (orderItemTable.attributes.count > 0) {

                for (idx, attribute) in orderItemTable.attributes.enumerated() {
                    attribute_text += attribute["name"]! + ":" + attribute["value"]!
                    if (idx < orderItemTable.attributes.count - 1) {
                        attribute_text += " | "
                    }
                }
            }
            
            let row:[String: String] = ["title":productTable!.name,"key":PRODUCT_KEY,"value":"","show":"","cell":"cart","featured_path":productTable!.featured_path,"attribute":attribute_text,"amount":orderItemTable.amount_show,"quantity":String(orderItemTable.quantity)]
            productRows.append(row)
        }
        
        myRows = [
            ["key":PRODUCT_KEY, "rows": productRows],
            ["key":ORDER_KEY, "rows": orderRows],
            ["key":GATEWAY_KEY, "rows": gatewayRows],
            ["key":SHIPPING_KEY, "rows": shippingRows],
            ["key":INVOICE_KEY, "rows": invoiceRows],
            ["key":MEMBER_KEY, "rows": memberRows],
            ["key":MEMO_KEY, "rows": memoRows]
        ]
        
        //order
        var row: [String: String] = getRowRowsFromMyRowsByKey1(key: ORDER_NO_KEY)
        row["value"] = orderTable!.order_no
        row["show"] = orderTable!.order_no
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: ORDER_NO_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: AMOUNT_KEY)
        row["value"] = String(orderTable!.amount)
        row["show"] = orderTable!.amount_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: AMOUNT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_FEE_KEY)
        row["value"] = String(orderTable!.shipping_fee)
        row["show"] = orderTable!.shipping_fee_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: SHIPPING_FEE_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: TAX_KEY)
        row["value"] = String(orderTable!.tax)
        row["show"] = orderTable!.tax_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: TAX_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: TOTAL_KEY)
        row["value"] = String(orderTable!.total)
        row["show"] = orderTable!.total_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: TOTAL_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: CREATED_AT_KEY)
        row["value"] = orderTable!.created_at
        row["show"] = orderTable!.created_at_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: CREATED_AT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: ORDER_PROCESS_KEY)
        row["value"] = orderTable!.process
        row["show"] = orderTable!.order_process_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: ORDER_PROCESS_KEY, _row: row)
        
        //gateway
        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_METHOD_KEY)
        row["value"] = orderTable!.gateway!.method
        row["show"] = orderTable!.gateway!.method_show
        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_METHOD_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_AT_KEY)
        row["value"] = orderTable!.gateway?.gateway_at
        row["show"] = orderTable!.gateway?.gateway_at_show
        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_AT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_PROCESS_KEY)
        row["value"] = orderTable!.gateway!.process
        row["show"] = orderTable!.gateway!.process_show
        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_PROCESS_KEY, _row: row)
        
        //shipping
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_METHOD_KEY)
        row["value"] = orderTable!.shipping!.method
        row["show"] = orderTable!.shipping!.method_show
        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_METHOD_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_METHOD_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_AT_KEY)
        row["value"] = orderTable!.shipping?.shipping_at
        row["show"] = orderTable!.shipping?.shipping_at_show
        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_AT_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_AT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_PROCESS_KEY)
        row["value"] = orderTable!.shipping!.process
        row["show"] = orderTable!.shipping!.process_show
        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_PROCESS_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_PROCESS_KEY, _row: row)
        
        if (orderTable!.shipping?.method == "store_711" || orderTable!.shipping?.method == "store_family") {
            row = ["title":"到達商店時間", "key":SHIPPING_STORE_AT_KEY, "value":orderTable!.shipping!.store_at, "show":orderTable!.shipping!.store_at_show, "cell":"text"]
            shippingRows.append(row)
        }
        
        row = ["title":"到貨時間", "key":SHIPPING_COMPLETE_AT_KEY, "value":orderTable!.shipping!.complete_at, "show":orderTable!.shipping!.complete_at_show, "cell":"text"]
        shippingRows.append(row)
        
        if (orderTable!.shipping!.back_at.count > 0) {
            row = ["title":"退貨時間", "key":SHIPPING_BACK_AT_KEY, "value":orderTable!.shipping!.back_at, "show":orderTable!.shipping!.back_at_show, "cell":"text"]
            shippingRows.append(row)
        }
        replaceRowsByKey(sectionKey: SHIPPING_KEY, rows: shippingRows)
        
        //invoice
        let invoice_type: String = orderTable!.invoice_type
        row = getRowFromKey(rows: invoiceRows, key: INVOICE_TYPE_KEY)
        row["value"] = invoice_type
        row["show"] = orderTable!.invoice_type_show
        invoiceRows = replaceRowByKey(rows: invoiceRows, key: INVOICE_TYPE_KEY, newRow: row)
        
        if (invoice_type == "company") {
            row = ["title":"公司或行號名稱", "key":INVOICE_COMPANY_NAME_KEY, "value":orderTable!.invoice_company_name, "show":orderTable!.invoice_company_name, "cell":"text"]
            invoiceRows.append(row)
            row = ["title":"統一編號", "key":INVOICE_COMPANY_TAX_KEY, "value":orderTable!.invoice_company_tax, "show":orderTable!.invoice_company_tax, "cell":"text"]
            invoiceRows.append(row)
        }
        
        row = getRowFromKey(rows: invoiceRows, key: INVOICE_EMAIL_KEY)
        row["value"] = orderTable!.invoice_email
        row["show"] = orderTable!.invoice_email
        invoiceRows = replaceRowByKey(rows: invoiceRows, key: INVOICE_EMAIL_KEY, newRow: row)
        
        replaceRowsByKey(sectionKey: INVOICE_KEY, rows: invoiceRows)
        //myRows[4]["rows"] = invoiceRows
        
        //member
        row = getRowRowsFromMyRowsByKey1(key: NAME_KEY)
        row["value"] = orderTable!.order_name
        row["show"] = orderTable!.order_name
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: NAME_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: MOBILE_KEY)
        row["value"] = orderTable!.order_tel
        row["show"] = orderTable!.order_tel_show
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: MOBILE_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: EMAIL_KEY)
        row["value"] = orderTable!.order_email
        row["show"] = orderTable!.order_email
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: EMAIL_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: ADDRESS_KEY)
        row["value"] = orderTable!.order_address
        row["show"] = orderTable!.order_address
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: ADDRESS_KEY, _row: row)
        
        //memo
        row = getRowRowsFromMyRowsByKey1(key: MEMO_KEY)
        row["value"] = orderTable!.memo
        row["show"] = orderTable!.memo
        replaceRowByKey(sectionKey: MEMO_KEY, rowKey: MEMO_KEY, _row: row)
        
        
        tableView.reloadData()
    }
    
//    private func setupOrderData() {
//        
//        if orderTable != nil {
//            
//            let mirror: Mirror = Mirror(reflecting: orderTable!)
//            let propertys: [[String: Any]] = mirror.toDictionary()
//            
//            for property in propertys {
//                let label: String = property["label"] as! String
//                for (idx, row) in rows!.enumerated() {
//                    for (idx1, row1) in row.enumerated() {
//                        let key: String = row1["key"] as! String
//                        if key == label {
//                            var type: String = property["type"] as! String
//                            type = type.getTypeOfProperty()!
//                            //print("label=>\(property["label"]):value=>\(property["value"]):type=>\(type)")
//                            if type == "Int" {
//                                rows![idx][idx1]["value"] = String(property["value"] as! Int)
//                            } else if type == "Bool" {
//                                rows![idx][idx1]["value"] = String(property["value"] as! Bool)
//                            } else if type == "String" {
//                                rows![idx][idx1]["value"] = property["value"] as! String
//                            }
//                        }
//                    }
//                }
//                
//            }
//            //print(rows)
//        }
//    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return mySections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        let mySection: [String: Any] = mySections[section]
        if (mySection.keyExist(key: "isExpanded")) {
            let isExpanded: Bool = mySection["isExpanded"] as? Bool ?? true
            if (isExpanded) {
                if let key: String = mySection["key"] as? String {
                    let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
                    count = rows.count
                }
            }
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = getSectionName(idx: section)
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
        headerView.addSubview(titleLabel)
        
        let isExpanded = getSectionExpanded(idx: section)
        let mark = UIImageView(image: UIImage(named: "to_right"))
        mark.frame = CGRect(x: view.frame.width-10-20, y: (heightForSection-20)/2, width: 20, height: 20)
        toggleMark(mark: mark, isExpanded: isExpanded)
        headerView.addSubview(mark)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
        headerView.addGestureRecognizer(gesture)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var rowKey: String = ""
        let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
        if let tmp: String = row["key"] {
            rowKey = tmp
        }
        
        var sectionKey: String = ""
        let section: [String: Any] = myRows[indexPath.section]
        if let tmp: String = section["key"] as? String {
            sectionKey = tmp
        }
        
        var cell_type: String = "text"
        if (row.keyExist(key: "cell")) {
            cell_type = row["cell"]!
        }
        
        var title: String = ""
        var show: String = ""
        //var value: String = ""
        
        if row.keyExist(key: "title") {
            title = row["title"]!
        }
        
        if row.keyExist(key: "show") {
            show = row["show"]!
        }
        
//        if row.keyExist(key: "value") {
//            value = row["value"]!
//        }
        if (cell_type == "cart") {
            if let cell: CartListCell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {
                
                cell.update(sectionKey: sectionKey,rowKey: rowKey,title: title,featured_path:row["featured_path"]!,attribute:row["attribute"]!,amount: row["amount"]!,quantity: row["quantity"]!)
                return cell
            }
        } else if (cell_type == "text") {
            if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                
                cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, show: show)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
