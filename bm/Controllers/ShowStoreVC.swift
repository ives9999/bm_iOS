//
//  ShowStoreVC.swift
//  bm
//
//  Created by ives sun on 2020/10/27.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
import WebKit

class ShowStoreVC: Show1VC {
    
    var myTable: StoreTable?
    
    override func viewDidLoad() {

        dataService = StoreService.instance
        
        super.viewDidLoad()
        
        tableRowKeys = ["tel_show","mobile_show","address","fb","line","website","email","business_time","pv","created_at_show"]
        tableRows = [
            "tel_show":["icon":"tel","title":"市內電話","content":""],
            "mobile_show":["icon":"mobile","title":"行動電話","content":""],
            "address":["icon":"marker","title":"住址","content":""],
            "fb":["icon":"fb","title":"FB","content":""],
            "line":["icon":"line","title":"line","content":""],
            "website":["icon":"website","title":"網站","content":""],
            "email":["icon":"email1","title":"email","content":""],
            "business_time":["icon":"clock","title":"營業時間","content":""],
            "pv":["icon":"pv","title":"瀏覽數","content":""],
            "created_at_show":["icon":"calendar","title":"建立日期","content":""]
        ]
        
        refresh(StoreTable.self)
    }
    
    override func viewWillLayoutSubviews() {
        mainDataLbl.text = "體育用品店資料"
        contentDataLbl.text = "詳細介紹"
        
        mainDataLbl.setTextTitle()
        contentDataLbl.setTextTitle()
    }
    
//    override func refresh() {
//        if store_token != nil {
//            Global.instance.addSpinner(superView: view)
//            //print(Member.instance.token)
//            let params: [String: String] = ["token": store_token!, "member_token": Member.instance.token]
//            dataService.getOne(t: StoreTable.self, params: params) { (success) in
//                if (success) {
//                    let table: Table = StoreService.instance.table!
//                    self.myTable = table as? StoreTable
//
//                    if self.myTable != nil {
//                        self.setMainData()
//                        self.setFeatured()
//                        self.fromNet = true
//
//                        self.isLike = self.myTable!.like
//                        self.likeButton.initStatus(self.isLike, self.myTable!.like_count)
//
//                        self.tableView.reloadData()
//                    }
//                }
//                Global.instance.removeSpinner(superView: self.view)
//                self.endRefresh()
//            }
//        }
//    }
    
    override func setData() {
        
        if table != nil {
            myTable = table as? StoreTable
            if (myTable != nil) {
                setMainData(myTable!)
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                var content = row["content"] ?? ""
                if key == "fb" && !content.isEmpty {
                    content = "連結請按此"
                }
                if key == "website" && !content.isEmpty {
                    content = "連結請按此"
                }
                cell.update(icon: icon, title: title, content: content)
                    //print("\(key):\(cell.frame.height)")
            }
            
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let key = tableRowKeys[indexPath.row]
            if key == MOBILE_KEY {
                myTable!.mobile.makeCall()
            } else if key == LINE_KEY {
                myTable!.line.line()
            } else if key == FB_KEY {
                myTable!.fb.fb()
            } else if key == WEBSITE_KEY {
                myTable!.website.website()
            } else if key == EMAIL_KEY {
                myTable!.email.email()
            }
        }
    }
    
    
    
    override func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h6 = contentDataLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant

        //print(contentViewConstraintHeight)
        
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
}

