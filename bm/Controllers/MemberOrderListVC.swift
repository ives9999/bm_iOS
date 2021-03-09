//
//  MemberOrderList.swift
//  bm
//
//  Created by ives on 2021/2/21.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class MemberOrderListVC: MyTableVC {
    
    var superOrders: SuperOrders? = nil
    var params1: [String: Any]?
    internal(set) public var lists1: [SuperModel] = [SuperModel]()
    
    override func viewDidLoad() {
        myTablView = tableView
        myTablView.allowsMultipleSelectionDuringEditing = false
        myTablView.isUserInteractionEnabled = true
        dataService = OrderService.instance
//        _type = "order"
//        _titleField = "name"
//        searchRows = _searchRows
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "OrderListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "OrderListCell")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        refresh()
    }
    
    override func refresh() { //called by ListVC viewWillAppear
        page = 1
        getDataStart()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)

        dataService.getList(t: SuperOrder.self, t1: SuperOrders.self, token: Member.instance.token, _filter: params1, page: page, perPage: perPage) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            } else {
                Global.instance.removeSpinner(superView: self.view)
                self.warning(self.dataService.msg)
            }
        }
    }

    override func getDataEnd(success: Bool) {
        if success {
            let superModel: SuperModel = dataService.superModel
            superOrders = (superModel as! SuperOrders)
            //superCourses = CourseService.instance.superCourses
            let tmps: [SuperOrder] = superOrders!.rows

            //print(tmps)
            //print("===============")
            if page == 1 {
                lists1 = [SuperOrder]()
            }
            lists1 += tmps
            //print(self.lists)
            page = superOrders!.page
            if page == 1 {
                totalCount = superOrders!.totalCount
                perPage = superOrders!.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as? OrderListCell {
            
            let row = lists1[indexPath.row] as! SuperOrder
            //row.printRow()
            
            cell.updateOrderViews(indexPath: indexPath, row: row)
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if superOrders != nil {
            let superOrder = superOrders!.rows[indexPath.row]
            //toShowProduct(token: superProduct.token)
            let token = superOrder.token
            toPayment(order_token: token)
        }
    }
    
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //goHome()
        prev()
    }
}
