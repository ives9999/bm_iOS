//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let _type:String = "team"
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var managerBtn: UIButton!
    var iden: String!
    var titleField: String!
    var page: Int = 1
    var perPage: Int = PERPAGE
    var totalCount: Int = 100000
    @IBOutlet weak var tableView: UITableView!
    var totalPage: Int = 1
    var refreshControl: UIRefreshControl!
    internal(set) public var lists: [List] = [List]()
    
    override func viewDidLoad() {
        setIden(item:_type, titleField: "name")
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        managerBtn.layer.cornerRadius = 12
        
        tableView.backgroundColor = UIColor.clear
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNibName = UINib(nibName: "ListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listcell")
        
        refresh()
        Global.instance.menuPressedAction(menuBtn, self)
    }
    
    func setIden(item: String, titleField: String) {
        iden = item
        self.titleField = titleField
    }
    
    @objc func refresh() {
        page = 1
        getDataStart()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
            
            let list = lists[indexPath.row]
            cell.updateViews(list: list)
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.getList(type: iden, titleField: titleField, page: page, perPage: perPage, filter: nil) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    func getDataEnd(success: Bool) {
        if success {
            let tmps: [List] = TeamService.instance.dataLists
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists = [List]()
            }
            lists += tmps
            //print(self.lists)
            page = TeamService.instance.page
            if page == 1 {
                totalCount = TeamService.instance.totalCount
                perPage = TeamService.instance.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            tableView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_TEAM_MANAGER, sender: nil)
        }
    }
}
