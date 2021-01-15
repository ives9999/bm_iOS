//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderVC: MyTableVC, ValueChangedDelegate {

    var superProduct: SuperProduct = SuperProduct()
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var submitButton: SubmitButton!
    
    var sub_total: Int = 0
    var shippingFee: Int = 0
    var total: Int = 0
    
    override func viewDidLoad() {
        myTablView = tableView
        form = OrderForm(type: self.superProduct.type)

        super.viewDidLoad()
        //print(superProduct)
        self.hideKeyboardWhenTappedAround()
        submitButton.setTitle("訂購")
        
        titleLbl.textColor = UIColor.black
        titleLbl.text = superProduct.name

        initData()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        FormItemCellType.registerCell(for: tableView)
    }
    
    func initData() {
        
        if let productNameItem = getFormItemFromKey("Product_Name") {
            productNameItem.value = superProduct.name
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
            numberItem.min = superProduct.order_min
            numberItem.max = superProduct.order_max
        }
        
        if let colorItem = getFormItemFromKey(COLOR_KEY) as? Color1FormItem {
            colorItem.setTags(tags: superProduct.colors)
            //print(superProduct.color)
        }
        
        if let clothesSizeItem = getFormItemFromKey(CLOTHES_SIZE_KEY) as? ClothesSizeFormItem {
            
            var dicts: [String: String] = [String: String]()
            for size in superProduct.sizes {
                dicts[size] = size
            }
            clothesSizeItem.setTags(tags: dicts)
        }
        
        if let weightItem = getFormItemFromKey(WEIGHT_KEY) as? WeightFormItem {
            
            var dicts: [String: String] = [String: String]()
            for size in superProduct.weights {
                dicts[size] = size
            }
            weightItem.setTags(tags: dicts)
        }
        
        if getFormItemFromKey(SUB_TOTAL_KEY) != nil {
            updateSubTotal(price: superProduct.prices[0].price_member)
        }
        
        if getFormItemFromKey(SHIPPING_FEE_KEY) != nil {
            updateShippingFee(price: superProduct.prices[0].shipping_fee)
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
    
    func updateSubTotal(price: Int) {
        if let priceItem = getFormItemFromKey(SUB_TOTAL_KEY) {
            sub_total = price
            priceItem.value = String(price)
            priceItem.make()
            updateTotal()
        }
    }
    
    func updateShippingFee(price: Int) {
        if let priceItem = getFormItemFromKey(SHIPPING_FEE_KEY) {
            shippingFee = price
            priceItem.value = String(price)
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
        let item = getFormItemFromKey(name)
        item?.value = value
    }
    
    func stepperValueChanged(number: Int, name: String) {
        let item = getFormItemFromKey(name)
        item?.value = String(number)
        updateSubTotal(price: number * superProduct.prices[0].price_member)
        
        //let price: Int = number * Int(superProduct.prices.price_dummy)
        //updateSubTotal(price: price)
    }
    
    func textFieldTextChanged(formItem: FormItem, text: String) {}
    
    func sexChanged(sex: String) {}
    
    func privacyChecked(checked: Bool) {}
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        //print("purchase")
        //toOrder(superProduct: superProduct!)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //goHome()
        prev()
    }
}
