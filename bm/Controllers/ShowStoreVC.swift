//
//  ShowStoreVC.swift
//  bm
//
//  Created by ives sun on 2020/10/27.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
import WebKit

class ShowStoreVC: ShowVC {
    
    var myTable: StoreTable?
    
    override func viewDidLoad() {

        dataService = StoreService.instance
        
        super.viewDidLoad()
        
//        tableRowKeys = ["tel_show","mobile_show","address","fb","line","website","email","business_time","pv","created_at_show"]
//        tableRows = [
//            "tel_show":["icon":"tel","title":"市內電話","content":""],
//            "mobile_show":["icon":"mobile","title":"行動電話","content":""],
//            "address":["icon":"map","title":"住址","content":""],
//            "fb":["icon":"fb","title":"FB","content":""],
//            "line":["icon":"line","title":"line","content":""],
//            "website":["icon":"website","title":"網站","content":""],
//            "email":["icon":"email1","title":"email","content":""],
//            "business_time":["icon":"clock","title":"營業時間","content":""],
//            "pv":["icon":"pv","title":"瀏覽數","content":""],
//            "created_at_show":["icon":"date","title":"建立日期","content":""]
//        ]
        
        refresh(StoreTable.self)
    }
    
    override func initData() {
        
        if myTable == nil {
            myTable = StoreTable()
        }
        
        myTable = table as? StoreTable
        var row: IconTextRow = IconTextRow(title: "市內電話", icon: "tel", show: myTable!.tel_show)
        memberRows.append(row)
        row = IconTextRow(title: "行動電話", icon: "mobile", show: myTable!.mobile_show)
        memberRows.append(row)
        row = IconTextRow(title: "住址", icon: "map", show: myTable!.address)
        memberRows.append(row)
        row = IconTextRow(title: "fb", icon: "fb", show: myTable!.fb)
        memberRows.append(row)
        row = IconTextRow(title: "line", icon: "line", show: myTable!.line)
        memberRows.append(row)
        row = IconTextRow(title: "EMail", icon: "email1", show: myTable!.email)
        memberRows.append(row)
        row = IconTextRow(title: "營業時間", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        row = IconTextRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
        memberRows.append(row)
        row = IconTextRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
        memberRows.append(row)
    }
    
//    override func viewWillLayoutSubviews() {
//        mainDataLbl.text = "體育用品店資料"
//        contentDataLbl.text = "詳細介紹"
//
//        mainDataLbl.setTextTitle()
//        contentDataLbl.setTextTitle()
//    }
    
    override func refresh() {
        refresh(StoreTable.self)
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
        
        super.setData()
        if table != nil {
            myTable = table as? StoreTable
            if (myTable != nil) {
                //setMainData(myTable!)
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let row: IconTextRow = memberRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            
//            let key = tableRowKeys[indexPath.row]
//            if tableRows[key] != nil {
//                let row = tableRows[key]!
//                let icon = row["icon"] ?? ""
//                let title = row["title"] ?? ""
//                var content = row["content"] ?? ""
//                if key == "fb" && !content.isEmpty {
//                    content = "連結請按此"
//                }
//                if key == "website" && !content.isEmpty {
//                    content = "連結請按此"
//                }
//                cell.update(icon: icon, title: title, content: content)
//                    //print("\(key):\(cell.frame.height)")
//            }
            
            if indexPath.row == memberRows.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.dataConstraintHeight.constant += heightOfTableView
                    
                    self.scrollContainerHeight += self.dataConstraintHeight.constant
                    self.containerViewConstraintHeight.constant = self.scrollContainerHeight
//                    self.tableViewConstraintHeight.constant = heightOfTableView
//                    self.changeScrollViewContentSize()
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    
    
//    override func changeScrollViewContentSize() {
//
//        let h1 = featured.bounds.size.height
//        let h2 = mainDataLbl.bounds.size.height
//        let h3 = tableViewConstraintHeight.constant
//        let h6 = contentDataLbl.bounds.size.height
//        let h7 = contentViewConstraintHeight!.constant
//
//        //print(contentViewConstraintHeight)
//
//        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + 300
//        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
//        containerViewConstraintHeight.constant = h
//        //print(h1)
//    }
}

