//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderVC: MyTableVC, ValueChangedDelegate {

    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var submitButton: SubmitButton!
    
    var product_token: String? = nil
    var productTable: ProductTable? = nil
    
    var cartsTable: CartsTable? = nil
    
    var cartTable: CartTable? = nil
    var cartItemsTable: [CartItemTable] = [CartItemTable]()
    
    var sub_total: Int = 0
    var shippingFee: Int = 0
    var total: Int = 0
    
    var selected_number: Int = 1
    var selected_price: Int = 0
    var selected_idx: Int = 0
    
    let heightForSection: CGFloat = 34
    
    var invoiceOptionRows: [OneRow] = [
        OneRow(title: "個人", value: "true", show: "", key: PERSONAL_KEY, cell: "radio"),
        OneRow(title: "公司", value: "false", show: "", key: COMPANY_KEY, cell: "radio")
    ]
    
    let invoicePersonalRows: [OneRow] = [
        OneRow(title: "EMail", value: "\(Member.instance.email)", show:"\(Member.instance.email)", key: INVOICE_EMAIL_KEY, cell:"textField")
    ]
    
    let invoiceCompanyRows: [OneRow] = [
        OneRow(title: "統一編編", value: "", show:"", key: INVOICE_COMPANY_TAX_KEY, cell: "textField"),
        OneRow(title: "公司行號抬頭", value: "", show:"", key :INVOICE_COMPANY_NAME_KEY, cell: "textField"),
        OneRow(title: "EMail", value: "\(Member.instance.email)", show: "\(Member.instance.email)", key: INVOICE_EMAIL_KEY, cell: "textField")
    ]
    
    var invoiceRows: [OneRow] = []
    
    var invoiceTable: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.estimatedRowHeight = 44
        cv.rowHeight = UITableView.automaticDimension
        
        cv.separatorStyle = .singleLine
        cv.separatorColor = UIColor.lightGray
        
        return cv
    }()
    let invoiceTableHeight: CGFloat = 180
    let blackViewHeight: CGFloat = 250
    let blackViewPaddingLeft: CGFloat = 20
    let cancelBtn: CancelButton = CancelButton()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        dataService = CartService.instance
        
        super.viewDidLoad()
        
        //print(superProduct)
        self.hideKeyboardWhenTappedAround()
        submitButton.setTitle("結帳")
        
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
        
        let cartListNib = UINib(nibName: "CartListCell", bundle: nil)
        tableView.register(cartListNib, forCellReuseIdentifier: "CartListCell")
        
        let radioNib = UINib(nibName: "RadioCell", bundle: nil)
        tableView.register(radioNib, forCellReuseIdentifier: "RadioCell")
        
//        let memoNib = UINib(nibName: "MemoCell", bundle: nil)
//        tableView.register(memoNib, forCellReuseIdentifier: "MemoCell")
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "TextFieldCell")
        
        let moreNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreNib, forCellReuseIdentifier: "MoreCell")
        
        let tagNib = UINib(nibName: "TagCell", bundle: nil)
        tableView.register(tagNib, forCellReuseIdentifier: "TagCell")
        
        let numberNib = UINib(nibName: "NumberCell", bundle: nil)
        tableView.register(numberNib, forCellReuseIdentifier: "NumberCell")
        
        let defaultNib = UINib(nibName: "DefaultCell", bundle: nil)
        tableView.register(defaultNib, forCellReuseIdentifier: "DefaultCell")
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        lists1.removeAll()
        getDataStart()
    }
    
    override func getDataStart(token: String? = nil, page: Int = 1, perPage: Int = PERPAGE) {

        Global.instance.addSpinner(superView: view)
        
        //單一品項購買，沒有使用購物車，直接結帳
        if product_token != nil {
            
            let params: [String: String] = ["token": product_token!, "member_token": Member.instance.token]
            ProductService.instance.getOne(params: params) { (success) in
                if (success) {
                    do {
                        if (ProductService.instance.jsonData != nil) {
                            self.jsonData = ProductService.instance.jsonData
                            try self.productTable = JSONDecoder().decode(ProductTable.self, from: self.jsonData!)
                            if (self.productTable != nil) {
                                self.getDataEnd(success: success)
                            }
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                    }
                    
                    //self.initData()
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
            
        } else {

            CartService.instance.getList(token: Member.instance.token, _filter: params, page: page, perPage: perPage) { (success) in
                if (success) {

                    do {
                        if (CartService.instance.jsonData != nil) {
                            self.jsonData = CartService.instance.jsonData
                            try self.tables = JSONDecoder().decode(CartsTable.self, from: self.jsonData!)
                            if (self.tables != nil) {
                                self.getDataEnd(success: success)
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                    }

                    Global.instance.removeSpinner(superView: self.view)
                } else {
                    Global.instance.removeSpinner(superView: self.view)
                    self.warning(self.dataService.msg)
                }
            }
        }
    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                cartsTable = try JSONDecoder().decode(CartsTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        
        var amount: Int = 0
        if productTable != nil {
            amount += productTable!.prices[0].price_member
            
            for attribute in productTable!.attributes {
                var tmp: String = attribute.attribute
                tmp = tmp.replace(target: "{", withString: "")
                tmp = tmp.replace(target: "}", withString: "")
                tmp = tmp.replace(target: "\"", withString: "")
                
                //print(arr)
                let row = ["title":attribute.name,"key":attribute.alias,"value":"","show":tmp,"cell":"tag"]
                //attributeRows.append(row)
            }
        } else if cartsTable != nil {
        
            if (cartsTable!.rows.count != 1) {
                warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
            } else {
                
                //product cell
                
                cartTable = cartsTable!.rows[0]
                cartItemsTable = cartTable!.items
                for cartItemTable in cartItemsTable {
                    
                    cartItemTable.filterRow()
                    amount += cartItemTable.amount
                    
                    productTable = cartItemTable.product
                    
                    var attribute_text: String = ""
                    if (cartItemTable.attributes.count > 0) {

                        for (idx, attribute) in cartItemTable.attributes.enumerated() {
                            attribute_text += attribute["name"]! + ":" + attribute["value"]!
                            if (idx < cartItemTable.attributes.count - 1) {
                                attribute_text += " | "
                            }
                        }
                    }
                }
            }
        }
        initData()
    }
    
    override func getDataEnd(success: Bool) {

        if (jsonData != nil) {
            genericTable()
            
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        } else {
            warning("沒有取得回傳的json字串，請洽管理員")
        }
        Global.instance.removeSpinner(superView: view)
    }
    
    func initData() {
        
        var amount: Int = 0
        var rows: [OneRow] = [OneRow]()
        var needShipping: Bool = true
        
        var section = makeSectionRow()
        var row = OneRow()
        
        if (cartItemsTable.count > 0) {
        
            rows.removeAll()
            for cartItemTable in cartItemsTable {
                
                cartItemTable.filterRow()
                amount += cartItemTable.amount
                productTable = cartItemTable.product
                
                var attribute_text: String = ""
                if (cartItemTable.attributes.count > 0) {
                    
                    for (idx, attribute) in cartItemTable.attributes.enumerated() {
                        attribute_text += attribute["name"]! + ":" + attribute["value"]!
                        if (idx < cartItemTable.attributes.count - 1) {
                            attribute_text += " | "
                        }
                    }
                }
                
                row = OneRow(title: productTable!.name, key: PRODUCT_KEY, cell: "cart")
                row.featured_path = productTable!.featured_path
                row.attribute = attribute_text
                row.amount = cartItemTable.amount_show
                row.quantity = String(cartItemTable.quantity)
                
                rows.append(row)
            }
            section = makeSectionRow(title: "商品選項", key: PRODUCT_KEY, rows: rows)
            oneSections.append(section)
            
            //price
            rows.removeAll()
            let amount_show: String = amount.formattedWithSeparator
            row = OneRow(title: "商品金額", value: String(amount), show: "NT$ \(amount_show)", key: AMOUNT_KEY, cell: "text")
            rows.append(row)
            
            var shipping_fee: Int = 0
            if (amount > 1000) {shipping_fee = 0}
            let shipping_fee_show: String = shipping_fee.formattedWithSeparator
            row = OneRow(title: "運費", value: String(shipping_fee), show: "NT$ \(shipping_fee_show)", key: SHIPPING_FEE_KEY, cell: "text")
            rows.append(row)
            
            let tax: Int = 0
            let tax_show: String = tax.formattedWithSeparator
            row = OneRow(title: "税", value: String(tax), show: "NT$ \(tax_show)", key: TAX_KEY, cell: "text")
            rows.append(row)
            
            let total: Int = amount + shipping_fee + tax
            let total_show: String = total.formattedWithSeparator
            row = OneRow(title: "總金額", value: String(total), show: "NT$ \(total_show)", key: TOTAL_KEY, cell: "text")
            rows.append(row)
            
            section = makeSectionRow(title: "金額", key: AMOUNT_KEY, rows: rows)
            oneSections.append(section)
        } else if (productTable != nil) {
            productTable!.filterRow()
            amount += productTable!.prices[0].price_member
            if (productTable!.type == "coin") {
                needShipping = false
            }
            
            row = OneRow(title: productTable!.name, key: PRODUCT_KEY, cell: "default")
            row.featured_path = productTable!.featured_path
            //row.attribute = attribute_text
            row.amount = "NT$" + String(amount)
            row.quantity = "1"
            
            rows.append(row)
            section = makeSectionRow(title: "商品名稱", key: PRODUCT_KEY, rows: rows)
            oneSections.append(section)
            
            if productTable!.attributes.count > 0 {
                rows.removeAll()
                for attribute in productTable!.attributes {
                    var tmp: String = attribute.attribute
                    tmp = tmp.replace(target: "{", withString: "")
                    tmp = tmp.replace(target: "}", withString: "")
                    tmp = tmp.replace(target: "\"", withString: "")
                    
                    //show is 湖水綠,極致黑,經典白,太空灰
                    //name is 顏色
                    //key is color
                    var value: String = ""
                    let alias: String = attribute.alias
                    
                    row = OneRow(title: attribute.name, value: value, show: tmp, key: alias, cell: "tag")
                    rows.append(row)
                    //let row = ["title":attribute.name,"key":alias,"value":value,"show":tmp,"cell":"tag"]
                    //attributeRows.append(row)
                }
                section = makeSectionRow(title: "商品選項", key: ATTRIBUTE_KEY, rows: rows)
                oneSections.append(section)
            }
            
            rows.removeAll()
            let min: String = String(productTable!.order_min)
            let max: String = String(productTable!.order_max)
            let quantity: String = "1"
            row = OneRow(title: "數量", value: quantity, show: "\(min),\(max)", key: QUANTITY_KEY, cell: "number")
            rows.append(row)
            row = OneRow(title: "小計", value: "", show: "", key: SUBTOTAL_KEY, cell: "text")
            rows.append(row)
            row = OneRow(title: "總計", value: "", show: "", key: TOTAL_KEY, cell: "text")
            rows.append(row)
            
            section = makeSectionRow(title: "款項", key: AMOUNT_KEY, rows: rows)
            oneSections.append(section)
            
            selected_price = productTable!.prices[selected_idx].price_member
            updateSubTotal()
        }

        //oneSections.append(section)
        
        //gateway
        rows.removeAll()
        let gateway: String = productTable!.gateway
        var arr: [String] = gateway.components(separatedBy: ",")
        for tmp in arr {
            let title: String = GATEWAY.getRawValueFromString(tmp)
            var value: String = "false"
            if (tmp == "credit_card") {
                value = "true"
            }
            row = OneRow(title: title, value: value, show: title, key: tmp, cell: "radio")
            rows.append(row)
        }
        section = makeSectionRow(title: "付款方式", key: GATEWAY_KEY, rows: rows)
        oneSections.append(section)
        
        if (needShipping) {
            //shipping
            rows.removeAll()
            let shipping: String = productTable!.shipping
            arr = shipping.components(separatedBy: ",")
            for tmp in arr {
                let title: String = SHIPPING_WAY.getRawValueFromString(tmp)
                var value: String = "false"
                if (tmp == "direct") {
                    value = "true"
                }
                row = OneRow(title: title, value: value, show: title, key: tmp, cell: "radio")
                rows.append(row)
            }
            section = makeSectionRow(title: "到貨方式", key: SHIPPING_KEY, rows: rows)
            oneSections.append(section)
        }
        
        rows.removeAll()
        row = OneRow(title: "發票(目前僅提供電子發票)", value: INVOICE_PERSONAL_KEY, show: "個人", key: INVOICE_KEY, cell: "more")
        rows.append(row)
        rows.append(contentsOf: invoicePersonalRows)
        section = makeSectionRow(title: "電子發票", key: INVOICE_KEY, rows: rows)
        oneSections.append(section)
        
        if (needShipping) {
            //member
            rows.removeAll()
            row = OneRow(title: "姓名", value: Member.instance.name, show: Member.instance.name, key: NAME_KEY, cell: "textField", placeholder: "王大明")
            rows.append(row)
            row = OneRow(title: "電話", value: Member.instance.mobile, show: Member.instance.mobile, key: MOBILE_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "0939123456")
            rows.append(row)
            row = OneRow(title: "EMail", value: Member.instance.email, show: Member.instance.email, key: EMAIL_KEY, cell: "textField", keyboard: KEYBOARD.emailAddress, placeholder: "service@bm.com")
            rows.append(row)
            row = OneRow(title: "住址", value: Member.instance.address, show: Member.instance.address, key: ADDRESS_KEY, cell: "textField", placeholder: "台北市信義區中山路60號")
            rows.append(row)
            section = makeSectionRow(title: "收件人資料", key: MEMBER_KEY, rows: rows)
            oneSections.append(section)
            //memo
            rows.removeAll()
            row = OneRow(title: "留言", value: "", show: "", key: MEMO_KEY, cell: "textField", placeholder: "請於上班時間送達")
            rows.append(row)
            section = makeSectionRow(title: "其他留言", key: MEMO_KEY, rows: rows)
            oneSections.append(section)
        }
        
        tableView.reloadData()
    }
    
    func updateSubTotal() {
        
        sub_total = selected_price * selected_number
        let row = getOneRowFromKey(SUBTOTAL_KEY)
        row.value = String(sub_total)
        row.show = "NT$ " + String(sub_total) + "元"
        
        updateTotal()
        //放入購物車，還不用計算運費
        //updateShippingFee()
    }
    
    func updateTotal() {
        
        total = sub_total + shippingFee
        
        let row = getOneRowFromKey(TOTAL_KEY)
        row.value = String(total)
        row.show = "NT$ " + String(total) + "元"
        
        tableView.reloadData()
    }
    
    override func cellSetTag(sectionIdx: Int, rowIdx: Int, value: String, isChecked: Bool) {
        let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
        if (isChecked) {
            row.value = value
        }
    }
    
    override func cellNumberChanged(sectionIdx: Int, rowIdx: Int, number: Int) {
        let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = String(number)
        selected_number = number
        updateSubTotal()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (tableView == invoiceTable) {
            return 1
        } else {
            return oneSections.count
            //return mySections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if (tableView == invoiceTable) {
            count = invoiceOptionRows.count
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
        
        if (tableView == invoiceTable) {
            return UIView()
        } else {
        
            let headerView = UIView()
            headerView.backgroundColor = UIColor.gray
            headerView.tag = section
            
            let titleLabel = UILabel()
            titleLabel.text = oneSections[section].title
            //titleLabel.text = getSectionName(idx: section)
            titleLabel.textColor = UIColor(MY_WHITE)
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
            headerView.addSubview(titleLabel)
            
            var expanded_image: String = "to_right_w"
            if oneSections[section].isExpanded {
                expanded_image = "to_down_w"
            }
            let mark = UIImageView(image: UIImage(named: expanded_image))
            //mark.frame = CGRect(x: view.frame.width-10-20, y: (34-20)/2, width: 20, height: 20)
            headerView.addSubview(mark)
            
            mark.translatesAutoresizingMaskIntoConstraints = false
            
            mark.centerYAnchor.constraint(equalTo: mark.superview!.centerYAnchor).isActive = true
            mark.widthAnchor.constraint(equalToConstant: 20).isActive = true
            mark.heightAnchor.constraint(equalToConstant: 20).isActive = true
            mark.trailingAnchor.constraint(equalTo: mark.superview!.trailingAnchor, constant: -16).isActive = true
                        
            let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
            headerView.addGestureRecognizer(gesture)
            
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == invoiceTable) {
            if let cell: RadioCell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as? RadioCell {
                
                let row: OneRow = invoiceOptionRows[indexPath.row]
                cell.cellDelegate = self
                cell.update(sectionKey: INVOICE_TYPE_KEY, sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                
                //cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        } else {
            
            let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
            
            if (row.cell == "cart") {
                if let cell: CartListCell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {

                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    return cell
                }
            } else if (row.cell == "radio") {
                if let cell: RadioCell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as? RadioCell {
                    
                    cell.cellDelegate = self
                    cell.update(sectionKey: oneSections[indexPath.section].key, sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    return cell
                }
            } else if (row.cell == "text") {
                
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    
                    cell.update(title: row.title, show: row.show)
                    return cell
                }
            } else if (row.cell == "textField") {
                
                if let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell {
                    
                    //let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    return cell
                }
            } else if (row.cell == "more") {
                if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as? MoreCell {
                    
                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    return cell
                }
            } else if (row.cell == "tag") {
                if let cell: TagCell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as? TagCell {
                    
                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    return cell
                }
            } else if (row.cell == "number") {
                if let cell: NumberCell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as? NumberCell {
                    
                    cell.cellDelegate = self
                    cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                    //cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: _value, min: min, max: max)
                    return cell
                }
            } else if (row.cell == "default") {
                if let cell: DefaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as? DefaultCell {
                    cell.update(featured_path: row.featured_path, title: row.title)
                    
                    return cell
                }
            }
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == invoiceTable) {
            
            let row: OneRow = invoiceOptionRows[indexPath.row]
            let checked: Bool = Bool(row.value)!
            cellRadioChanged(key: INVOICE_TYPE_KEY, sectionIdx: indexPath.section, rowIdx: indexPath.row, isChecked: !checked)
            //let rowKey: String = invoiceOptionRows[indexPath.row]["key"]!
            //let checked: Bool = Bool(invoiceOptionRows[indexPath.row]["value"]!)!
            //radioDidChange(sectionKey: INVOICE_KEY, rowKey: rowKey, checked: !checked)
        } else {
            //var rowKey: String = ""
            let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
            
            if (row.cell == "more") {
                
                maskView = view.mask()
                
                let frame: CGRect = CGRect(x:blackViewPaddingLeft, y:(maskView.frame.height-blackViewHeight)/2, width:maskView.frame.width-(2*blackViewPaddingLeft), height:blackViewHeight)
                blackView.frame = frame
                blackView.backgroundColor = UIColor.black
                maskView.addSubview(blackView)
                
//                let gesture = UITapGestureRecognizer(target: self, action: #selector(unmask))
//                gesture.cancelsTouchesInView = false
//                maskView.addGestureRecognizer(gesture)
                
                addInvoiceSelectView()
                addCancelBtn()
            } else if (row.cell == "radio") {
                let checked: Bool = Bool(row.value)!
                cellRadioChanged(key: row.key, sectionIdx: indexPath.section, rowIdx: indexPath.row, isChecked: !checked)
            }
        }
    }
    
    
    @objc func unmask(){

        maskView.unmask()
    }
    
    func addInvoiceSelectView() {
        
        //let frame = view.frame
        invoiceTable.frame = CGRect(x: 0, y: 0, width: blackView.frame.width, height: invoiceTableHeight)
        
        invoiceTable.dataSource = self
        invoiceTable.delegate = self
        invoiceTable.isUserInteractionEnabled = true
        
        invoiceTable.backgroundColor = .clear
        
        blackView.addSubview(invoiceTable)
        
        let radioNib = UINib(nibName: "RadioCell", bundle: nil)
        invoiceTable.register(radioNib, forCellReuseIdentifier: "RadioCell")
    }
    
    func addCancelBtn() {
        
        blackView.addSubview(cancelBtn)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: cancelBtn, attribute: .top, relatedBy: .equal, toItem: invoiceTable, attribute: .bottom, multiplier: 1, constant: 12)
//        var offset:CGFloat = 0
//        if btnCount == 2 {
//            offset = 60
//        }
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: cancelBtn, attribute: .centerX, relatedBy: .equal, toItem: cancelBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        blackView.addConstraints([c1,c2])
        
        cancelBtn.addTarget(self, action: #selector(unmask), for: .touchUpInside)
        self.cancelBtn.isHidden = false
    }
    
//    func updateSubTotal() {
//        if let priceItem = getFormItemFromKey(SUBTOTAL_KEY) {
//            sub_total = selected_price * selected_number
//            priceItem.value = String(sub_total)
//            priceItem.make()
//            updateShippingFee()
//            //updateTotal()
//        }
//    }
//    
//    func updateShippingFee() {
//        shippingFee = productTable!.prices[selected_idx].shipping_fee
//        if let priceItem = getFormItemFromKey(SHIPPING_FEE_KEY) {
//            //shippingFee = price
//            priceItem.value = String(shippingFee)
//            priceItem.make()
//            updateTotal()
//        }
//    }
//    
//    func updateTotal() {
//        if let priceItem = getFormItemFromKey(TOTAL_KEY) {
//            total = sub_total + shippingFee
//            priceItem.value = String(total)
//            priceItem.make()
//            tableView.reloadData()
//        }
//    }
    
//    func tagChecked(checked: Bool, name: String, key: String, value: String) {
//
//        if name == "type" {
//            let id: Int = Int(key)!
//            //print(id)
//            var idx: Int = 0
//            for price in productTable!.prices {
//                if price.id == id {
//                    selected_price = price.price_member
//                    self.selected_idx = idx
//                    updateSubTotal()
//                    break
//                }
//                idx = idx + 1
//            }
//        }
//    }
    
//    func stepperValueChanged(number: Int, name: String) {
        //move to cell to implement
//        let item = getFormItemFromKey(name)
//        item?.value = String(number)
//        var idx: Int = 0
//
//        if let _formItem: TagFormItem = getFormItemFromKey("type") as? TagFormItem {
//            idx = _formItem.selected_idxs[0]
//        }
        
//        selected_number = number
//        updateSubTotal()
        
        //let price: Int = number * Int(superProduct.prices.price_dummy)
        //updateSubTotal(price: price)
//    }
    
    //the key is section key not row key
    override func cellRadioChanged(key: String, sectionIdx: Int, rowIdx: Int, isChecked: Bool) {
        
        //點選發票選項
        invoiceRows.removeAll()
        var rows: [OneRow] = [OneRow]()
        if (key == INVOICE_TYPE_KEY) {
            rows = invoiceOptionRows
            
            var idx1: Int = 0
            for (idx, row) in rows.enumerated() {
                if (idx == rowIdx) {
                    row.value = String(isChecked)
                    idx1 = idx
                } else {
                    row.value = String(!isChecked)
                }
            }
            
            let section: OneSection = getOneSectionFromKey(INVOICE_KEY)
            section.items.removeAll()
            let row = OneRow(title: "發票(目前僅提供電子發票)", value: "", show: "", key: INVOICE_KEY, cell: "more")
            section.items.append(row)
            if (idx1 == 0) {
                section.items.append(contentsOf: invoicePersonalRows)
                row.value = INVOICE_PERSONAL_KEY
            } else {
                section.items.append(contentsOf: invoiceCompanyRows)
                row.value = INVOICE_COMPANY_KEY
            }
            
            invoiceTable.reloadData()
            unmask()
        } else {
            let section: OneSection = oneSections[sectionIdx]
            rows = section.items
            
            for (idx, row) in rows.enumerated() {
                if (idx == rowIdx) {
                    row.value = String(isChecked)
                } else {
                    row.value = String(!isChecked)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func cellTextChanged(sectionIdx: Int, rowIdx: Int, str: String) {
        
        let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = str
        row.show = str
    }
    
    override func cellClear(sectionIdx: Int, rowIdx: Int) {
        let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = ""
        row.show = ""
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        Global.instance.addSpinner(superView: self.view)
        var params: [String: String] = [String: String]()
        
        params["device"] = "app"
        params["do"] = "update"
        if (cartsTable != nil) {
            params["cart_id"] = String(cartTable!.id)
        }
        
        params[AMOUNT_KEY] = getOneRowValue(AMOUNT_KEY)
        params[SHIPPING_FEE_KEY] = getOneRowValue(SHIPPING_FEE_KEY)
        params[TAX_KEY] = getOneRowValue(TAX_KEY)
        params[TOTAL_KEY] = getOneRowValue(TOTAL_KEY)
        params[DISCOUNT_KEY] = "0"
        
        var discount: Int = 0
        if let tmp: Int = Int(params[DISCOUNT_KEY]!) {
            discount = tmp
        }
        var total: Int = 0
        if let tmp: Int = Int(params[TOTAL_KEY]!) {
            total = tmp
        }
        params[GRAND_TOTAL_KEY] = String(discount + total)
        
        //是否有選擇商品屬性
        var rows: [OneRow] = getOneRowsFromSectionKey("attribute")
        if (rows.count > 0) {
        
            var selected_attributes: [String] = [String]()
            //let attributes: [[String: String]] = myRows[1]["rows"] as! [[String: String]]
            
            for row in rows {
                
                if (row.value.count == 0) {
                    warning("請先選擇\(row.title)")
                } else {
                    let value: String = "{name:\(row.title),alias:\(row.key),value:\(row.value)}"
                    selected_attributes.append(value)
                }
            }
            params["attribute"] = selected_attributes.joined(separator: "|")
        }
        
        rows = getOneRowsFromSectionKey(GATEWAY_KEY)
        for row in rows {
            if (row.value == "true") {
                params[GATEWAY_KEY] = row.key
            }
        }
        
        rows = getOneRowsFromSectionKey(SHIPPING_KEY)
        for row in rows {
            if (row.value == "true") {
                params[SHIPPING_KEY] = row.key
            }
        }
        
        //直接購買會執行的區塊
        if (productTable != nil && cartsTable == nil) {
            params["product_id"] = String(productTable!.id)
            params[QUANTITY_KEY] = getOneRowValue(QUANTITY_KEY)
            params[AMOUNT_KEY] = String(productTable!.prices[selected_idx].price_member * Int(params[QUANTITY_KEY]!)!)
        }
        
        //invoice
        rows = getOneRowsFromSectionKey(INVOICE_KEY)
        let invoice_type: String = (rows[0].value == INVOICE_PERSONAL_KEY) ? "personal" : "company"
        params[INVOICE_TYPE_KEY] = invoice_type
        if (invoice_type == INVOICE_COMPANY_KEY) {
            params[INVOICE_COMPANY_TAX_KEY] = getOneRowValue(INVOICE_COMPANY_TAX_KEY)
            params[INVOICE_COMPANY_NAME_KEY] = getOneRowValue(INVOICE_COMPANY_NAME_KEY)
        }
        params[INVOICE_EMAIL_KEY] = getOneRowValue(INVOICE_EMAIL_KEY)
        
        params["member_id"] = String(Member.instance.id)
        params["order_name"] = getOneRowValue(NAME_KEY)
        params["order_tel"] = getOneRowValue(MOBILE_KEY)
        params["order_email"] = getOneRowValue(EMAIL_KEY)
        params["order_address"] = getOneRowValue(ADDRESS_KEY)
        
        params[MEMO_KEY] = getOneRowValue(MEMO_KEY)
        
        OrderService.instance.update(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                
                self.jsonData = OrderService.instance.jsonData
                //print(self.jsonData.)
                do {
                    if (self.jsonData != nil) {
                        let table: OrderUpdateResTable = try JSONDecoder().decode(OrderUpdateResTable.self, from: self.jsonData!)
                        if (!table.success) {
                            self.warning(table.msg)
                        } else {
                            let orderTable: OrderTable? = table.model
                            if (orderTable != nil) {
                                self.cartItemCount = 0
                                self.session.set("cartItemCount", self.cartItemCount)
                                
                                let ecpay_token: String = orderTable!.ecpay_token
                                let ecpay_token_ExpireDate: String = orderTable!.ecpay_token_ExpireDate
                                self.info(msg: "訂單已經成立，是否前往結帳？", showCloseButton: true, buttonTitle: "結帳") {
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
                }
                
//                let order_token: String = OrderService.instance.order_token
//                if self.total > 0 {
//                    let ecpay_token: String = OrderService.instance.ecpay_token
//                    let tokenExpireDate: String = OrderService.instance.tokenExpireDate
//                    self.info(msg: "訂單已經成立，是否前往結帳？", showCloseButton: true, buttonTitle: "結帳") {
//                        //print("aaa")
//                        self.toPayment(order_token: order_token, ecpay_token: ecpay_token, tokenExpireDate: tokenExpireDate)
//                    }
//                } else {
//                    self.info(msg: "訂單已經成立，結帳金額為零，我們會儘速處理您的訂單", buttonTitle: "關閉") {
//                        self.toPayment(order_token: order_token)
//                    }
//                }
            } else {
                self.warning(OrderService.instance.msg)
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
}

class OrderUpdateResTable: Codable {
    
    var success: Bool = false
    var msg: String = ""
    var id: Int = 0
    var update: String = "INSERT"
    var model: OrderTable?
    
    enum CodingKeys: String, CodingKey {
        case success
        case msg
        case id
        case update
        case model
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        update = try container.decodeIfPresent(String.self, forKey: .update) ?? ""
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        model = try container.decodeIfPresent(OrderTable.self, forKey: .model) ?? nil
    }
}
