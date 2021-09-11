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
    
    var productRows: [[String: String]] = []
    
    var amountRows: [[String: String]] = []
    
    var gatewayRows: [[String: String]] = []
    
    var shippingRows: [[String: String]] = []
    
    var invoiceRows: [[String: String]] = []
    
    var invoiceFixedRows: [[String: String]] = [
        ["title": "發票(本商城目前僅提供電子發票)","key":INVOICE_KEY,"value":"","show":"","cell":"more"]
    ]
    
    var invoiceOptionRows: [[String: String]] = [
        ["title": "個人","key":PERSONAL_KEY,"value":"true","show":"","cell":"radio"],
        ["title": "公司","key":COMPANY_KEY,"value":"false","show":"","cell":"radio"]
    ]
    
    let invoicePersonalRows: [[String: String]] = [
        ["title":"EMail","key":INVOICE_EMAIL_KEY,"value":"\(Member.instance.email)","show":"\(Member.instance.email)","cell":"textField"]
    ]
    
    let invoiceCompanyRows: [[String: String]] = [
        ["title":"統一編編","key":INVOICE_COMPANY_TAX_KEY,"value":"","show":"","cell":"textField"],
        ["title":"公司行號抬頭","key":INVOICE_COMPANY_NAME_KEY,"value":"","show":"","cell":"textField"],
        ["title":"EMail","key":INVOICE_EMAIL_KEY,"value":"\(Member.instance.email)","show":"\(Member.instance.email)","cell":"textField"]
    ]
    
    var memberRows: [[String: String]] = []
    
    let memoRows: [[String: String]] = [
        ["title": "留言","key":MEMO_KEY,"value":"","show":"","cell":"memo"]
    ]
    
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
        
        let memoNib = UINib(nibName: "MemoCell", bundle: nil)
        tableView.register(memoNib, forCellReuseIdentifier: "MemoCell")
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "TextFieldCell")
        
        let moreNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreNib, forCellReuseIdentifier: "MoreCell")
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        lists1.removeAll()
        getDataStart()
    }
    
//    override func getDataStart(token: String? = nil, page: Int = 1, perPage: Int = PERPAGE) {
//
//        Global.instance.addSpinner(superView: view)
//
//        CartService.instance.getList(token: Member.instance.token, _filter: params, page: page, perPage: perPage) { (success) in
//            if (success) {
//
//                do {
//                    if (CartService.instance.jsonData != nil) {
//                        try self.tables = JSONDecoder().decode(CartsTable.self, from: CartService.instance.jsonData!)
//                        if (self.tables != nil) {
//                            self.getDataEnd(success: success)
//                        }
//                    } else {
//                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
//                    }
//                } catch {
//                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
//                }
//
//                Global.instance.removeSpinner(superView: self.view)
//            } else {
//                Global.instance.removeSpinner(superView: self.view)
//                self.warning(self.dataService.msg)
//            }
//        }
//
////        let params: [String: String] = ["token": product_token!, "member_token": Member.instance.token]
////        ProductService.instance.getOne(params: params) { (success) in
////            if (success) {
////                let table: Table = ProductService.instance.table!
////                self.productTable = (table as! ProductTable)
////                //self.superProduct!.printRow()
////
////                self.initData()
////            }
////            Global.instance.removeSpinner(superView: self.view)
////            self.endRefresh()
////        }
//    }
    
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
        
        if cartsTable == nil {
            warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
        } else {
            if (cartsTable!.rows.count != 1) {
                warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
            } else {
                
                //product cell
                var amount: Int = 0
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
                    
                    let row:[String: String] = ["title":productTable!.name,"key":PRODUCT_KEY,"value":"","show":"","cell":"cart","featured_path":productTable!.featured_path,"attribute":attribute_text,"amount":cartItemTable.amount_show,"quantity":String(cartItemTable.quantity)]
                    productRows.append(row)
                }
                
                //price
                let amount_show: String = amount.formattedWithSeparator
                var row:[String: String] = ["title":"商品金額","key":"amount","value":String(amount),"show":"NT$ \(amount_show)","cell":"text"]
                amountRows.append(row)
                
                //var shipping_fee: Int = 60
                var shipping_fee: Int = 0
                if (amount > 1000) { shipping_fee = 0}
                let shipping_fee_show: String = shipping_fee.formattedWithSeparator
                row = ["title":"運費","key":SHIPPING_FEE_KEY,"value":String(shipping_fee),"show":"NT$ \(shipping_fee_show)","cell":"text"]
                amountRows.append(row)
                
                //let tax: Int = Int(Double(amount) * 0.05)
                let tax: Int = 0
                let tax_show: String = tax.formattedWithSeparator
                row = ["title":"稅","key":TAX_KEY,"value":String(tax),"show":"NT$ \(tax_show)","cell":"text"]
                amountRows.append(row)
                
                let total: Int = amount + shipping_fee + tax
                let total_show: String = total.formattedWithSeparator
                row = ["title":"總金額","key":TOTAL_KEY,"value":String(total),"show":"NT$ \(total_show)","cell":"text"]
                amountRows.append(row)
                
                //gateway
                let gateway: String = productTable!.gateway
                var arr: [String] = gateway.components(separatedBy: ",")
                for tmp in arr {
                    let title: String = GATEWAY.getRawValueFromString(tmp)
                    var value: String = "false"
                    if (tmp == "credit_card") {
                        value = "true"
                    }
                    let row: [String: String] = ["title":title,"key":tmp,"value":value,"show":title,"cell":"radio"]
                    gatewayRows.append(row)
                }
                
                let shipping: String = productTable!.shipping
                arr = shipping.components(separatedBy: ",")
                for tmp in arr {
                    let title: String = SHIPPING_WAY.getRawValueFromString(tmp)
                    var value: String = "false"
                    if (tmp == "direct") {
                        value = "true"
                    }
                    let row: [String: String] = ["title":title,"key":tmp,"value":value,"show":title,"cell":"radio"]
                    shippingRows.append(row)
                }
                
                
                initData()
            }
        }
        
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
        
        mySections = [
            ["name": "商品", "isExpanded": true, "key": PRODUCT_KEY],
            ["name": "金額", "isExpanded": true, "key": AMOUNT_KEY],
            ["name": "付款方式", "isExpanded": true, "key": GATEWAY_KEY],
            ["name": "寄送方式", "isExpanded": true, "key": SHIPPING_KEY],
            ["name": "電子發票", "isExpanded": true, "key": INVOICE_KEY],
            ["name": "收件人資料", "isExpanded": true, "key": MEMBER_KEY],
            ["name": "其他留言", "isExpanded": true, "key": MEMO_KEY]
        ]
        
        memberRows = [
            ["title":"姓名","key":NAME_KEY,"value":"\(Member.instance.name)","show":"\(Member.instance.name)","cell":"textField"],
            ["title":"電話","key":MOBILE_KEY,"value":"\(Member.instance.mobile)","show":"\(Member.instance.mobile)","cell":"textField"],
            ["title":"EMail","key":EMAIL_KEY,"value":"\(Member.instance.email)","show":"\(Member.instance.email)","cell":"textField"],
            ["title":"住址","key":ADDRESS_KEY,"value":"\(Member.instance.address)","show":"\(Member.instance.address)","cell":"textField"]
        ]
        
        for invoiceFixedRow in invoiceFixedRows {
            
            invoiceRows.append(invoiceFixedRow)
        }
        
        for invoicePersonalRow in invoicePersonalRows {
            
            invoiceRows.append(invoicePersonalRow)
        }
        
        myRows = [
            ["key":PRODUCT_KEY, "rows": productRows],
            ["key":AMOUNT_KEY, "rows": amountRows],
            ["key":GATEWAY_KEY, "rows": gatewayRows],
            ["key":SHIPPING_KEY, "rows": shippingRows],
            ["key":INVOICE_KEY, "rows": invoiceRows],
            ["key":MEMBER_KEY, "rows": memberRows],
            ["key":MEMO_KEY, "rows": memoRows]
        ]
        
//        form = OrderForm(type: self.productTable!.type)
//        section_keys = form.getSectionKeys()
//        sections = form.getSections()
//
//        titleLbl.text = productTable!.name
//
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
//
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
//
//        if productTable!.type == "mejump" {
//            if let typeItem = getFormItemFromKey("type") as? TagFormItem {
//                var res: [[String: String]] = [[String: String]]()
//                for price in productTable!.prices {
//                    //price.printRow()
//                    let type: String = price.price_title
//                    let typePrice: String = String(price.price_member)
//                    let str: String = type + " " + typePrice
//                    let dict: [String: String] = [String(price.id): str]
//                    res.append(dict)
//                }
////                let sortedByKeys = dicts.keys.sorted(by: <)
////                var _dicts: [String: String] = [String: String]()
////                for sortedBykey in sortedByKeys {
////                    _dicts[sortedBykey] = dicts[sortedBykey]
////                }
//                typeItem.setTags(tags: res)
//            }
//        }
//
//        if getFormItemFromKey(NUMBER_KEY) != nil {
//            selected_number = productTable!.order_min
//        }
//
//        if getFormItemFromKey(SUBTOTAL_KEY) != nil {
//            selected_price = productTable!.prices[selected_idx].price_member
//            updateSubTotal()
//        }
//
//        if getFormItemFromKey(SHIPPING_FEE_KEY) != nil {
//            shippingFee = productTable!.prices[selected_idx].shipping_fee
//            print(shippingFee)
//            updateShippingFee()
//        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (tableView == invoiceTable) {
            return 1
        } else {
            return mySections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if (tableView == invoiceTable) {
            count = invoiceOptionRows.count
        } else {
        
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
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (tableView == invoiceTable) {
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
        
        if (tableView == invoiceTable) {
            if let cell: RadioCell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as? RadioCell {
                
                let row: [String: String] = invoiceOptionRows[indexPath.row]
                
                let rowKey: String = row["key"]!
                
                var title: String = ""
                if row.keyExist(key: "title") {
                    title = row["title"]!
                }
                
                var value: String = "false"
                if row.keyExist(key: "value") {
                    value = row["value"]!
                }
                
                cell.baseViewControllerDelegate = self
                cell.update(sectionKey: INVOICE_KEY, rowKey: rowKey, title: title, checked: Bool(value)!)
                return cell
            }
        } else {
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
            var value: String = ""
            
            if row.keyExist(key: "title") {
                title = row["title"]!
            }
            
            if row.keyExist(key: "show") {
                show = row["show"]!
            }
            
            if row.keyExist(key: "value") {
                value = row["value"]!
            }
            
            if (cell_type == "cart") {
                if let cell: CartListCell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {
                    
                    cell.update(sectionKey: sectionKey,rowKey: rowKey,title: title,featured_path:row["featured_path"]!,attribute:row["attribute"]!,amount: row["amount"]!,quantity: row["quantity"]!)
                    return cell
                }
            } else if (cell_type == "radio") {
                if let cell: RadioCell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as? RadioCell {
                    
                    if row.keyExist(key: "title") {
                        title = row["title"]!
                    }
                    
                    cell.baseViewControllerDelegate = self
                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, checked: Bool(value)!)
                    return cell
                }
            } else if (cell_type == "text") {
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    
                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, show: show)
                    return cell
                }
            } else if (cell_type == "textField") {
                if let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell {
                    
                    var keyboard: String = "default"
                    if row.keyExist(key: "keyboard") {
                        let tmp: String = row["keyboard"]!
                        keyboard = tmp
                    }
                    
                    cell.baseViewControllerDelegate = self
                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: value, keyboard: keyboard)
                    return cell
                }
            } else if (cell_type == "memo") {
                if let cell: MemoCell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoCell {
                    
                    cell.baseViewControllerDelegate = self
                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: value)
                    return cell
                }
            } else if (cell_type == "more") {
                if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as? MoreCell {
                    
                    cell.baseViewControllerDelegate = self
                    cell.update(sectionKey: sectionKey, rowKey: rowKey, title: title, value: value, show: show)
                    return cell
                }
            }
        }
        
        return UITableViewCell()
        
//        let item = getFormItemFromIdx(indexPath)
//        //let name = item?.name
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
//        
//        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == invoiceTable) {
            
            let rowKey: String = invoiceOptionRows[indexPath.row]["key"]!
            let checked: Bool = Bool(invoiceOptionRows[indexPath.row]["value"]!)!
            radioDidChange(sectionKey: INVOICE_KEY, rowKey: rowKey, checked: !checked)
        } else {
            //var rowKey: String = ""
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
            
            if (cell_type == "more") {
                
                maskView = view.mask()
                
                let frame: CGRect = CGRect(x:blackViewPaddingLeft, y:(maskView.frame.height-blackViewHeight)/2, width:maskView.frame.width-(2*blackViewPaddingLeft), height:blackViewHeight)
                blackView.frame = frame
                blackView.backgroundColor = UIColor.black
                maskView.addSubview(blackView)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(unmask))
                gesture.cancelsTouchesInView = false
                maskView.addGestureRecognizer(gesture)
                
                addInvoiceSelectView()
                addCancelBtn()
            } else if (cell_type == "radio") {
                var checked: Bool = false
                if let tmp: String = row["value"] {
                    if let tmp1: Bool = Bool(tmp) {
                        checked = tmp1
                        radioDidChange(sectionKey: sectionKey, rowKey: rowKey, checked: !checked)
                    }
                }
            }
        }
    }
    
    @objc override func unmask(){
        
        maskView.unmask()
    }
    
    func addInvoiceSelectView() {
        
        //let frame = view.frame
        invoiceTable.frame = CGRect(x: 0, y: 0, width: blackView.frame.width, height: invoiceTableHeight)
        invoiceTable.dataSource = self
        invoiceTable.delegate = self
        
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
    
    func updateSubTotal() {
        if let priceItem = getFormItemFromKey(SUBTOTAL_KEY) {
            sub_total = selected_price * selected_number
            priceItem.value = String(sub_total)
            priceItem.make()
            updateShippingFee()
            //updateTotal()
        }
    }
    
    func updateShippingFee() {
        shippingFee = productTable!.prices[selected_idx].shipping_fee
        if let priceItem = getFormItemFromKey(SHIPPING_FEE_KEY) {
            //shippingFee = price
            priceItem.value = String(shippingFee)
            priceItem.make()
            updateTotal()
        }
    }
    
    func updateTotal() {
        if let priceItem = getFormItemFromKey(TOTAL_KEY) {
            total = sub_total + shippingFee
            priceItem.value = String(total)
            priceItem.make()
            tableView.reloadData()
        }
    }
    
    func tagChecked(checked: Bool, name: String, key: String, value: String) {
//        print(checked)
//        print(key)
//        print(value)
        //let item = getFormItemFromKey(name)
        if name == "type" {
            let id: Int = Int(key)!
            //print(id)
            var idx: Int = 0
            for price in productTable!.prices {
                if price.id == id {
                    selected_price = price.price_member
                    self.selected_idx = idx
                    updateSubTotal()
                    break
                }
                idx = idx + 1
            }
        }
        
        //move to cell to implement
        //item?.value = value
    }
    
    func stepperValueChanged(number: Int, name: String) {
        //move to cell to implement
//        let item = getFormItemFromKey(name)
//        item?.value = String(number)
//        var idx: Int = 0
//
//        if let _formItem: TagFormItem = getFormItemFromKey("type") as? TagFormItem {
//            idx = _formItem.selected_idxs[0]
//        }
        
        selected_number = number
        updateSubTotal()
        
        //let price: Int = number * Int(superProduct.prices.price_dummy)
        //updateSubTotal(price: price)
    }
    
    override func radioDidChange(sectionKey: String, rowKey: String, checked: Bool) {
        
        //點選發票選項
        invoiceRows.removeAll()
        if (sectionKey == INVOICE_KEY) {
            
            for invoiceFixedRow in invoiceFixedRows {
                invoiceRows.append(invoiceFixedRow)
            }
            
            for (idx, var row) in invoiceOptionRows.enumerated() {
                if (row["key"] == rowKey) {
                    row["value"] = String(checked)
                } else {
                    row["value"] = String(!checked)
                }
                invoiceOptionRows[idx] = row
            }
            
            var selectedRow: [String: String] = [String: String]()
            for row in invoiceOptionRows {
                if (row["value"] == "true") {
                    selectedRow = row
                }
            }
            //print(selectedRow)
            let selectedKey: String = selectedRow["key"]!
            if (selectedKey == PERSONAL_KEY) {
                for invoicePersonalRow in invoicePersonalRows {
                    invoiceRows.append(invoicePersonalRow)
                }
            } else {
                for invoiceCompanyRow in invoiceCompanyRows {
                    invoiceRows.append(invoiceCompanyRow)
                }
            }
            
            replaceRowsByKey(sectionKey: INVOICE_KEY, rows: invoiceRows)
            
            maskView.removeFromSuperview()
            
            invoiceTable.reloadData()
            
        } else {
            let rows = getRowRowsFromMyRowsByKey(key: sectionKey)
            for row in rows {
                
                if (row.keyExist(key: "key")) {
                    let key = row["key"]
                    var _row = row
                    var a: Bool = false
                    if (key == rowKey) {
                        a = checked
                    } else {
                        a = !checked
                    }
                    _row["value"] = String(a)
                    replaceRowByKey(sectionKey: sectionKey, rowKey: key!, _row: _row)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func textFieldDidChange(sectionKey: String, rowKey: String, text: String) {
        
        let rows = getRowRowsFromMyRowsByKey(key: sectionKey)
        for row in rows {
            if (row.keyExist(key: "key")) {
                let key = row["key"]
                if (key == rowKey) {
                    var _row = row
                    _row["value"] = text
                    _row["show"] = text
                    replaceRowByKey(sectionKey: sectionKey, rowKey: rowKey, _row: _row)
                    //print(myRows)
                }
            }
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        Global.instance.addSpinner(superView: self.view)
        var params: [String: String] = [String: String]()
        
        params["device"] = "app"
        params["do"] = "update"
        params["cart_id"] = String(cartTable!.id)
        
        params[AMOUNT_KEY] = getRowValue(rowKey: AMOUNT_KEY)
        params[SHIPPING_FEE_KEY] = getRowValue(rowKey: SHIPPING_FEE_KEY)
        params[TAX_KEY] = getRowValue(rowKey: TAX_KEY)
        params[TOTAL_KEY] = getRowValue(rowKey: TOTAL_KEY)
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
        
        let gateways = getRowRowsFromMyRowsByKey(key: GATEWAY_KEY)
        var key: String = "credit_card"
        for gateway in gateways {
            if (gateway["value"] == "true") {
                key = gateway["key"]!
            }
        }
        params[GATEWAY_KEY] = key
        
        let shippings = getRowRowsFromMyRowsByKey(key: SHIPPING_KEY)
        key = "direct"
        for shipping in shippings {
            if (shipping["value"] == "true") {
                key = shipping["key"]!
            }
        }
        params[SHIPPING_KEY] = key
        
        //invoice
        for invoice_option in invoiceOptionRows {
            if (invoice_option["value"] == "true") {
                key = invoice_option["key"]!
            }
        }
        params[INVOICE_TYPE_KEY] = key
        
        let invoices = getRowRowsFromMyRowsByKey(key: INVOICE_KEY)
        for invoice in invoices {
            for (key1, value) in invoice {
                if (key1 == "key" && value == INVOICE_EMAIL_KEY) {
                    params[INVOICE_EMAIL_KEY] = invoice["value"]
                    break
//                    } else if (invoice["key"] == COMPANY_TAX_KEY) {
//                        params[COMPANY_TAX_KEY] = invoice["value"]
//                    } else if (invoice["key"] == COMPANY_KEY) {
//                        params[COMPANY_KEY] = invoice["value"]
//                    }
                } else if (key1 == "key" && value == INVOICE_COMPANY_NAME_KEY) {
                    params[INVOICE_COMPANY_TAX_KEY] = invoice["value"]
                    break
                } else if (key1 == "key" && value == INVOICE_COMPANY_TAX_KEY) {
                    params[INVOICE_COMPANY_NAME_KEY] = invoice["value"]
                    break
                }
            }
        }
        
        params["member_id"] = String(Member.instance.id)
        params["order_name"] = getRowValue(rowKey: NAME_KEY)
        params["order_tel"] = getRowValue(rowKey: MOBILE_KEY)
        params["order_email"] = getRowValue(rowKey: EMAIL_KEY)
        params["order_address"] = getRowValue(rowKey: ADDRESS_KEY)
        
        params[MEMO_KEY] = getRowValue(rowKey: MEMO_KEY)
        
        
//        params["gateway"] = "credit_card"
        
//        let city_name = Global.instance.zoneIDToName(Member.instance.city)
//        let area_name = Global.instance.zoneIDToName(Member.instance.area)
//        params["order_city"] = city_name
//        params["order_area"] = area_name
//        params["order_road"] = Member.instance.road
        
//        let numberFormItem = getFormItemFromKey(NUMBER_KEY)
//        params["quantity"] = numberFormItem?.value
//
//        let totalFormItem = getFormItemFromKey(TOTAL_KEY)
//        params["amount"] = totalFormItem?.value
//
//        let shippingFeeFormItem = getFormItemFromKey(SHIPPING_FEE_KEY)
//        if (shippingFeeFormItem != nil) {
//            params["shipping_fee"] = shippingFeeFormItem?.value
//        }
        
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
        //print(params)
        
        //self.toPayment(ecpay_token: "", order_no: "", tokenExpireDate: "")
        
        OrderService.instance.update(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                
                self.jsonData = OrderService.instance.jsonData
                do {
                    if (self.jsonData != nil) {
                        let table: OrderUpdateResTable = try JSONDecoder().decode(OrderUpdateResTable.self, from: self.jsonData!)
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
                    } else {
                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
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
    var id: Int = 0
    var update: String = "INSERT"
    var model: OrderTable?
    
    enum CodingKeys: String, CodingKey {
        case success
        case id
        case update
        case model
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        update = try container.decodeIfPresent(String.self, forKey: .update) ?? ""
        model = try container.decodeIfPresent(OrderTable.self, forKey: .model) ?? nil
    }
}
