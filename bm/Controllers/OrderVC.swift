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
    
    override func viewDidLoad() {
        myTablView = tableView
        form = OrderForm()
        super.viewDidLoad()
        //print(superProduct)
        self.hideKeyboardWhenTappedAround()
        
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
            //let address: String = Member.instance.ci
            addressItem.value = Member.instance.road
            addressItem.make()
        }
        
        if let colorItem = getFormItemFromKey(COLOR_KEY) as? Color1FormItem {
            colorItem.setColors(colors: superProduct.colors)
            //print(superProduct.color)
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
        let name = item?.name
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
            
            if item!.uiProperties.cellType == FormItemCellType.color1
            {
                if let formCell = cell as? FormItemCell {
                    formCell.valueDelegate = self
                }
            }
            
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func tagChecked(checked: Bool, key: String, value: String) {
//        print(checked)
//        print(key)
//        print(value)
    }
    
    func textFieldTextChanged(formItem: FormItem, text: String) {
        
    }
    
    func sexChanged(sex: String) {
        
    }
    
    func privacyChecked(checked: Bool) {
        
    }
    
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
