//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import SCLAlertView

class AddCartVC: MyTableVC, ValueChangedDelegate {

    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var submitButton: SubmitButton!
    
    var product_token: String? = nil
    var cartItem_token: String? = nil
    var productTable: ProductTable? = nil
    var cartTable: CartTable? = nil
    var cartItemTable: CartItemTable? = nil
        
    var sub_total: Int = 0
    var shippingFee: Int = 0
    var total: Int = 0
    
    var selected_number: Int = 1
    var selected_price: Int = 0
    var selected_idx: Int = 0
    
    var bInit: Bool = false
    
    let heightForSection: CGFloat = 34
    
//    let productRows: [[String: String]] = [
//        ["title": "商品","key":PRODUCT_KEY,"value":"","show":"","cell":"text"]
//    ]
//
//    var attributeRows: [[String: String]] = [[String: String]]()
//
//    let amountRows: [[String: String]] = [
//        ["title":"數量","key":QUANTITY_KEY,"value":"","show":"","cell":"number"],
//        ["title":"小計","key":SUBTOTAL_KEY,"value":"","show":"","cell":"text"],
//        //["title":"運費","key":SHIPPING_FEE_KEY,"value":"","show":"","cell":"text"],
//        ["title":"總計","key":TOTAL_KEY,"value":"","show":"","cell":"text"]
//    ]
//
//    let contactRows: [[String: String]] = [
//        ["title":"姓名","key":NAME_KEY,"value":"","show":"","cell":"textField","keyboard":KEYBOARD.default.rawValue],
//        ["title":"行動電話","key":MOBILE_KEY,"value":"","show":"","cell":"textField","keyboard":KEYBOARD.numberPad.rawValue],
//        ["title":"EMail","key":EMAIL_KEY,"value":"","show":"","cell":"textField","keyboard":KEYBOARD.emailAddress.rawValue],
//        ["title":"住址","key":ADDRESS_KEY,"value":"","show":"","cell":"textField","keyboard":KEYBOARD.default.rawValue]
//    ]
    
    override func viewDidLoad() {
        
        myTablView = tableView
        
        //mySections = ["商品名稱", "商品選項", "款項", "寄件資料"]
        
//        mySections = [
//            ["name": "商品名稱", "isExpanded": true, "key": PRODUCT_KEY],
//            ["name": "商品選項", "isExpanded": true, "key": ATTRIBUTE_KEY],
//            ["name": "款項", "isExpanded": true, "key": AMOUNT_KEY]
//            //["name": "寄件資料", "isExpanded": true, "key": CONTACT_KEY]
//        ]
//
//        myRows = [
//            ["key":PRODUCT_KEY, "rows": productRows],
//            ["key":ATTRIBUTE_KEY, "rows": attributeRows],
//            ["key":AMOUNT_KEY, "rows": amountRows]
//            //["key":CONTACT_KEY, "rows": contactRows],
//        ]

        super.viewDidLoad()
        //print(superProduct)
        self.hideKeyboardWhenTappedAround()
        submitButton.setTitle("訂購")
        
        titleLbl.textColor = UIColor.black
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        //FormItemCellType.registerCell(for: tableView)
        
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
        
        let tagNib = UINib(nibName: "TagCell", bundle: nil)
        tableView.register(tagNib, forCellReuseIdentifier: "TagCell")
        
        let numberNib = UINib(nibName: "NumberCell", bundle: nil)
        tableView.register(numberNib, forCellReuseIdentifier: "NumberCell")
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "TextFieldCell")
        
        submitButton.setTitle("加入購物車")
        
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        shoppingCartBtn.visibility = .visible
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: view)
        page = 1
        
        if (product_token != nil) {
            let params: [String: String] = ["token": product_token!, "member_token": Member.instance.token]
            ProductService.instance.getOne(params: params) { (success) in
                if (success) {
                    
                    let jsonData: Data = ProductService.instance.jsonData!
                    do {
                        self.productTable = try JSONDecoder().decode(ProductTable.self, from: jsonData)
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                    self.initData()
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
        
        if (cartItem_token != nil) {
            
            submitButton.setTitle("更新購物車")
            
            let params: [String: String] = ["cart_item_token": cartItem_token!, "member_token": Member.instance.token]
            CartService.instance.getOne(params: params) { (success) in
                if (success) {
                    
                    let jsonData: Data = CartService.instance.jsonData!
                    do {
                        self.cartTable = try JSONDecoder().decode(CartTable.self, from: jsonData)
                        if (self.cartTable != nil) {
                            if (self.cartTable!.items.count > 0) {
                                self.cartItemTable = self.cartTable!.items[0]
                                self.cartItemTable?.filterRow()
                                self.productTable = self.cartItemTable!.product
                                self.productTable?.filterRow()
                            }
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                    self.initData()
                }

                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func initData() {
        
//        form = OrderForm(type: self.productTable!.type)
//        section_keys = form.getSectionKeys()
//        sections = form.getSections()
        
        if (productTable != nil) {
            
            titleLbl.text = productTable!.name
            
            var rows: [OneRow] = [OneRow]()
            var row: OneRow = OneRow(title: "商品", value: productTable!.name, show: productTable!.name, key: PRODUCT_KEY, cell: "text")
            rows.append(row)
            var section: OneSection = makeSectionRow(title: "商品名稱", key: PRODUCT_KEY, rows: rows)
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
                    if (cartItemTable != nil) {
                        for item_attributes in cartItemTable!.attributes {
                            for (_, value1) in item_attributes {
                                if (value1 == alias) {
                                    value = item_attributes["value"]!
                                    break
                                }
                            }
                        }
                    }
                    
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
            var quantity: String = "1"
            if (cartItemTable != nil) {
                quantity = String(cartItemTable!.quantity)
            }
            row = OneRow(title: "數量", value: quantity, show: "\(min),\(max)", key: QUANTITY_KEY, cell: "number")
            rows.append(row)
            row = OneRow(title: "小計", value: "", show: "", key: SUBTOTAL_KEY, cell: "text")
            rows.append(row)
            row = OneRow(title: "總計", value: "", show: "", key: TOTAL_KEY, cell: "text")
            rows.append(row)
            
            section = makeSectionRow(title: "款項", key: AMOUNT_KEY, rows: rows)
            oneSections.append(section)
            
            if (cartItemTable != nil) {
                selected_number = cartItemTable!.quantity
            }
            
            selected_price = productTable!.prices[selected_idx].price_member
            updateSubTotal()
    
        
            bInit = true
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (bInit) {
            //return mySections.count
            return oneSections.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count: Int = 0
        return oneSections[section].items.count
//        let mySection: [String: Any] = mySections[section]
//        if (mySection.keyExist(key: "isExpanded")) {
//            let isExpanded: Bool = mySection["isExpanded"] as? Bool ?? true
//            if (isExpanded) {
//                if let key: String = mySection["key"] as? String {
//                    let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
//                    count = rows.count
//                }
//            }
//        }
//
//        return count
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.white
//        headerView.tag = section
//
//        let titleLabel = UILabel()
//        titleLabel.text = getSectionName(idx: section)
//        titleLabel.textColor = UIColor.black
//        titleLabel.sizeToFit()
//        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
//        headerView.addSubview(titleLabel)
//
//        let isExpanded = getSectionExpanded(idx: section)
//        let mark = UIImageView(image: UIImage(named: "to_right"))
//        mark.frame = CGRect(x: view.frame.width-10-20, y: (heightForSection-20)/2, width: 20, height: 20)
//        toggleMark(mark: mark, isExpanded: isExpanded)
//        headerView.addSubview(mark)
//
//        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
//        headerView.addGestureRecognizer(gesture)
//
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = getOneRowFromIdx(indexPath.section, indexPath.row)
        let cell_type: String = row.cell
        
        if (cell_type == "tag") {
            if let cell: TagCell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as? TagCell {
                
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        } else if (cell_type == "number") {
            if let cell: NumberCell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as? NumberCell {
                
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                //cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: _value, min: min, max: max)
                return cell
            }
        } else if (cell_type == "text") {
            if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                
                cell.update(title: row.title, show: row.show)
                return cell
            }
        } else if (cell_type == "textField") {
            if let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell {
                
                //let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func updateSubTotal() {
        
        sub_total = selected_price * selected_number
        let row = getOneRowFromKey(SUBTOTAL_KEY)
        row.value = String(sub_total)
        row.show = "NT$ " + String(sub_total) + "元"
        
        updateTotal()
        //放入購物車，還不用計算運費
        //updateShippingFee()
    }
    
    func updateShippingFee() {
        
        if (productTable != nil) {
            shippingFee = productTable!.prices[selected_idx].shipping_fee
        }
        
//        if let priceItem = getFormItemFromKey(SHIPPING_FEE_KEY) {
//            //shippingFee = price
//            priceItem.value = String(shippingFee)
//            priceItem.make()
//        }
        
        updateTotal()
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
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        var params: [String: String] = [String: String]()
        
        params["device"] = "app"
        params["do"] = "update"
        params["member_token"] = Member.instance.token
        
        if (cartItem_token != nil) {
            params["cartItem_token"] = cartItem_token
        }
        if (productTable != nil) {
            params["product_id"] = String(productTable!.id)
            params["cart_token"] = productTable!.cart_token
        }
        params["price_id"] = String(productTable!.prices[selected_idx].id)
        
        params["member_id"] = String(Member.instance.id)
        
        params[QUANTITY_KEY] = getOneRowValue(QUANTITY_KEY)
        
        params[AMOUNT_KEY] = getOneRowValue(TOTAL_KEY)
        
        //是否有選擇商品屬性
        var isAttribute: Bool = true
        
        var selected_attributes: [String] = [String]()
        //let attributes: [[String: String]] = myRows[1]["rows"] as! [[String: String]]
        let rows: [OneRow] = getOneRowsFromSectionKey("attribute")
        
        for row in rows {
            
            if (row.value.count == 0) {
                isAttribute = false
                warning("請先選擇\(row.title)")
            } else {
                let value: String = "{name:\(row.title),alias:\(row.key),value:\(row.value)}"
                selected_attributes.append(value)
            }
        }
        
        if (isAttribute) {
            
            Global.instance.addSpinner(superView: self.view)
            params["attribute"] = selected_attributes.joined(separator: "|")
            //print(params)
            
            CartService.instance.update(params: params) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    var msg: String = ""
                    if (self.cartItem_token == nil) {
                        msg = "成功加入購物車了"
                        self.cartItemCount += 1
                        self.session.set("cartItemCount", self.cartItemCount)
                    } else {
                        msg = "已經更新購物車了"
                    }
                    //self.info(msg)
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert: SCLAlertView = SCLAlertView(appearance: appearance)
                    alert.addButton("前往購物車") {
                        self.toMemberCartList()
                    }
                    alert.addButton("繼續購物") {
                        self.toProduct()
                    }
                    alert.showSuccess("成功", subTitle: msg)
//                    self.info(msg: msg, showCloseButton: false, buttonTitle: "關閉") {
//                        self.toMemberCartList()
//                    }
                } else {
                    self.warning(CartService.instance.msg)
                }
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
}

