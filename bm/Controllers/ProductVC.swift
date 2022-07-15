//
//  ProductVC.swift
//  bm
//
//  Created by ives on 2020/12/30.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ProductVC: MyTableVC {
    
    var mysTable: ProductsTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "product"
        dataService = ProductService.instance
        //_type = "product"
        //_titleField = "name"
//        searchRows = [
//            ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入商品名稱關鍵字","text_field":true,"value":"","value_type":"String","segue":""]
//        ]
        
        oneSections = initSectionRows()
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "ProductListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        // this page show search icon in top
        searchBtn.visibility = .visible
        
        refresh()
    }
    
    override func initSectionRows()-> [OneSection] {

        var sections: [OneSection] = [OneSection]()

        sections.append(makeSectionRow())

        return sections
    }
    
    override func makeSectionRow(_ isExpanded: Bool=true)-> OneSection {
        var rows: [OneRow] = [OneRow]()
        let r1: OneRow = OneRow(title: "關鍵字", key: KEYWORD_KEY, cell: "textField")
        rows.append(r1)

        let s: OneSection = OneSection(title: "一般", isExpanded: isExpanded)
        s.items.append(contentsOf: rows)
        return s
    }
    
//    override func refresh() {
//        page = 1
//        getDataStart(page: page, perPage: PERPAGE)
//    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(ProductsTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if mysTable!.rows.count > 0 {
                if (page == 1) {
                    lists1 = [ProductTable]()
                }
                lists1 += mysTable!.rows
            } else {
                view.setInfo(info: "目前暫無商品", topAnchor: topView)
            }
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//            
//            mysTable = (tables as? ProductsTable)
//            if mysTable != nil {
//                let tmps: [ProductTable] = mysTable!.rows
//                
//                if page == 1 {
//                    lists1 = [ProductTable]()
//                }
//                lists1 += tmps
//                
//                myTablView.reloadData()
//            }
//        }
//    }
    
    //按下購買按鈕
    override func cellCity(row: Table) {
        //print(indexPath!.row)
        
        if let row1: ProductTable = row as? ProductTable {
            let type: String = row1.type
            if type == "coin" {
                toOrder(
                    login: { vc in vc.toLogin() },
                    register: { vc in vc.toRegister() },
                    product_token: row.token
                )

//                var params: [String: String] = [String: String]()
//
//                params["device"] = "app"
//                params["do"] = "update"
//                params["member_token"] = Member.instance.token
//                params["product_id"] = String(row1.id)
//                params["price_id"] = String(row1.prices[0].id)
//                params["member_id"] = String(Member.instance.id)
//                params[QUANTITY_KEY] = getOneRowValue(QUANTITY_KEY)
//                params[AMOUNT_KEY] = getOneRowValue(TOTAL_KEY)
//
//                //是否有選擇商品屬性
//                var isAttribute: Bool = true
//
//                var selected_attributes: [String] = [String]()
//                //let attributes: [[String: String]] = myRows[1]["rows"] as! [[String: String]]
//                let rows: [OneRow] = getOneRowsFromSectionKey("attribute")
//
//                for row in rows {
//
//                    if (row.value.count == 0) {
//                        isAttribute = false
//                        warning("請先選擇\(row.title)")
//                    } else {
//                        let value: String = "{name:\(row.title),alias:\(row.key),value:\(row.value)}"
//                        selected_attributes.append(value)
//                    }
//                }
//
//                if (isAttribute) {
//
//                    Global.instance.addSpinner(superView: self.view)
//                    params["attribute"] = selected_attributes.joined(separator: "|")
//                    print(params)
//
//                    CartService.instance.update(params: params) { (success) in
//                        Global.instance.removeSpinner(superView: self.view)
//                        if success {
//                            var msg: String = ""
////                            if (self.cartItem_token == nil) {
////                                msg = "成功加入購物車了"
////                                self.cartItemCount += 1
////                                self.session.set("cartItemCount", self.cartItemCount)
////                            } else {
////                                msg = "已經更新購物車了"
////                            }
//                            //self.info(msg)
//                            self.info(msg: msg, showCloseButton: false, buttonTitle: "關閉") {
//                                self.toMemberCartList()
//                            }
//                        } else {
//                            self.warning(CartService.instance.msg)
//                        }
//                    }
//                }
            } else {
                
                toAddCart(
                    product_token: row.token,
                    login: { vc in vc.toLogin() },
                    register: { vc in vc.toRegister() }
                )
            }
        }
    }
}

extension ProductVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ProductListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? ProductTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
            
                cell.cellDelegate = self
                cell.updateViews(row!)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mysTable != nil {
            let row = lists1[indexPath.row]
            //toShowProduct(token: superProduct.token)
            let token = row.token
            if #available(iOS 13.0, *) {
                let storyboard = UIStoryboard(name: "More", bundle: nil)
                if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_PRODUCT)  as? ShowProductVC {
                    
                    viewController.token = token
                    show(viewController, sender: nil)
                }
            } else {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_PRODUCT) as! ShowProductVC
                viewController.token = token
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        }
    }
}
