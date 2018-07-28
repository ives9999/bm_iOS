//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: MyTableVC {
    
    let _type:String = "arena"
    @IBOutlet weak var tableView: UITableView!
    internal(set) public var lists: [SuperData] = [SuperData]()

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        setIden(item:_type, titleField: "name")

        let cellNibName = UINib(nibName: "ListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listcell")
        
        refresh()
    }
    override func refresh() {
        page = 1
        getDataStart()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        ArenaService.instance.getList(type: iden, titleField: titleField, page: page, perPage: perPage, filter: nil) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    override func getDataEnd(success: Bool) {
        if success {
            let tmps: [SuperData] = ArenaService.instance.dataLists
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists = [SuperData]()
            }
            lists += tmps
            //print(self.lists)
            page = ArenaService.instance.page
            if page == 1 {
                totalCount = ArenaService.instance.totalCount
                perPage = ArenaService.instance.perPage
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
            
            let data = lists[indexPath.row]
            cell.updateViews(data: data, iden: _type)
            
            return cell
        } else {
            return ListCell()
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
