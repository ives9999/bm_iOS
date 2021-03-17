//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderVC: MyTableVC, ValueChangedDelegate {

    var productTable: ProductTable? = nil
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var submitButton: SubmitButton!
    
    var sub_total: Int = 0
    var shippingFee: Int = 0
    var total: Int = 0
    
    var selected_number: Int = 1
    var selected_price: Int = 0
    var selected_idx: Int = 0
    
    override func viewDidLoad() {
        
        myTablView = tableView
        form = OrderForm(type: self.productTable!.type)

        super.viewDidLoad()
        //print(superProduct)
        self.hideKeyboardWhenTappedAround()
        submitButton.setTitle("訂購")
        
        titleLbl.textColor = UIColor.black
        titleLbl.text = productTable!.name

        initData()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        FormItemCellType.registerCell(for: tableView)
    }
    
    func initData() {
        
        if let productNameItem = getFormItemFromKey("Product_Name") {
            productNameItem.value = productTable!.name
            productNameItem.make()
        }
        
        if let nameItem = getFormItemFromKey(NAME_KEY) {
            nameItem.value = Member.instance.name
            nameItem.make()
        }
        
        if let mobileItem = getFormItemFromKey(MOBILE_KEY) {
            mobileItem.value = Member.instance.mobile
            mobileItem.make()
        }
        
        if let emailItem = getFormItemFromKey(EMAIL_KEY) {
            emailItem.value = Member.instance.email
            emailItem.make()
        }
        
        if let addressItem = getFormItemFromKey(ADDRESS_KEY) {
            addressItem.value = Member.instance.road
            addressItem.make()
        }
        
        if let numberItem = getFormItemFromKey(NUMBER_KEY) as? NumberFormItem {
            numberItem.min = productTable!.order_min
            numberItem.max = productTable!.order_max
        }
        
        if let colorItem = getFormItemFromKey(COLOR_KEY) as? Color1FormItem {
            var res: [[String: String]] = [[String: String]]()
//            for color in productTable!.colors {
//                let dict: [String: String] = [color: color]
//                res.append(dict)
//            }
            colorItem.setTags(tags: res)
            //print(superProduct.color)
        }
        
        if let clothesSizeItem = getFormItemFromKey(CLOTHES_SIZE_KEY) as? ClothesSizeFormItem {
            
            var res: [[String: String]] = [[String: String]]()
            
//            for size in productTable!.sizes {
//                let dict: [String: String] = [size: size]
//                res.append(dict)
//            }
            clothesSizeItem.setTags(tags: res)
        }
        
        if let weightItem = getFormItemFromKey(WEIGHT_KEY) as? WeightFormItem {
            
            var res: [[String: String]] = [[String: String]]()
//            for size in productTable!.weights {
//                let dict: [String: String] = [size: size]
//                res.append(dict)
//            }
            weightItem.setTags(tags: res)
        }
        
        if productTable!.type == "mejump" {
            if let typeItem = getFormItemFromKey("type") as? TagFormItem {
                var res: [[String: String]] = [[String: String]]()
                for price in productTable!.prices {
                    //price.printRow()
                    let type: String = price.price_title
                    let typePrice: String = String(price.price_member)
                    let str: String = type + " " + typePrice
                    let dict: [String: String] = [String(price.id): str]
                    res.append(dict)
                }
//                let sortedByKeys = dicts.keys.sorted(by: <)
//                var _dicts: [String: String] = [String: String]()
//                for sortedBykey in sortedByKeys {
//                    _dicts[sortedBykey] = dicts[sortedBykey]
//                }
                typeItem.setTags(tags: res)
            }
        }
        
        if getFormItemFromKey(NUMBER_KEY) != nil {
            selected_number = productTable!.order_min
        }
        
        if getFormItemFromKey(SUBTOTAL_KEY) != nil {
            selected_price = productTable!.prices[selected_idx].price_member
            updateSubTotal()
        }
        
        if getFormItemFromKey(SHIPPING_FEE_KEY) != nil {
            shippingFee = productTable!.prices[selected_idx].shipping_fee
            updateShippingFee()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section_keys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = getFormItemFromIdx(indexPath)
        //let name = item?.name
        let cell: UITableViewCell
        if item != nil {
            if let cellType = item!.uiProperties.cellType {
                cell = cellType.dequeueCell(for: tableView, at: indexPath)
            } else {
                cell = UITableViewCell()
            }
            
            if let formUpdatableCell = cell as? FormUPdatable {
                item!.indexPath = indexPath
                formUpdatableCell.update(with: item!)
            }
            
            if item!.uiProperties.cellType == FormItemCellType.tag || item!.uiProperties.cellType == FormItemCellType.number || item!.uiProperties.cellType == FormItemCellType.weight {
                if let formCell = cell as? FormItemCell {
                    formCell.valueDelegate = self
                }
            }
            
        } else {
            cell = UITableViewCell()
        }
        
        return cell
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
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        Global.instance.addSpinner(superView: self.view)
        var params: [String: String] = [String: String]()
        
        params["device"] = "app"
        params["product_id"] = String(productTable!.id)
        params["type"] = productTable!.type
        params["price_id"] = String(productTable!.prices[selected_idx].id)
        
        params["member_id"] = String(Member.instance.id)
        params["order_name"] = Member.instance.name
        params["order_tel"] = Member.instance.mobile
        params["order_email"] = Member.instance.email
        params["gateway"] = "credit_card"
        
        let city_name = Global.instance.zoneIDToName(Member.instance.city_id)
        let area_name = Global.instance.zoneIDToName(Member.instance.area_id)
        params["order_city"] = city_name
        params["order_area"] = area_name
        params["order_road"] = Member.instance.road
        
        let numberFormItem = getFormItemFromKey(NUMBER_KEY)
        params["quantity"] = numberFormItem?.value
        
        let totalFormItem = getFormItemFromKey(TOTAL_KEY)
        params["amount"] = totalFormItem?.value
        
        let shippingFeeFormItem = getFormItemFromKey(SHIPPING_FEE_KEY)
        params["shipping_fee"] = shippingFeeFormItem?.value
        
        if let item = getFormItemFromKey(COLOR_KEY) {
            params["color"] = item.value
        }
        
        if let item = getFormItemFromKey(CLOTHES_SIZE_KEY) {
            params["size"] = item.value
        }
        
        if let item = getFormItemFromKey(WEIGHT_KEY) {
            params["weight"] = item.value
        }
        //print(params)
        
        //self.toPayment(ecpay_token: "", order_no: "", tokenExpireDate: "")
        
        OrderService.instance.update(t: SuperOrder.self, params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                let order_token: String = OrderService.instance.order_token
                if self.total > 0 {
                    let ecpay_token: String = OrderService.instance.ecpay_token
                    let tokenExpireDate: String = OrderService.instance.tokenExpireDate
                    self.info(msg: "訂單已經成立，是否前往結帳？", showCloseButton: true, buttonTitle: "結帳") {
                        //print("aaa")
                        self.toPayment(order_token: order_token, ecpay_token: ecpay_token, tokenExpireDate: tokenExpireDate)
                    }
                } else {
                    self.info(msg: "訂單已經成立，結帳金額為零，我們會儘速處理您的訂單", buttonTitle: "關閉") {
                        self.toPayment(order_token: order_token)
                    }
                }
            } else {
                self.warning(OrderService.instance.msg)
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //goHome()
        prev()
    }
}
