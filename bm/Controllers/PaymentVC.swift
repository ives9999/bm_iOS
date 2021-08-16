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
        [TITLE_KEY:"訂單編號", KEY_KEY:ORDER_NO_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"商品金額", KEY_KEY:AMOUNT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"運費", KEY_KEY:SHIPPING_FEE_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"稅", KEY_KEY:TAX_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"訂單金額", KEY_KEY:TOTAL_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"訂單建立時間", KEY_KEY:CREATED_AT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"訂單狀態", KEY_KEY:ORDER_PROCESS_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
    ]
    
    var gatewayRows: [[String: String]] = [
        [TITLE_KEY:"付款方式", KEY_KEY:GATEWAY_METHOD_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"more"],
        [TITLE_KEY:"付款狀態", KEY_KEY:GATEWAY_PROCESS_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"付款時間", KEY_KEY:GATEWAY_AT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
    ]
    
    var shippingRows: [[String: String]] = [
        [TITLE_KEY:"到貨方式", KEY_KEY:SHIPPING_METHOD_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"到貨狀態", KEY_KEY:SHIPPING_PROCESS_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"出貨時間", KEY_KEY:SHIPPING_AT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
    ]
    
    var invoiceRows: [[String: String]] = [
        [TITLE_KEY:"發票種類", KEY_KEY:INVOICE_TYPE_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
        [TITLE_KEY:"寄送EMail", KEY_KEY:INVOICE_EMAIL_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
    ]
    
    var memberRows: [[String: String]] = [
        [TITLE_KEY:"姓名",KEY_KEY:NAME_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"],
        [TITLE_KEY:"電話",KEY_KEY:MOBILE_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"],
        [TITLE_KEY:"EMail",KEY_KEY:EMAIL_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"],
        [TITLE_KEY:"住址",KEY_KEY:ADDRESS_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"]
    ]
    
    let memoRows: [[String: String]] = [
        [TITLE_KEY: "留言",KEY_KEY:MEMO_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"]
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
    
    var trade_no: String = ""
    
    var popupTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.estimatedRowHeight = 44
        cv.rowHeight = UITableView.automaticDimension
        
        cv.separatorStyle = .singleLine
        cv.separatorColor = UIColor.lightGray
        
        return cv
    }()
    
    var popupRows: [[String: String]] = [[String: String]]()
    
    override func viewDidLoad() {
        myTablView = tableView

        super.viewDidLoad()
        
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
        
        let moreNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreNib, forCellReuseIdentifier: "MoreCell")
        
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
                    if let order = creditPayment.OrderInfo {
                        if let tmp = order.TradeNo {
                            self.trade_no = tmp
                        }
                    }
//
//                    if let card = creditPayment.CardInfo {
//                        //print(card)
//                    }
                    
                    if let cvs = creditPayment.CVSInfo {
                        if let tmp = cvs.PaymentNo {
                            self.payment_no = tmp
                        }
                        if let tmp = cvs.PaymentURL {
                            self.payment_url = tmp
                        }
                        if (self.payment_no.count > 0) {
                            self.gateway = GATEWAY.store_cvs
                            if let tmp = cvs.ExpireDate {
                                self.expire_at = tmp.toString(format: "yyyy-MM-dd HH:mm:ss")
                            }
                        }
                    }
                    
                    if let barcode = creditPayment.BarcodeInfo {
                        if let tmp = barcode.Barcode1 {
                            self.barcode1 = tmp
                        }
                        if let tmp = barcode.Barcode2 {
                            self.barcode2 = tmp
                        }
                        if let tmp = barcode.Barcode3 {
                            self.barcode3 = tmp
                        }
                        if (self.barcode1.count > 0 && self.barcode1 != "0") {
                            self.gateway = GATEWAY.store_barcode
                            if let tmp = barcode.ExpireDate {
                                self.expire_at = tmp.toString(format: "yyyy-MM-dd HH:mm:ss")
                            }
                        }
                    }
                    
                    if let ATM = creditPayment.ATMInfo {
                        if let tmp = ATM.BankCode {
                            self.bank_code = tmp
                        }
                        if let tmp = ATM.vAccount {
                            self.bank_account = tmp
                        }
                        if (self.bank_account.count > 0) {
                            self.gateway = GATEWAY.ATM
                            if let tmp = ATM.ExpireDate {
                                self.expire_at = tmp.toString(format: "yyyy-MM-dd HH:mm:ss")
                            }
                        }
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
        
        var params: [String: String] = ["token": order_token, "member_token": Member.instance.token,"do":"update"]
        params["expire_at"] = expire_at
        params["trade_no"] = trade_no
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
            ["name": "商品", "isExpanded": true, KEY_KEY: PRODUCT_KEY],
            ["name": "訂單", "isExpanded": true, KEY_KEY: ORDER_KEY],
            ["name": "付款方式", "isExpanded": true, KEY_KEY: GATEWAY_KEY],
            ["name": "寄送方式", "isExpanded": true, KEY_KEY: SHIPPING_KEY],
            ["name": "電子發票", "isExpanded": true, KEY_KEY: INVOICE_KEY],
            ["name": "訂購人資料", "isExpanded": true, KEY_KEY: MEMBER_KEY],
            ["name": "其他留言", "isExpanded": true, KEY_KEY: MEMO_KEY]
        ]
        
        orderTable!.filterRow()
        let orderItemsTable = orderTable!.items
        for orderItemTable in orderItemsTable {
            
            orderItemTable.filterRow()
            let productTable = orderItemTable.product
            
            var attribute_text: String = ""
            if (orderItemTable.attributes.count > 0) {

                for (idx, attribute) in orderItemTable.attributes.enumerated() {
                    attribute_text += attribute["name"]! + ":" + attribute[VALUE_KEY]!
                    if (idx < orderItemTable.attributes.count - 1) {
                        attribute_text += " | "
                    }
                }
            }
            
            let row:[String: String] = [TITLE_KEY:productTable!.name,KEY_KEY:PRODUCT_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"cart","featured_path":productTable!.featured_path,"attribute":attribute_text,"amount":orderItemTable.amount_show,"quantity":String(orderItemTable.quantity)]
            productRows.append(row)
        }
        
        myRows = [
            [KEY_KEY:PRODUCT_KEY, "rows": productRows],
            [KEY_KEY:ORDER_KEY, "rows": orderRows],
            [KEY_KEY:GATEWAY_KEY, "rows": gatewayRows],
            [KEY_KEY:SHIPPING_KEY, "rows": shippingRows],
            [KEY_KEY:INVOICE_KEY, "rows": invoiceRows],
            [KEY_KEY:MEMBER_KEY, "rows": memberRows],
            [KEY_KEY:MEMO_KEY, "rows": memoRows]
        ]
        
        //order
        var row: [String: String] = getRowRowsFromMyRowsByKey1(key: ORDER_NO_KEY)
        row[VALUE_KEY] = orderTable!.order_no
        row[SHOW_KEY] = orderTable!.order_no
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: ORDER_NO_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: AMOUNT_KEY)
        row[VALUE_KEY] = String(orderTable!.amount)
        row[SHOW_KEY] = orderTable!.amount_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: AMOUNT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_FEE_KEY)
        row[VALUE_KEY] = String(orderTable!.shipping_fee)
        row[SHOW_KEY] = orderTable!.shipping_fee_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: SHIPPING_FEE_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: TAX_KEY)
        row[VALUE_KEY] = String(orderTable!.tax)
        row[SHOW_KEY] = orderTable!.tax_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: TAX_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: TOTAL_KEY)
        row[VALUE_KEY] = String(orderTable!.total)
        row[SHOW_KEY] = orderTable!.total_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: TOTAL_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: CREATED_AT_KEY)
        row[VALUE_KEY] = orderTable!.created_at
        row[SHOW_KEY] = orderTable!.created_at_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: CREATED_AT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: ORDER_PROCESS_KEY)
        row[VALUE_KEY] = orderTable!.process
        row[SHOW_KEY] = orderTable!.order_process_show
        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: ORDER_PROCESS_KEY, _row: row)
        
        //gateway
        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_METHOD_KEY)
        row[VALUE_KEY] = orderTable!.gateway!.method
        row[SHOW_KEY] = orderTable!.gateway!.method_show
        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_METHOD_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_AT_KEY)
        row[VALUE_KEY] = orderTable!.gateway?.gateway_at
        row[SHOW_KEY] = orderTable!.gateway?.gateway_at_show
        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_AT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_PROCESS_KEY)
        row[VALUE_KEY] = orderTable!.gateway!.process
        row[SHOW_KEY] = orderTable!.gateway!.process_show
        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_PROCESS_KEY, _row: row)
        
        //shipping
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_METHOD_KEY)
        row[VALUE_KEY] = orderTable!.shipping!.method
        row[SHOW_KEY] = orderTable!.shipping!.method_show
        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_METHOD_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_METHOD_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_AT_KEY)
        row[VALUE_KEY] = orderTable!.shipping?.shipping_at
        row[SHOW_KEY] = orderTable!.shipping?.shipping_at_show
        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_AT_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_AT_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_PROCESS_KEY)
        row[VALUE_KEY] = orderTable!.shipping!.process
        row[SHOW_KEY] = orderTable!.shipping!.process_show
        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_PROCESS_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_PROCESS_KEY, _row: row)
        
        if (orderTable!.shipping?.method == "store_711" || orderTable!.shipping?.method == "store_family") {
            row = [TITLE_KEY:"到達商店時間", KEY_KEY:SHIPPING_STORE_AT_KEY, VALUE_KEY:orderTable!.shipping!.store_at, SHOW_KEY:orderTable!.shipping!.store_at_show, CELL_KEY:"text"]
            shippingRows.append(row)
        }
        
        row = [TITLE_KEY:"到貨時間", KEY_KEY:SHIPPING_COMPLETE_AT_KEY, VALUE_KEY:orderTable!.shipping!.complete_at, SHOW_KEY:orderTable!.shipping!.complete_at_show, CELL_KEY:"text"]
        shippingRows.append(row)
        
        if (orderTable!.shipping!.back_at.count > 0) {
            row = [TITLE_KEY:"退貨時間", KEY_KEY:SHIPPING_BACK_AT_KEY, VALUE_KEY:orderTable!.shipping!.back_at, SHOW_KEY:orderTable!.shipping!.back_at_show, CELL_KEY:"text"]
            shippingRows.append(row)
        }
        replaceRowsByKey(sectionKey: SHIPPING_KEY, rows: shippingRows)
        
        //invoice
        let invoice_type: String = orderTable!.invoice_type
        row = getRowFromKey(rows: invoiceRows, key: INVOICE_TYPE_KEY)
        row[VALUE_KEY] = invoice_type
        row[SHOW_KEY] = orderTable!.invoice_type_show
        invoiceRows = replaceRowByKey(rows: invoiceRows, key: INVOICE_TYPE_KEY, newRow: row)
        
        if (invoice_type == "company") {
            row = [TITLE_KEY:"公司或行號名稱", KEY_KEY:INVOICE_COMPANY_NAME_KEY, VALUE_KEY:orderTable!.invoice_company_name, SHOW_KEY:orderTable!.invoice_company_name, CELL_KEY:"text"]
            invoiceRows.append(row)
            row = [TITLE_KEY:"統一編號", KEY_KEY:INVOICE_COMPANY_TAX_KEY, VALUE_KEY:orderTable!.invoice_company_tax, SHOW_KEY:orderTable!.invoice_company_tax, CELL_KEY:"text"]
            invoiceRows.append(row)
        }
        
        row = getRowFromKey(rows: invoiceRows, key: INVOICE_EMAIL_KEY)
        row[VALUE_KEY] = orderTable!.invoice_email
        row[SHOW_KEY] = orderTable!.invoice_email
        invoiceRows = replaceRowByKey(rows: invoiceRows, key: INVOICE_EMAIL_KEY, newRow: row)
        
        replaceRowsByKey(sectionKey: INVOICE_KEY, rows: invoiceRows)
        //myRows[4]["rows"] = invoiceRows
        
        //member
        row = getRowRowsFromMyRowsByKey1(key: NAME_KEY)
        row[VALUE_KEY] = orderTable!.order_name
        row[SHOW_KEY] = orderTable!.order_name
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: NAME_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: MOBILE_KEY)
        row[VALUE_KEY] = orderTable!.order_tel
        row[SHOW_KEY] = orderTable!.order_tel_show
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: MOBILE_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: EMAIL_KEY)
        row[VALUE_KEY] = orderTable!.order_email
        row[SHOW_KEY] = orderTable!.order_email
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: EMAIL_KEY, _row: row)
        
        row = getRowRowsFromMyRowsByKey1(key: ADDRESS_KEY)
        row[VALUE_KEY] = orderTable!.order_address
        row[SHOW_KEY] = orderTable!.order_address
        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: ADDRESS_KEY, _row: row)
        
        //memo
        row = getRowRowsFromMyRowsByKey1(key: MEMO_KEY)
        row[VALUE_KEY] = orderTable!.memo
        row[SHOW_KEY] = orderTable!.memo
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
//                        let key: String = row1[KEY_KEY] as! String
//                        if key == label {
//                            var type: String = property["type"] as! String
//                            type = type.getTypeOfProperty()!
//                            //print("label=>\(property["label"]):value=>\(property[VALUE_KEY]):type=>\(type)")
//                            if type == "Int" {
//                                rows![idx][idx1][VALUE_KEY] = String(property[VALUE_KEY] as! Int)
//                            } else if type == "Bool" {
//                                rows![idx][idx1][VALUE_KEY] = String(property[VALUE_KEY] as! Bool)
//                            } else if type == "String" {
//                                rows![idx][idx1][VALUE_KEY] = property[VALUE_KEY] as! String
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
        
        if (tableView == popupTableView) {
            return 1
        } else {
            return mySections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if (tableView == popupTableView) {
            return popupRows.count
        } else {
            let mySection: [String: Any] = mySections[section]
            if (mySection.keyExist(key: "isExpanded")) {
                let isExpanded: Bool = mySection["isExpanded"] as? Bool ?? true
                if (isExpanded) {
                    if let key: String = mySection[KEY_KEY] as? String {
                        let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
                        count = rows.count
                    }
                }
            }
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (tableView == popupTableView) {
            return UIView()
        } else {
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == popupTableView) {
            
            let row: [String: String] = popupRows[indexPath.row]
            var title: String = ""
            if let tmp: String = row[TITLE_KEY] {
                title = tmp
            }
            var show: String = ""
            if let tmp: String = row[SHOW_KEY] {
                show = tmp
            }
            var cell_type = "text"
            if let tmp: String = row[CELL_KEY] {
                cell_type = tmp
            }
            if (cell_type == "text") {
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    cell.update(title: title, show: show)
                    return cell
                }
            } else if (cell_type == "barcode") {
                if let cell: BarcodeCell = tableView.dequeueReusableCell(withIdentifier: "BarcodeCell", for: indexPath) as? BarcodeCell {
                    cell.update(title: title, barcode: show)
                    return cell
                }
            }
        } else {
            
            var sectionKey: String = ""
            let section: [String: Any] = myRows[indexPath.section]
            if let tmp: String = section[KEY_KEY] as? String {
                sectionKey = tmp
            }
            
            var rowKey: String = ""
            var row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
            if let tmp: String = row[KEY_KEY] {
                rowKey = tmp
            }
            
            var cell_type: String = "text"
            if (row.keyExist(key: CELL_KEY)) {
                cell_type = row[CELL_KEY]!
            }
            
            var title: String = ""
            var show: String = ""
            var value: String = ""
            
            if row.keyExist(key: TITLE_KEY) {
                title = row[TITLE_KEY]!
            }
            
            if row.keyExist(key: SHOW_KEY) {
                show = row[SHOW_KEY]!
            }
            
            if row.keyExist(key: VALUE_KEY) {
                value = row[VALUE_KEY]!
            }
            
//            if (rowKey == GATEWAY_METHOD_KEY) {
//                let method: GATEWAY = GATEWAY.stringToEnum(orderTable!.gateway!.method)
//
//                if (method == GATEWAY.store_cvs || method == GATEWAY.store_barcode || method == GATEWAY.ATM) {
//                    cell_type = "more"
//                }
//            }
            
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
            } else if (cell_type == "more") {
                if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as? MoreCell {
                    
                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: value, show: show)
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var rowKey: String = ""
        let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
        if let tmp: String = row[KEY_KEY] {
            rowKey = tmp
        }
        
        var sectionKey: String = ""
        let section: [String: Any] = myRows[indexPath.section]
        if let tmp: String = section[KEY_KEY] as? String {
            sectionKey = tmp
        }
        
//        print(sectionKey)
//        print(rowKey)
        
        if (sectionKey == GATEWAY_KEY && rowKey == GATEWAY_METHOD_KEY) {
            if (orderTable != nil) {
                //print(orderTable!.gateway!.printRow())
                
                //let panel: Panel = Panel(baseVC: self)
                //panel.show(rows: gatewayRows)
                maskView = view.mask()
                let top: CGFloat = (maskView.frame.height-panelHeight)/2
                blackView = maskView.blackView(left: panelLeftPadding, top: top, width: maskView.frame.width-2*panelLeftPadding, height:panelHeight)
                
                popupTableView.frame = CGRect(x: 0, y: 0, width: blackView.frame.width, height: blackView.frame.height-80)
                popupTableView.dataSource = self
                popupTableView.delegate = self
                
                popupTableView.backgroundColor = .clear
                
                blackView.addSubview(popupTableView)
                
                let plainNib = UINib(nibName: "PlainCell", bundle: nil)
                popupTableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
                let barcodeNib = UINib(nibName: "BarcodeCell", bundle: nil)
                popupTableView.register(barcodeNib, forCellReuseIdentifier: "BarcodeCell")
                
                stackView = blackView.addStackView(height: 80)
                
                panelCancelBtn = stackView.addCancelBtn()
                //panelSubmitBtn = stackView.addSubmitBtn()
                panelCancelBtn.addTarget(self, action: #selector(panelCancelAction), for: .touchUpInside)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(unmask))
                gesture.cancelsTouchesInView = false
                maskView.addGestureRecognizer(gesture)
                
                let method: GATEWAY = GATEWAY.stringToEnum(orderTable!.gateway!.method)
                if (method == GATEWAY.ATM) {
                    let bank_code: String = orderTable!.gateway!.bank_code
                    let bank_account: String = orderTable!.gateway!.bank_account
                    let expire_at: String = orderTable!.gateway!.expire_at_show
                    popupRows = [
                        [TITLE_KEY:"銀行代號",KEY_KEY:BANK_CODE_KEY,VALUE_KEY:bank_code,SHOW_KEY:bank_code,CELL_KEY:"text"],
                        [TITLE_KEY:"銀行帳號",KEY_KEY:BANK_ACCOUNT_KEY,VALUE_KEY:bank_account,SHOW_KEY:bank_account,CELL_KEY:"text"],
                        [TITLE_KEY:"到期日",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:expire_at,SHOW_KEY:expire_at,CELL_KEY:"text"]
                    ]
                } else if (method == GATEWAY.store_cvs) {
                    let payment_no: String = orderTable!.gateway!.payment_no
                    let expire_at: String = orderTable!.gateway!.expire_at_show
                    popupRows = [
                        [TITLE_KEY:"繳款代碼",KEY_KEY:PAYMENT_NO_KEY,VALUE_KEY:payment_no,SHOW_KEY:payment_no,CELL_KEY:"barcode"],
                        [TITLE_KEY:"到期日",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:expire_at,SHOW_KEY:expire_at,CELL_KEY:"text"]
                    ]
                } else if (method == GATEWAY.store_barcode) {
                    let barcode1: String = orderTable!.gateway!.barcode1
                    let barcode2: String = orderTable!.gateway!.barcode2
                    let barcode3: String = orderTable!.gateway!.barcode3
                    let expire_at: String = orderTable!.gateway!.expire_at_show
                    popupRows = [
                        [TITLE_KEY:"繳款條碼1",KEY_KEY:BARCODE1_KEY,VALUE_KEY:barcode1,SHOW_KEY:barcode1,CELL_KEY:"barcode"],
                        [TITLE_KEY:"繳款條碼2",KEY_KEY:BARCODE2_KEY,VALUE_KEY:barcode2,SHOW_KEY:barcode2,CELL_KEY:"barcode"],
                        [TITLE_KEY:"繳款條碼3",KEY_KEY:BARCODE3_KEY,VALUE_KEY:barcode3,SHOW_KEY:barcode3,CELL_KEY:"barcode"],
                        [TITLE_KEY:"到期日",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:expire_at,SHOW_KEY:expire_at,CELL_KEY:"text"]
                    ]
                } else if (method == GATEWAY.credit_card) {
                    let card6No: String = orderTable!.gateway!.card6No
                    let card4No: String = orderTable!.gateway!.card4No
                    popupRows = [
                        [TITLE_KEY:"信用卡前6碼",KEY_KEY:PAYMENT_NO_KEY,VALUE_KEY:card6No,SHOW_KEY:card6No,CELL_KEY:"text"],
                        [TITLE_KEY:"信用卡後4碼",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:card4No,SHOW_KEY:card4No,CELL_KEY:"text"]
                    ]
                }
                
                popupTableView.reloadData()
            }
        }
    }
    
    @objc func panelCancelAction(){
        unmask()
    }
    
    override func unmask() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.frame = CGRect(x:0, y:self.view.frame.height, width:self.view.frame.width, height:self.view.frame.height)
            //self.blackView.frame = CGRect(x:self.panelLeftPadding, y:self.view.frame.height, width:self.view.frame.width-(2*self.panelLeftPadding), height:self.maskView.frame.height-self.panelTopPadding)
        }, completion: { (finished) in
            if finished {
                for view in self.maskView.subviews {
                    view.removeFromSuperview()
                }
                self.maskView.removeFromSuperview()
            }
        })
    }
}
