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
    var source: String = "order"
    
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
    var complete_at: String = ""
    
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
        
        if ecpay_token.count > 0 {
            bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
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
                        self.complete_at = tmp.toString(format: "yyyy-MM-dd HH:mm:ss")
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
                //print(state)
                if (state.callbackStateMessage == "Pay Fail.") {
                    self.msg = "付款失敗，有可能是信用卡刷卡錯誤，請檢查信用卡資訊是否有誤"
                } else {
                    self.msg = state.callbackStateMessage
                }
                self.warning(msg: self.msg, buttonTitle: "關閉", buttonAction: {
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
                    //print(jsonData.prettyPrintedJSONString)
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
        
        //1.信用卡回傳，(1)刷卡時間，(2)處理費，(3)信用卡前6碼，(4)信用卡後4碼
        //2.超商代碼回傳，(1)代碼，(2)代碼檢視網址
        //3.barcode已經停止使用
        //4.虛擬匯款帳號，(1)銀行代號，(2)銀行帳號
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
            params["complete_at"] = complete_at
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
        
        orderTable!.filterRow()
        
        if (orderTable!.all_process > 1) {//已經付費了
            //bottomThreeView.isHidden = true
            //dataContainer.translatesAutoresizingMaskIntoConstraints = false
            //dataContainer.bottomAnchor.constraint(equalTo: dataContainer.superview!.bottomAnchor, constant: 0).isActive = true
            bottomThreeView.submitButton.isHidden = true
            
            if (!orderTable!.canReturn) {
                bottomThreeView.threeButton.isHidden = true
            }
            
            if (source == "member") {
                bottomThreeView.cancelButton.setTitle("上一頁")
            } else if (source == "order") {
                bottomThreeView.cancelButton.setTitle("結束")
            } else {
                bottomThreeView.cancelButton.setTitle("取消")
            }
        }
        
        if (!orderTable!.canReturn) {
            bottomThreeView.threeButton.isHidden = true
        }
        
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
        
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
        }
        
        var section = makeSectionRow(title: "商品", key: PRODUCT_KEY, rows: rows)
        oneSections.append(section)
        
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
        
        //gateway
        rows.removeAll()
        row = OneRow(title: "付款方式", value: orderTable!.gateway!.method, show: orderTable!.gateway!.method_show, key: GATEWAY_METHOD_KEY, cell: "more", isClear: false)
        rows.append(row)
        row = OneRow(title: "付款狀態", value: orderTable!.gateway!.process, show: orderTable!.gateway!.process_show, key: GATEWAY_PROCESS_KEY, cell: "text")
        rows.append(row)
        row = OneRow(title: "付款時間", value: orderTable!.gateway!.complete_at, show: orderTable!.gateway!.complete_at_show, key: GATEWAY_AT_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "付款方式", key: GATEWAY_KEY, rows: rows)
        oneSections.append(section)
        
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
        if (orderTable!.shipping!.return_at.count > 0) {
            row = OneRow(title: "退貨時間", value: orderTable!.shipping!.return_at, show: orderTable!.shipping!.return_at_show, key: SHIPPING_RETURN_AT_KEY, cell: "text")
            rows.append(row)
        }
        section = makeSectionRow(title: "到貨方式", key: SHIPPING_KEY, rows: rows)
        oneSections.append(section)
        
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
        
        //memo
        rows.removeAll()
        row = OneRow(title: "其他留言", value: orderTable!.memo, show: orderTable!.memo, key: MEMO_KEY, cell: "text")
        rows.append(row)
        section = makeSectionRow(title: "其他留言", key: MEMO_KEY, rows: rows)
        oneSections.append(section)
        
        //退貨
        if orderTable!.canReturn && orderTable!.return != nil {
            rows.removeAll()
            row = OneRow(title: "退貨編號", value: orderTable!.return!.sn_id,show: orderTable!.return!.sn_id, key: RETURN_SN_ID_KEY, cell: "text")
            rows.append(row)
            row = OneRow(title: "編號到期時間", value: orderTable!.return!.expire_at, show: orderTable!.return!.expire_at_show, key: RETURN_EXPIRE_AT_KEY, cell: "text")
            rows.append(row)
            row = OneRow(title: "退貨時間", value: orderTable!.return!.created_at, show: orderTable!.return!.created_at_show, key: RETURN_CREATED_AT_KEY, cell: "text")
            rows.append(row)
            section = makeSectionRow(title: "退貨", key: RETURN_KEY, rows: rows)
            oneSections.append(section)
        }
        
        tableView.reloadData()
    }
    
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
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                } else if (method == GATEWAY.store_pay_711) {
                    if (orderTable!.shipping != nil) {
                        let CVSPaymentNo: String = orderTable!.shipping!.CVSPaymentNo
                        let CVSValidationNo: String = orderTable!.shipping!.CVSValidationNo
                        let paymentNo: String = CVSPaymentNo + CVSValidationNo
                        popupRows = [
                            OneRow(title: "代碼", value: paymentNo, show: paymentNo, key: PAYMENT_NO_KEY, cell: "text")
                            ]
                    }
                } else if (method == GATEWAY.store_pay_family) {
                    if (orderTable!.shipping != nil) {
                        let paymentNo: String = orderTable!.shipping!.BookingNote
                        popupRows = [
                            OneRow(title: "代碼", value: paymentNo, show: paymentNo, key: PAYMENT_NO_KEY, cell: "text")
                            ]
                    }
                }
                popupTableView.reloadData()
            }
        }
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
    
    override func prev() {
        if (source == "member") {
            super.prev()
        } else if (source == "order") {
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            super.prev()
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
