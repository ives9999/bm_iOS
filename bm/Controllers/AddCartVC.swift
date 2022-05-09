//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

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
            
//            var row = getRowRowsFromMyRowsByKey1(key: PRODUCT_KEY)
//            row["value"] = productTable!.name
//            row["show"] = productTable!.name
//            replaceRowByKey(rowKey: PRODUCT_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: NAME_KEY)
//        row["value"] = Member.instance.name
//        row["show"] = Member.instance.name
//        replaceRowByKey(rowKey: NAME_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: MOBILE_KEY)
//        row["value"] = Member.instance.mobile
//        row["show"] = Member.instance.mobile
//        replaceRowByKey(rowKey: MOBILE_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: EMAIL_KEY)
//        row["value"] = Member.instance.email
//        row["show"] = Member.instance.email
//        replaceRowByKey(rowKey: EMAIL_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: ADDRESS_KEY)
//        row["value"] = Member.instance.address
//        row["show"] = Member.instance.address
//        replaceRowByKey(rowKey: ADDRESS_KEY, _row: row)
        
            
//            for attribute in productTable!.attributes {
//                var tmp: String = attribute.attribute
//                tmp = tmp.replace(target: "{", withString: "")
//                tmp = tmp.replace(target: "}", withString: "")
//                tmp = tmp.replace(target: "\"", withString: "")
//
//                //show is 湖水綠,極致黑,經典白,太空灰
//                //name is 顏色
//                //key is color
//                var value: String = ""
//                let alias: String = attribute.alias
//                if (cartItemTable != nil) {
//                    for item_attributes in cartItemTable!.attributes {
//                        for (_, value1) in item_attributes {
//                            if (value1 == alias) {
//                                value = item_attributes["value"]!
//                                break
//                            }
//                        }
//                    }
//                }
//
//                let row = ["title":attribute.name,"key":alias,"value":value,"show":tmp,"cell":"tag"]
//                attributeRows.append(row)
//            }
//            //print(attributeRows)
//            myRows[1]["rows"] = attributeRows
            
//            row = getRowRowsFromMyRowsByKey1(key: QUANTITY_KEY)
//            let min: String = String(productTable!.order_min)
//            let max: String = String(productTable!.order_max)
//            row["show"] = "\(min),\(max)"
//            row["value"] = "1"
//
//            if (cartItemTable != nil) {
//                selected_number = cartItemTable!.quantity
//                row["value"] = String(selected_number)
//            }
//            replaceRowByKey(rowKey: QUANTITY_KEY, _row: row)
        
//        row = getRowRowsFromMyRowsByKey1(key: SHIPPING_FEE_KEY)
//        row["value"] = String(productTable!.prices[selected_idx].shipping_fee)
//        row["show"] = "NT$ " + String(productTable!.prices[selected_idx].shipping_fee) + "元"
//        replaceRowByKey(rowKey: SHIPPING_FEE_KEY, _row: row)
        
        
//        if let productNameItem = getFormItemFromKey("Product_Name") {
//            productNameItem.value = productTable!.name
//            productNameItem.make()
//        }
//
//        if let nameItem = getFormItemFromKey(NAME_KEY) {
//            nameItem.value = Member.instance.name
//            nameItem.make()
//        }
//
//        if let mobileItem = getFormItemFromKey(MOBILE_KEY) {
//            mobileItem.value = Member.instance.mobile
//            mobileItem.make()
//        }
//
//        if let emailItem = getFormItemFromKey(EMAIL_KEY) {
//            emailItem.value = Member.instance.email
//            emailItem.make()
//        }
//
//        if let addressItem = getFormItemFromKey(ADDRESS_KEY) {
//            addressItem.value = Member.instance.road
//            addressItem.make()
//        }
//
//        if let numberItem = getFormItemFromKey(NUMBER_KEY) as? NumberFormItem {
//            numberItem.min = productTable!.order_min
//            numberItem.max = productTable!.order_max
//        }
        
//        if let colorItem = getFormItemFromKey(COLOR_KEY) as? Color1FormItem {
//            var res: [[String: String]] = [[String: String]]()
//            for color in productTable!.colors {
//                let dict: [String: String] = [color: color]
//                res.append(dict)
//            }
//            colorItem.setTags(tags: res)
//            //print(superProduct.color)
//        }
//
//        if let clothesSizeItem = getFormItemFromKey(CLOTHES_SIZE_KEY) as? ClothesSizeFormItem {
//
//            var res: [[String: String]] = [[String: String]]()
//
//            for size in productTable!.sizes {
//                let dict: [String: String] = [size: size]
//                res.append(dict)
//            }
//            clothesSizeItem.setTags(tags: res)
//        }
//
//        if let weightItem = getFormItemFromKey(WEIGHT_KEY) as? WeightFormItem {
//
//            var res: [[String: String]] = [[String: String]]()
//            for size in productTable!.weights {
//                let dict: [String: String] = [size: size]
//                res.append(dict)
//            }
//            weightItem.setTags(tags: res)
//        }
        
//            if productTable!.type == "mejump" {
//                if let typeItem = getFormItemFromKey("type") as? TagFormItem {
//                    var res: [[String: String]] = [[String: String]]()
//                    for price in productTable!.prices {
//                        //price.printRow()
//                        let type: String = price.price_title
//                        let typePrice: String = String(price.price_member)
//                        let str: String = type + " " + typePrice
//                        let dict: [String: String] = [String(price.id): str]
//                        res.append(dict)
//                    }
    //                let sortedByKeys = dicts.keys.sorted(by: <)
    //                var _dicts: [String: String] = [String: String]()
    //                for sortedBykey in sortedByKeys {
    //                    _dicts[sortedBykey] = dicts[sortedBykey]
    //                }
//                    typeItem.setTags(tags: res)
//                }
//            }
        
//        if getFormItemFromKey(NUMBER_KEY) != nil {
//            selected_number = productTable!.order_min
//        }
//
//        if getFormItemFromKey(SHIPPING_FEE_KEY) != nil {
//            shippingFee = productTable!.prices[selected_idx].shipping_fee
//            //print(shippingFee)
//            //updateShippingFee()
//        }
//
//        if getFormItemFromKey(SUBTOTAL_KEY) != nil {
//            selected_price = productTable!.prices[selected_idx].price_member
//
//            updateSubTotal()
//        }
        
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
//        var rowKey: String = ""
//        let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
//        if let tmp: String = row["key"] {
//            rowKey = tmp
//        }
//
//        var sectionKey: String = ""
//        let section: [String: Any] = myRows[indexPath.section]
//        if let tmp: String = section["key"] as? String {
//            sectionKey = tmp
//        }
        
//        var cell_type: String = "text"
//        if (row.keyExist(key: "cell")) {
//            cell_type = row["cell"]!
//        }
        
//        var title: String = ""
//        var show: String = ""
//        var alias: String = ""
//        var value: String = ""
//
//        if row.keyExist(key: "key") {
//            alias = row["key"]!
//        }
//
//        if row.keyExist(key: "title") {
//            title = row["title"]!
//        }
//
//        if row.keyExist(key: "show") {
//            show = row["show"]!
//        }
//
//        if row.keyExist(key: "value") {
//            value = row["value"]!
//        }
        
        if (cell_type == "tag") {
            if let cell: TagCell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as? TagCell {
                
                //cell.baseViewControllerDelegate = self
                //cell.update(alias: alias, title: title, attribute_text: show, value: value, sectionKey: sectionKey)
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        } else if (cell_type == "number") {
            if let cell: NumberCell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as? NumberCell {
                
//                if row.keyExist(key: "title") {
//                    title = row["title"]!
//                }
//                let _value: Double = Double(value) ?? -1
//                var min: Double = -1
//                var max: Double = -1
//                if row.keyExist(key: "show") {
//                    let show: String = row["show"]!
//                    let tmp: [String] = show.components(separatedBy: ",")
//                    if (tmp.count == 2) {
//                        if let tmp1: Double = Double(tmp[0]) {
//                            min = tmp1
//                        }
//                        if let tmp2: Double = Double(tmp[1]) {
//                            max = tmp2
//                        }
//                    }
//                }
                //cell.baseViewControllerDelegate = self
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
        
        //let name = item?.name
//        let cell: UITableViewCell
//        if item != nil {
//            if let cellType = item!.uiProperties.cellType {
//                cell = cellType.dequeueCell(for: tableView, at: indexPath)
//            } else {
//                cell = UITableViewCell()
//            }
//
//            if let formUpdatableCell = cell as? FormUPdatable {
//                item!.indexPath = indexPath
//                formUpdatableCell.update(with: item!)
//            }
//
//            if item!.uiProperties.cellType == FormItemCellType.tag || item!.uiProperties.cellType == FormItemCellType.number || item!.uiProperties.cellType == FormItemCellType.weight {
//                if let formCell = cell as? FormItemCell {
//                    formCell.valueDelegate = self
//                }
//            }
//
//        } else {
//            cell = UITableViewCell()
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func updateSubTotal() {
        
        sub_total = selected_price * selected_number
        let row = getOneRowFromKey(SUBTOTAL_KEY)
        row.value = String(sub_total)
        row.show = "NT$ " + String(sub_total) + "元"
//        row["value"] = String(sub_total)
//        row["show"] = "NT$ " + String(sub_total) + "元"
//        replaceRowByKey(rowKey: SUBTOTAL_KEY, _row: row)
        
//        if let priceItem = getFormItemFromKey(SUBTOTAL_KEY) {
//            priceItem.value = String(sub_total)
//            priceItem.make()
//
//        }
        
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
//        var row = getRowRowsFromMyRowsByKey1(key: TOTAL_KEY)
//        row["value"] = String(total)
//        row["show"] = "NT$ " + String(total) + "元"
//        replaceRowByKey(rowKey: TOTAL_KEY, _row: row)
        
//        if let priceItem = getFormItemFromKey(TOTAL_KEY) {
//            priceItem.value = String(total)
//            priceItem.make()
//        }
        
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
    
    //size, XL, true, attribute
//    override func setTag(sectionKey: String, rowKey: String, attribute: String, selected: Bool) {
////        print(alias)
////        print(attribute)
////        print(selected)
////        print(myRowsKey)
//
//        let rows = getRowRowsFromMyRowsByKey(key: sectionKey)
//        // [["show": "3XL,2XL,XL,L,M,S,XS", "value": "", "key": "size", "title": "尺寸"]]
//        for row in rows {
//            if (row.keyExist(key: "key")) {
//                let key = row["key"]
//                if (key == rowKey) {
//                    var _row = row
//                    _row["value"] = attribute
//                    replaceRowByKey(sectionKey: sectionKey, rowKey: rowKey, _row: _row)
//                    //print(myRows)
//                }
//            }
//        }
//    }
//
//    override func stepperValueChanged(sectionKey: String, rowKey: String, number: Int) {
//
//        let rows = getRowRowsFromMyRowsByKey(key: sectionKey)
//        // [["show": "3XL,2XL,XL,L,M,S,XS", "value": "", "key": "size", "title": "尺寸"]]
//        for row in rows {
//            if (row.keyExist(key: "key")) {
//                let key = row["key"]
//                if (key == rowKey) {
//                    var _row = row
//                    let tmp = String(number)
//                    if (tmp.count > 0) {
//                        _row["value"] = tmp
//                        //_row["show"] = tmp
//                    }
//                    replaceRowByKey(sectionKey: sectionKey, rowKey: rowKey, _row: _row)
//                    //print(myRows)
//
//                    selected_number = number
//                    updateSubTotal()
//                }
//            }
//        }
//    }
    
//    override func textFieldDidChange(sectionKey: String, rowKey: String, text: String) {
//
//        let rows = getRowRowsFromMyRowsByKey(key: sectionKey)
//        for row in rows {
//            if (row.keyExist(key: "key")) {
//                let key = row["key"]
//                if (key == rowKey) {
//                    var _row = row
//                    _row["value"] = text
//                    _row["show"] = text
//                    replaceRowByKey(sectionKey: sectionKey, rowKey: rowKey, _row: _row)
//                    //print(myRows)
//                }
//            }
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
//
//        //move to cell to implement
//        //item?.value = value
//    }
//
//    func stepperValueChanged(number: Int, name: String) {
//        //move to cell to implement
////        let item = getFormItemFromKey(name)
////        item?.value = String(number)
////        var idx: Int = 0
////
////        if let _formItem: TagFormItem = getFormItemFromKey("type") as? TagFormItem {
////            idx = _formItem.selected_idxs[0]
////        }
//
//        selected_number = number
//        updateSubTotal()
//
//        //let price: Int = number * Int(superProduct.prices.price_dummy)
//        //updateSubTotal(price: price)
//    }
    
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
        //params["type"] = productTable!.type
        params["price_id"] = String(productTable!.prices[selected_idx].id)
        
        params["member_id"] = String(Member.instance.id)
        
//        params["order_name"] = getRowValue(rowKey: NAME_KEY)
//        params["order_tel"] = getRowValue(rowKey: MOBILE_KEY)
//        params["order_email"] = getRowValue(rowKey: EMAIL_KEY)
//        params["gateway"] = "credit_card"
        
        //let city_name = Global.instance.zoneIDToName(Member.instance.city)
        //let area_name = Global.instance.zoneIDToName(Member.instance.area)
        //params["order_city"] = city_name
        //params["order_area"] = area_name
        //params["order_road"] = Member.instance.road
        
        //let numberFormItem = getFormItemFromKey(NUMBER_KEY)
        //params[QUANTITY_KEY] = numberFormItem?.value
        params[QUANTITY_KEY] = getOneRowValue(QUANTITY_KEY)
        
//        let totalFormItem = getFormItemFromKey(TOTAL_KEY)
//        params["amount"] = totalFormItem?.value
        params[AMOUNT_KEY] = getOneRowValue(TOTAL_KEY)
        
        //是否有選擇商品屬性
        var isAttribute: Bool = true
        
        var selected_attributes: [String] = [String]()
        //let attributes: [[String: String]] = myRows[1]["rows"] as! [[String: String]]
        let rows: [OneRow] = getOneRowsFromSectionKey("attribute")
        
        for row in rows {
            
//            var value: String = ""
//            var alias: String = ""
//            var name: String = ""
//            if let tmp: String = attribute["value"] {
//                value = tmp
//            }
//            if let tmp: String = attribute["key"] {
//                alias = tmp
//            }
//            if let tmp: String = attribute["title"] {
//                name = tmp
//            }
            
            
            if (row.value.count == 0) {
                isAttribute = false
                warning("請先選擇\(row.title)")
            } else {
                let value: String = "{name:\(row.title),alias:\(row.key),value:\(row.value)}"
                selected_attributes.append(value)
            }
        }
        
//        let shippingFeeFormItem = getFormItemFromKey(SHIPPING_FEE_KEY)
//        if (shippingFeeFormItem != nil) {
//            params["shipping_fee"] = shippingFeeFormItem?.value
//        }
        //params[SHIPPING_FEE_KEY] = getRowValue(rowKey: SHIPPING_FEE_KEY)
        
//        if let item = getFormItemFromKey(COLOR_KEY) {
//            params["color"] = item.value
//        }
//
//        if let item = getFormItemFromKey(CLOTHES_SIZE_KEY) {
//            params["size"] = item.value
//        }
//
//        if let item = getFormItemFromKey(WEIGHT_KEY) {
//            params["weight"] = item.value
//        }
        
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
                    self.info(msg: msg, showCloseButton: false, buttonTitle: "關閉") {
                        self.toMemberCartList()
                    }
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

