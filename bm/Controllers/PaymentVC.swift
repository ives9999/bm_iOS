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
    @IBOutlet weak var submitBtn: SuperButton!
    @IBOutlet weak var bottomThreeView: BottomThreeView!
    
    //@IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    //@IBOutlet weak var dataContainerBottom: NSLayoutConstraint!
    
    var ecpay_token: String = ""
    var order_token: String = ""
    var tokenExpireDate: String = ""
    var orderTable: OrderTable? = nil
    
    let heightForSection: CGFloat = 34
    
//    var productRows: [[String: String]] = []
//
//    var orderRows: [[String: String]] = [
//        [TITLE_KEY:"訂單編號", KEY_KEY:ORDER_NO_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"商品金額", KEY_KEY:AMOUNT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"運費", KEY_KEY:SHIPPING_FEE_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"稅", KEY_KEY:TAX_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"訂單金額", KEY_KEY:TOTAL_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"訂單建立時間", KEY_KEY:CREATED_AT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"訂單狀態", KEY_KEY:ORDER_PROCESS_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
//    ]
//
//    var gatewayRows: [[String: String]] = [
//        [TITLE_KEY:"付款方式", KEY_KEY:GATEWAY_METHOD_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"more"],
//        [TITLE_KEY:"付款狀態", KEY_KEY:GATEWAY_PROCESS_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"付款時間", KEY_KEY:GATEWAY_AT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
//    ]
//
//    var shippingRows: [[String: String]] = [
//        [TITLE_KEY:"到貨方式", KEY_KEY:SHIPPING_METHOD_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"到貨狀態", KEY_KEY:SHIPPING_PROCESS_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"出貨時間", KEY_KEY:SHIPPING_AT_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
//    ]
//
//    var invoiceRows: [[String: String]] = [
//        [TITLE_KEY:"發票種類", KEY_KEY:INVOICE_TYPE_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"],
//        [TITLE_KEY:"寄送EMail", KEY_KEY:INVOICE_EMAIL_KEY, VALUE_KEY:"", SHOW_KEY:"", CELL_KEY:"text"]
//    ]
//
//    var memberRows: [[String: String]] = [
//        [TITLE_KEY:"姓名",KEY_KEY:NAME_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"],
//        [TITLE_KEY:"電話",KEY_KEY:MOBILE_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"],
//        [TITLE_KEY:"EMail",KEY_KEY:EMAIL_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"],
//        [TITLE_KEY:"住址",KEY_KEY:ADDRESS_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"]
//    ]
//
//    let memoRows: [[String: String]] = [
//        [TITLE_KEY: "留言",KEY_KEY:MEMO_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"text"]
//    ]
    
    var gateway: GATEWAY = GATEWAY.credit_card
    var payment_no: String = ""
    var expire_at: String = ""
    var payment_url: String = ""
    var barcode1: String = ""
    var barcode2: String = ""
    var barcode3: String = ""
    var bank_code: String = ""
    var bank_account: String = ""
    
    var handle_fee: String = ""
    var trade_no: String = ""
    var card6No: String = ""
    var card4No: String = ""
    var gateway_at: String = ""
    
    var popupTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.estimatedRowHeight = 44
        cv.rowHeight = UITableView.automaticDimension
        
        cv.separatorStyle = .singleLine
        cv.separatorColor = UIColor.lightGray
        
        return cv
    }()
    
    //var popupRows: [[String: String]] = [[String: String]]()
    var popupRows: [OneRow] = [OneRow]()
    
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
        
        //submitBtn.setTitle("付款")
        
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("付款")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
        
        if ecpay_token.count > 0 {
            toECPay()
        } else {
            refresh()
        }
    }
    
    func toECPay() {
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
                    
                    if let tmp = order.ChargeFee {
                        self.handle_fee = "\(tmp)"
                    }
                    
                    if let tmp: Date = order.PaymentDate {
                        self.gateway_at = tmp.toString(format: "yyyy-MM-dd HH:mm:ss")
                    }
                }

                if let card = creditPayment.CardInfo {
                    if let tmp = card.Card4No {
                        self.card4No = tmp
                    }
                    
                    if let tmp = card.Card6No {
                        self.card6No = tmp
                    }
                }
                
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
//                if (self.gateway == GATEWAY.credit_card) {
//                    self.refresh()
//                } else {
//                    self.updateOrder()
//                }
                self.updateOrder()

            case .Fail:
                //print("Faile")
                self.warning(msg: state.callbackStateMessage, buttonTitle: "關閉", buttonAction: {
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.toProduct()
                })
                
            case .Cancel:
                //print("Cancel")
                self.warning(msg: "您已經取消付款", buttonTitle: "關閉", buttonAction: {
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.toProduct()
                })

            case .Unknown:
                //print("Unknown")
                self.warning(msg: "由於不知名的錯誤，造成付款失敗，請麻煩聯絡管理員", buttonTitle: "關閉", buttonAction: {
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.toProduct()
                })
            }
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
        
        //目前的寫法，只有不使用信用卡付款，才會呼叫這個函式，所以order process不用更改
        params["gateway_process"] = GATEWAY_PROCESS.code.enumToString()
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
        } else if (gateway == GATEWAY.credit_card) {
            params["gateway_process"] = GATEWAY_PROCESS.complete.enumToString()
            params["gateway_at"] = gateway_at
            params["handle_fee"] = handle_fee
            params["card4No"] = card4No
            params["card6No"] = card6No
        }
        
        OrderService.instance.update(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                //self.refresh()
                //self.jsonData = OrderService.instance.jsonData
                self.info(msg: "付款完成", buttonTitle: "關閉", buttonAction: {
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.toProduct()
                })
            } else {
                self.warning(msg: OrderService.instance.msg, buttonTitle: "關閉", buttonAction: {
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.toProduct()
                })
            }
        }
    }
    
    func initData() {
        
        titleLbl.text = orderTable!.order_no
        titleLbl.textColor = UIColor.black
        
//        mySections = [
//            ["name": "商品", "isExpanded": true, KEY_KEY: PRODUCT_KEY],
//            ["name": "訂單", "isExpanded": true, KEY_KEY: ORDER_KEY],
//            ["name": "付款方式", "isExpanded": true, KEY_KEY: GATEWAY_KEY],
//            ["name": "寄送方式", "isExpanded": true, KEY_KEY: SHIPPING_KEY],
//            ["name": "電子發票", "isExpanded": true, KEY_KEY: INVOICE_KEY],
//            ["name": "訂購人資料", "isExpanded": true, KEY_KEY: MEMBER_KEY],
//            ["name": "其他留言", "isExpanded": true, KEY_KEY: MEMO_KEY]
//        ]
        
        orderTable!.filterRow()
        if (orderTable!.all_process > 1) {//已經付費了
            //bottomThreeView.isHidden = true
            //dataContainer.translatesAutoresizingMaskIntoConstraints = false
            //dataContainer.bottomAnchor.constraint(equalTo: dataContainer.superview!.bottomAnchor, constant: 0).isActive = true
            bottomThreeView.submitButton.isHidden = true
            //bottomThreeView.threeButton.isHidden = true
            bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
        }
        
        var rows: [OneRow] = [OneRow]()
        
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
            
            let row = OneRow(title: productTable!.name, key: PRODUCT_KEY, cell: "cart")
            row.featured_path = productTable!.featured_path
            row.attribute = attribute_text
            row.amount = orderItemTable.amount_show
            row.quantity = String(orderItemTable.quantity)
            
            rows.append(row)
            
//            let row:[String: String] = [TITLE_KEY:productTable!.name,KEY_KEY:PRODUCT_KEY,VALUE_KEY:"",SHOW_KEY:"",CELL_KEY:"cart","featured_path":productTable!.featured_path,"attribute":attribute_text,"amount":orderItemTable.amount_show,"quantity":String(orderItemTable.quantity)]
//            productRows.append(row)
        }
        
        var section = makeSectionRow(title: "商品", key: PRODUCT_KEY, rows: rows)
        oneSections.append(section)
        
//        myRows = [
//            [KEY_KEY:PRODUCT_KEY, "rows": productRows],
//            [KEY_KEY:ORDER_KEY, "rows": orderRows],
//            [KEY_KEY:GATEWAY_KEY, "rows": gatewayRows],
//            [KEY_KEY:SHIPPING_KEY, "rows": shippingRows],
//            [KEY_KEY:INVOICE_KEY, "rows": invoiceRows],
//            [KEY_KEY:MEMBER_KEY, "rows": memberRows],
//            [KEY_KEY:MEMO_KEY, "rows": memoRows]
//        ]
        
        //order
        rows.removeAll()
        var row = OneRow(title: "編號", value: orderTable!.order_no, show: orderTable!.order_no, key: ORDER_NO_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "商品金額", value: String(orderTable!.amount), show: orderTable!.amount_show, key: AMOUNT_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "運費", value: String(orderTable!.shipping_fee), show: orderTable!.shipping_fee_show, key: SHIPPING_FEE_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "税", value: String(orderTable!.tax), show: orderTable!.tax_show, key: TAX_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "總金額", value: String(orderTable!.total), show: orderTable!.total_show, key: TOTAL_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "建立時間", value: String(orderTable!.created_at), show: orderTable!.created_at_show, key: CREATED_AT_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "狀態", value: String(orderTable!.all_process), show: orderTable!.all_process_show, key: ORDER_PROCESS_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "訂單", key: ORDER_KEY, rows: rows)
        oneSections.append(section)
//        var row: [String: String] = getRowRowsFromMyRowsByKey1(key: ORDER_NO_KEY)
//        row[VALUE_KEY] = orderTable!.order_no
//        row[SHOW_KEY] = orderTable!.order_no
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: ORDER_NO_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: AMOUNT_KEY)
//        row[VALUE_KEY] = String(orderTable!.amount)
//        row[SHOW_KEY] = orderTable!.amount_show
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: AMOUNT_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_FEE_KEY)
//        row[VALUE_KEY] = String(orderTable!.shipping_fee)
//        row[SHOW_KEY] = orderTable!.shipping_fee_show
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: SHIPPING_FEE_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: TAX_KEY)
//        row[VALUE_KEY] = String(orderTable!.tax)
//        row[SHOW_KEY] = orderTable!.tax_show
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: TAX_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: TOTAL_KEY)
//        row[VALUE_KEY] = String(orderTable!.total)
//        row[SHOW_KEY] = orderTable!.total_show
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: TOTAL_KEY, _row: row)
//
//        row = getRowRowsFromMyRowsByKey1(key: CREATED_AT_KEY)
//        row[VALUE_KEY] = orderTable!.created_at
//        row[SHOW_KEY] = orderTable!.created_at_show
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: CREATED_AT_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: ORDER_PROCESS_KEY)
//        row[VALUE_KEY] = String(orderTable!.all_process)
//        row[SHOW_KEY] = orderTable!.all_process_show
//        replaceRowByKey(sectionKey: ORDER_KEY, rowKey: ORDER_PROCESS_KEY, _row: row)
        
        //gateway
        rows.removeAll()
        row = OneRow(title: "付款方式", value: orderTable!.gateway!.method, show: orderTable!.gateway!.method_show, key: GATEWAY_METHOD_KEY, cell: "more", isClear: false)
        rows.append(row)
        row = OneRow(title: "付款狀態", value: orderTable!.gateway!.process, show: orderTable!.gateway!.process_show, key: GATEWAY_PROCESS_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "付款時間", value: orderTable!.gateway!.gateway_at, show: orderTable!.gateway!.gateway_at_show, key: GATEWAY_AT_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "付款方式", key: GATEWAY_KEY, rows: rows)
        oneSections.append(section)
        
//        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_METHOD_KEY)
//        row[VALUE_KEY] = orderTable!.gateway!.method
//        row[SHOW_KEY] = orderTable!.gateway!.method_show
//        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_METHOD_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_AT_KEY)
//        row[VALUE_KEY] = orderTable!.gateway?.gateway_at
//        row[SHOW_KEY] = orderTable!.gateway?.gateway_at_show
//        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_AT_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: GATEWAY_PROCESS_KEY)
//        row[VALUE_KEY] = orderTable!.gateway!.process
//        row[SHOW_KEY] = orderTable!.gateway!.process_show
//        replaceRowByKey(sectionKey: GATEWAY_KEY, rowKey: GATEWAY_PROCESS_KEY, _row: row)
        
        //shipping
        rows.removeAll()
        row = OneRow(title: "到貨方式", value: orderTable!.shipping!.method, show: orderTable!.shipping!.method_show, key: SHIPPING_METHOD_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "到貨狀態", value: orderTable!.shipping!.process, show: orderTable!.shipping!.process_show, key: SHIPPING_PROCESS_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "出貨時間", value: orderTable!.shipping!.shipping_at, show: orderTable!.shipping!.shipping_at_show, key: SHIPPING_AT_KEY, cell: "text")
        rows.append(row)
        if (orderTable!.shipping?.method == "store_711" || orderTable!.shipping?.method == "store_family") {
            row = OneRow(title: "到達商店時間", value: orderTable!.shipping!.store_at, show: orderTable!.shipping!.store_at_show, key: SHIPPING_STORE_AT_KEY, cell: "text")
            rows.append(row)
        }
        row = OneRow(title: "到貨時間", value: orderTable!.shipping!.complete_at, show: orderTable!.shipping!.complete_at_show, key: SHIPPING_COMPLETE_AT_KEY, cell: "text")
        rows.append(row)
        if (orderTable!.shipping!.back_at.count > 0) {
            row = OneRow(title: "退貨時間", value: orderTable!.shipping!.back_at, show: orderTable!.shipping!.back_at_show, key: SHIPPING_BACK_AT_KEY, cell: "text")
            rows.append(row)
        }
        section = makeSectionRow(title: "到貨方式", key: SHIPPING_KEY, rows: rows)
        oneSections.append(section)
        
//        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_METHOD_KEY)
//        row[VALUE_KEY] = orderTable!.shipping!.method
//        row[SHOW_KEY] = orderTable!.shipping!.method_show
//        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_METHOD_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_METHOD_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_AT_KEY)
//        row[VALUE_KEY] = orderTable!.shipping?.shipping_at
//        row[SHOW_KEY] = orderTable!.shipping?.shipping_at_show
//        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_AT_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_AT_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_PROCESS_KEY)
//        row[VALUE_KEY] = orderTable!.shipping!.process
//        row[SHOW_KEY] = orderTable!.shipping!.process_show
//        shippingRows = replaceRowByKey(rows: shippingRows, key: SHIPPING_PROCESS_KEY, newRow: row)
        //replaceRowByKey(sectionKey: SHIPPING_KEY, rowKey: SHIPPING_PROCESS_KEY, _row: row)
        
//        if (orderTable!.shipping?.method == "store_711" || orderTable!.shipping?.method == "store_family") {
//            row = [TITLE_KEY:"到達商店時間", KEY_KEY:SHIPPING_STORE_AT_KEY, VALUE_KEY:orderTable!.shipping!.store_at, SHOW_KEY:orderTable!.shipping!.store_at_show, CELL_KEY:"text"]
//            shippingRows.append(row)
//        }
        
//        row = [TITLE_KEY:"到貨時間", KEY_KEY:SHIPPING_COMPLETE_AT_KEY, VALUE_KEY:orderTable!.shipping!.complete_at, SHOW_KEY:orderTable!.shipping!.complete_at_show, CELL_KEY:"text"]
//        shippingRows.append(row)
        
//        if (orderTable!.shipping!.back_at.count > 0) {
//            row = [TITLE_KEY:"退貨時間", KEY_KEY:SHIPPING_BACK_AT_KEY, VALUE_KEY:orderTable!.shipping!.back_at, SHOW_KEY:orderTable!.shipping!.back_at_show, CELL_KEY:"text"]
//            shippingRows.append(row)
//        }
//        replaceRowsByKey(sectionKey: SHIPPING_KEY, rows: shippingRows)
        
        //invoice
        rows.removeAll()
        let invoice_type: String = orderTable!.invoice_type
        row = OneRow(title: "發票種類", value: invoice_type, show: orderTable!.invoice_type_show, key: INVOICE_TYPE_KEY, cell: "text")
        rows.append(row)
        if (invoice_type == "company") {
            row = OneRow(title: "公司或行號名稱", value: orderTable!.invoice_company_name, show: orderTable!.invoice_company_name, key: INVOICE_COMPANY_NAME_KEY, cell: "text")
            rows.append(row)
            row = OneRow(title: "統一編號", value: orderTable!.invoice_company_tax, show: orderTable!.invoice_company_tax, key: INVOICE_COMPANY_TAX_KEY, cell: "text")
            rows.append(row)
        }
        row = OneRow(title: "發票種類", value: orderTable!.invoice_email, show: orderTable!.invoice_email, key: INVOICE_EMAIL_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "發票號碼", value: orderTable!.invoice_no, show: orderTable!.invoice_no, key: INVOICE_NO_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "開立時間", value: orderTable!.invoice_at, show: orderTable!.invoice_at, key: INVOICE_AT_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "電子發票", key: INVOICE_KEY, rows: rows)
        oneSections.append(section)
        
//        let invoice_type: String = orderTable!.invoice_type
//        row = getRowFromKey(rows: invoiceRows, key: INVOICE_TYPE_KEY)
//        row[VALUE_KEY] = invoice_type
//        row[SHOW_KEY] = orderTable!.invoice_type_show
//        invoiceRows = replaceRowByKey(rows: invoiceRows, key: INVOICE_TYPE_KEY, newRow: row)
        
//        if (invoice_type == "company") {
//            row = [TITLE_KEY:"公司或行號名稱", KEY_KEY:INVOICE_COMPANY_NAME_KEY, VALUE_KEY:orderTable!.invoice_company_name, SHOW_KEY:orderTable!.invoice_company_name, CELL_KEY:"text"]
//            invoiceRows.append(row)
//            row = [TITLE_KEY:"統一編號", KEY_KEY:INVOICE_COMPANY_TAX_KEY, VALUE_KEY:orderTable!.invoice_company_tax, SHOW_KEY:orderTable!.invoice_company_tax, CELL_KEY:"text"]
//            invoiceRows.append(row)
//        }
        
//        row = getRowFromKey(rows: invoiceRows, key: INVOICE_EMAIL_KEY)
//        row[VALUE_KEY] = orderTable!.invoice_email
//        row[SHOW_KEY] = orderTable!.invoice_email
//        invoiceRows = replaceRowByKey(rows: invoiceRows, key: INVOICE_EMAIL_KEY, newRow: row)
//
//        replaceRowsByKey(sectionKey: INVOICE_KEY, rows: invoiceRows)
        //myRows[4]["rows"] = invoiceRows
        
        //member
        rows.removeAll()
        row = OneRow(title: "姓名", value: orderTable!.order_name, show: orderTable!.order_name, key: NAME_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "電話", value: orderTable!.order_tel, show: orderTable!.order_tel, key: MOBILE_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "EMail", value: orderTable!.order_email, show: orderTable!.order_email, key: EMAIL_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "住址", value: orderTable!.order_address, show: orderTable!.order_address, key: ADDRESS_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "電子發票", key: INVOICE_KEY, rows: rows)
        oneSections.append(section)
        
//        row = getRowRowsFromMyRowsByKey1(key: NAME_KEY)
//        row[VALUE_KEY] = orderTable!.order_name
//        row[SHOW_KEY] = orderTable!.order_name
//        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: NAME_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: MOBILE_KEY)
//        row[VALUE_KEY] = orderTable!.order_tel
//        row[SHOW_KEY] = orderTable!.order_tel_show
//        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: MOBILE_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: EMAIL_KEY)
//        row[VALUE_KEY] = orderTable!.order_email
//        row[SHOW_KEY] = orderTable!.order_email
//        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: EMAIL_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: ADDRESS_KEY)
//        row[VALUE_KEY] = orderTable!.order_address
//        row[SHOW_KEY] = orderTable!.order_address
//        replaceRowByKey(sectionKey: MEMBER_KEY, rowKey: ADDRESS_KEY, _row: row)
        
        //memo
        rows.removeAll()
        row = OneRow(title: "其他留言", value: orderTable!.memo, show: orderTable!.memo, key: MEMO_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "其他留言", key: MEMO_KEY, rows: rows)
        oneSections.append(section)
        
//        row = getRowRowsFromMyRowsByKey1(key: MEMO_KEY)
//        row[VALUE_KEY] = orderTable!.memo
//        row[SHOW_KEY] = orderTable!.memo
//        replaceRowByKey(sectionKey: MEMO_KEY, rowKey: MEMO_KEY, _row: row)
        
        
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
            return oneSections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if (tableView == popupTableView) {
            return popupRows.count
        } else {
            let tmp = oneSections[section]
            if (tmp.isExpanded) {
                count = tmp.items.count
            } else {
                count = 0
            }
//            let mySection: [String: Any] = mySections[section]
//            if (mySection.keyExist(key: "isExpanded")) {
//                let isExpanded: Bool = mySection["isExpanded"] as? Bool ?? true
//                if (isExpanded) {
//                    if let key: String = mySection[KEY_KEY] as? String {
//                        let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
//                        count = rows.count
//                    }
//                }
//            }
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
            titleLabel.text = oneSections[section].title
            titleLabel.textColor = UIColor.black
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
            headerView.addSubview(titleLabel)
            
            let isExpanded = oneSections[section].isExpanded
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
            
            let row: OneRow = popupRows[indexPath.row]
            
            if (row.cell == "text") {
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    cell.update(title: row.title, show: row.show)
                    return cell
                }
            } else if (row.cell == "barcode") {
                if let cell: BarcodeCell = tableView.dequeueReusableCell(withIdentifier: "BarcodeCell", for: indexPath) as? BarcodeCell {
                    cell.update(title: row.title, barcode: row.show)
                    return cell
                }
            }
        } else {
            
            let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
            
            if (row.cell == "cart") {
                if let cell: CartListCell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {
                    
                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    //cell.update(sectionKey: sectionKey,rowKey: rowKey,title: title,featured_path:row["featured_path"]!,attribute:row["attribute"]!,amount: row["amount"]!,quantity: row["quantity"]!)
                    return cell
                }
            } else if (row.cell == "text") {
                
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    
                    cell.update(title: row.title, show: row.show)
                    return cell
                }
            } else if (row.cell == "more") {
                if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as? MoreCell {
                    
                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
//                    cell.baseViewControllerDelegate = self
//                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: value, show: show)
                    return cell
                }
            }
            
//            var sectionKey: String = ""
//            let section: [String: Any] = myRows[indexPath.section]
//            if let tmp: String = section[KEY_KEY] as? String {
//                sectionKey = tmp
//            }
//
//            var rowKey: String = ""
//            var row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
//            if let tmp: String = row[KEY_KEY] {
//                rowKey = tmp
//            }
//
//            var cell_type: String = "text"
//            if (row.keyExist(key: CELL_KEY)) {
//                cell_type = row[CELL_KEY]!
//            }
//
//            var title: String = ""
//            var show: String = ""
//            var value: String = ""
//
//            if row.keyExist(key: TITLE_KEY) {
//                title = row[TITLE_KEY]!
//            }
//
//            if row.keyExist(key: SHOW_KEY) {
//                show = row[SHOW_KEY]!
//            }
//
//            if row.keyExist(key: VALUE_KEY) {
//                value = row[VALUE_KEY]!
//            }
//
////            if (rowKey == GATEWAY_METHOD_KEY) {
////                let method: GATEWAY = GATEWAY.stringToEnum(orderTable!.gateway!.method)
////
////                if (method == GATEWAY.store_cvs || method == GATEWAY.store_barcode || method == GATEWAY.ATM) {
////                    cell_type = "more"
////                }
////            }
//
//            if (cell_type == "cart") {
//                if let cell: CartListCell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {
//
//                    cell.update(sectionKey: sectionKey,rowKey: rowKey,title: title,featured_path:row["featured_path"]!,attribute:row["attribute"]!,amount: row["amount"]!,quantity: row["quantity"]!)
//                    return cell
//                }
//            } else if (cell_type == "text") {
//                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
//
//                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, show: show)
//                    return cell
//                }
//            } else if (cell_type == "more") {
//                if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as? MoreCell {
//
//                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: value, show: show)
//                    return cell
//                }
//            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        var rowKey: String = ""
//        let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
//        if let tmp: String = row[KEY_KEY] {
//            rowKey = tmp
//        }
//
//        var sectionKey: String = ""
//        let section: [String: Any] = myRows[indexPath.section]
//        if let tmp: String = section[KEY_KEY] as? String {
//            sectionKey = tmp
//        }
        
//        print(sectionKey)
//        print(rowKey)
        
        let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
        
        if (row.key == GATEWAY_METHOD_KEY) {
            if (orderTable != nil) {
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
                        OneRow(title: "銀行代號", value: bank_code, show: bank_code, key: BANK_CODE_KEY, cell: "text"),
                        OneRow(title: "銀行帳號", value: bank_account, show: bank_account, key: BANK_ACCOUNT_KEY, cell: "text"),
                        OneRow(title: "到期日", value: expire_at, show: expire_at, key: EXPIRE_AT_KEY, cell: "text")
                        ]
                    
                } else if (method == GATEWAY.store_cvs) {
                    let payment_no: String = orderTable!.gateway!.payment_no
                    let expire_at: String = orderTable!.gateway!.expire_at_show
                    popupRows = [
                        OneRow(title: "繳款代碼", value: payment_no, show: payment_no, key: PAYMENT_NO_KEY, cell: "text"),
                        OneRow(title: "到期日", value: expire_at, show: expire_at, key: EXPIRE_AT_KEY, cell: "text")
                        ]
                } else if (method == GATEWAY.store_barcode) {
                    let barcode1: String = orderTable!.gateway!.barcode1
                    let barcode2: String = orderTable!.gateway!.barcode2
                    let barcode3: String = orderTable!.gateway!.barcode3
                    popupRows = [
                        OneRow(title: "繳款條碼1", value: barcode1, show: barcode1, key: BARCODE1_KEY, cell: "barcode"),
                        OneRow(title: "繳款條碼2", value: barcode2, show: barcode2, key: BARCODE2_KEY, cell: "barcode"),
                        OneRow(title: "繳款條碼3", value: barcode3, show: barcode3, key: BARCODE3_KEY, cell: "barcode"),
                        OneRow(title: "到期日", value: expire_at, show: expire_at, key: EXPIRE_AT_KEY, cell: "text")
                    ]
                } else if (method == GATEWAY.credit_card) {
                    let card6No: String = orderTable!.gateway!.card6No
                    let card4No: String = orderTable!.gateway!.card4No
                    popupRows = [
                        OneRow(title: "信用卡前6碼", value: card6No, show: card6No, key: "", cell: "text"),
                        OneRow(title: "信用卡後4碼", value: card4No, show: card4No, key: "", cell: "text")
                        ]
                }
                popupTableView.reloadData()
            }
        }
        
//        if (sectionKey == GATEWAY_KEY && rowKey == GATEWAY_METHOD_KEY) {
//            if (orderTable != nil) {
//                //print(orderTable!.gateway!.printRow())
//
//                //let panel: Panel = Panel(baseVC: self)
//                //panel.show(rows: gatewayRows)
//                maskView = view.mask()
//                let top: CGFloat = (maskView.frame.height-panelHeight)/2
//                blackView = maskView.blackView(left: panelLeftPadding, top: top, width: maskView.frame.width-2*panelLeftPadding, height:panelHeight)
//
//                popupTableView.frame = CGRect(x: 0, y: 0, width: blackView.frame.width, height: blackView.frame.height-80)
//                popupTableView.dataSource = self
//                popupTableView.delegate = self
//
//                popupTableView.backgroundColor = .clear
//
//                blackView.addSubview(popupTableView)
//
//                let plainNib = UINib(nibName: "PlainCell", bundle: nil)
//                popupTableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
//                let barcodeNib = UINib(nibName: "BarcodeCell", bundle: nil)
//                popupTableView.register(barcodeNib, forCellReuseIdentifier: "BarcodeCell")
//
//                stackView = blackView.addStackView(height: 80)
//
//                panelCancelBtn = stackView.addCancelBtn()
//                //panelSubmitBtn = stackView.addSubmitBtn()
//                panelCancelBtn.addTarget(self, action: #selector(panelCancelAction), for: .touchUpInside)
//                let gesture = UITapGestureRecognizer(target: self, action: #selector(unmask))
//                gesture.cancelsTouchesInView = false
//                maskView.addGestureRecognizer(gesture)
//
//                let method: GATEWAY = GATEWAY.stringToEnum(orderTable!.gateway!.method)
//                if (method == GATEWAY.ATM) {
//                    let bank_code: String = orderTable!.gateway!.bank_code
//                    let bank_account: String = orderTable!.gateway!.bank_account
//                    let expire_at: String = orderTable!.gateway!.expire_at_show
//                    popupRows = [
//                        [TITLE_KEY:"銀行代號",KEY_KEY:BANK_CODE_KEY,VALUE_KEY:bank_code,SHOW_KEY:bank_code,CELL_KEY:"text"],
//                        [TITLE_KEY:"銀行帳號",KEY_KEY:BANK_ACCOUNT_KEY,VALUE_KEY:bank_account,SHOW_KEY:bank_account,CELL_KEY:"text"],
//                        [TITLE_KEY:"到期日",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:expire_at,SHOW_KEY:expire_at,CELL_KEY:"text"]
//                    ]
//                } else if (method == GATEWAY.store_cvs) {
//                    let payment_no: String = orderTable!.gateway!.payment_no
//                    let expire_at: String = orderTable!.gateway!.expire_at_show
//                    popupRows = [
//                        [TITLE_KEY:"繳款代碼",KEY_KEY:PAYMENT_NO_KEY,VALUE_KEY:payment_no,SHOW_KEY:payment_no,CELL_KEY:"text"],
//                        [TITLE_KEY:"到期日",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:expire_at,SHOW_KEY:expire_at,CELL_KEY:"text"]
//                    ]
//                } else if (method == GATEWAY.store_barcode) {
//                    let barcode1: String = orderTable!.gateway!.barcode1
//                    let barcode2: String = orderTable!.gateway!.barcode2
//                    let barcode3: String = orderTable!.gateway!.barcode3
//                    let expire_at: String = orderTable!.gateway!.expire_at_show
//                    popupRows = [
//                        [TITLE_KEY:"繳款條碼1",KEY_KEY:BARCODE1_KEY,VALUE_KEY:barcode1,SHOW_KEY:barcode1,CELL_KEY:"barcode"],
//                        [TITLE_KEY:"繳款條碼2",KEY_KEY:BARCODE2_KEY,VALUE_KEY:barcode2,SHOW_KEY:barcode2,CELL_KEY:"barcode"],
//                        [TITLE_KEY:"繳款條碼3",KEY_KEY:BARCODE3_KEY,VALUE_KEY:barcode3,SHOW_KEY:barcode3,CELL_KEY:"barcode"],
//                        [TITLE_KEY:"到期日",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:expire_at,SHOW_KEY:expire_at,CELL_KEY:"text"]
//                    ]
//                } else if (method == GATEWAY.credit_card) {
//                    let card6No: String = orderTable!.gateway!.card6No
//                    let card4No: String = orderTable!.gateway!.card4No
//                    popupRows = [
//                        [TITLE_KEY:"信用卡前6碼",KEY_KEY:PAYMENT_NO_KEY,VALUE_KEY:card6No,SHOW_KEY:card6No,CELL_KEY:"text"],
//                        [TITLE_KEY:"信用卡後4碼",KEY_KEY:EXPIRE_AT_KEY,VALUE_KEY:card4No,SHOW_KEY:card4No,CELL_KEY:"text"]
//                    ]
//                }
//
//                popupTableView.reloadData()
//            }
//        }
    }
    
    @objc func panelCancelAction(){
        unmask()
    }
    
    @objc func unmask() {
        
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
    
    override func submitBtnPressed() {
        ecpay_token = orderTable!.ecpay_token
        toECPay()
    }
    
    override func backBtnPressed() {
        if order_token.count > 0 {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            OrderService.instance.ezshipReturnCode(token: order_token) { (success) in
                if (success) {
                    
                    let jsonData: Data = OrderService.instance.jsonData!
                    do {
                        let successTable: BackResTable = try JSONDecoder().decode(BackResTable.self, from: jsonData)
                        if !successTable.success {
                            var msg: String = "錯誤訊息：" + successTable.msg
                            if successTable.error_code.count > 0 {
                                msg += "\n" + "錯誤編號：" + successTable.error_code
                            }
                            self.info(msg)
                        } else {
                            var msg: String = "退貨編號：" + successTable.sn_id
                            if successTable.expire_at.count > 0 {
                                msg += "\n" + "錯誤編號：" + successTable.expire_at
                            }
                            self.info(msg)
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        ecpay_token = orderTable!.ecpay_token
        toECPay()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
}

class BackResTable: Codable {
    
    var success: Bool = false
    var msg: String = ""
    var sn_id: String = ""
    var expire_at: String = ""
    var order_id: Int = 0
    var error_code: String = ""
    var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case success
        case msg
        case sn_id
        case expire_at
        case order_id
        case error_code
        case url
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        sn_id = try container.decodeIfPresent(String.self, forKey: .sn_id) ?? ""
        expire_at = try container.decodeIfPresent(String.self, forKey: .expire_at) ?? ""
        order_id = try container.decodeIfPresent(Int.self, forKey: .order_id) ?? 0
        error_code = try container.decodeIfPresent(String.self, forKey: .error_code) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}
