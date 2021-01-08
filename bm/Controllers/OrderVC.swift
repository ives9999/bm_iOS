//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderVC: MyTableVC {
    
    var superProduct: SuperProduct = SuperProduct()
    @IBOutlet weak var titleLbl: SuperLabel!
    
    override func viewDidLoad() {
        myTablView = tableView
        form = RegisterForm()
        super.viewDidLoad()
        //print(superProduct)
        self.hideKeyboardWhenTappedAround()
        
        titleLbl.textColor = UIColor.black
        titleLbl.text = superProduct.name

        //initData()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        FormItemCellType.registerCell(for: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section_keys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = getFormItemFromIdx(indexPath)
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
            
            if item!.uiProperties.cellType == FormItemCellType.textField ||
                item!.uiProperties.cellType == FormItemCellType.sex ||
                item!.uiProperties.cellType == FormItemCellType.privacy
            {
                if let formCell = cell as? FormItemCell {
                    //formCell.valueDelegate = self
                }
            }
            
        } else {
            cell = UITableViewCell()
        }
        
        return cell
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
