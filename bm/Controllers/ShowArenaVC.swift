//
//  ShowArenaVC.swift
//  bm
//
//  Created by ives sun on 2021/5/4.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowArenaVC: ShowVC {
    
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    
    var myTable: ArenaTable?
    
    override func viewDidLoad() {
        
        dataService = ArenaService.instance
        
        super.viewDidLoad()
//        tableRowKeys = ["tel_show","address","fb","interval_show","block_show","bathroom_show","air_condition_show","parking_show","pv","created_at_show"]
//        tableRows = [
//            "tel_show":["icon":"tel","title":"電話","content":""],
//            "address":["icon":"map","title":"住址","content":""],
//            "fb": ["icon":"fb","title":"FB","content":""],
//            "interval_show":["icon":"clock","title":"時段","content":""],
//            "block_show":["icon":"block","title":"場地","content":""],
//            "bathroom_show":["icon":"bathroom","title":"浴室","content":""],
//            "air_condition_show":["icon":"air_condition","title":"空調","content":""],
//            "parking_show":["icon":"parking","title":"停車場","content":""],
//            "pv":["icon":"pv","title":"瀏覽數","content":""],
//            "created_at_show":["icon":"date","title":"建立日期","content":""]
//        ]
        
        refresh(ArenaTable.self)
    }
    
    override func initData() {
        
        if myTable == nil {
            myTable = ArenaTable()
        }
        
        myTable = table as? ArenaTable
        var row: IconTextRow = IconTextRow(title: "電話", icon: "tel", show: myTable!.tel_show)
        memberRows.append(row)
        row = IconTextRow(title: "住址", icon: "map", show: myTable!.address)
        memberRows.append(row)
        row = IconTextRow(title: "fb", icon: "fb", show: myTable!.fb)
        memberRows.append(row)
        row = IconTextRow(title: "時段", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        row = IconTextRow(title: "場地", icon: "block", show: myTable!.block_show)
        memberRows.append(row)
        row = IconTextRow(title: "浴室", icon: "bathroom", show: myTable!.bathroom_show)
        memberRows.append(row)
        row = IconTextRow(title: "空調", icon: "air_condition", show: myTable!.air_condition_show)
        memberRows.append(row)
        row = IconTextRow(title: "停車場", icon: "parking", show: myTable!.air_condition_show)
        memberRows.append(row)
        row = IconTextRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
        memberRows.append(row)
        row = IconTextRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
        memberRows.append(row)
    }

//    override func viewWillLayoutSubviews() {
//        mainDataLbl.text = "球館資料"
//        contentDataLbl.text = "詳細介紹"
//
//        mainDataLbl.setTextTitle()
//        contentDataLbl.setTextTitle()
//    }
    
    override func refresh() {
        refresh(ArenaTable.self)
    }
    
    override func setData() {
        
        super.setData()
        if table != nil {
            myTable = table as? ArenaTable
            if (myTable != nil) {
                //setMainData(myTable!)
                tableView.reloadData()
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
//        //print(contentViewConstraintHeight)
//        
//        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
//        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + 300
//        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
//        containerViewConstraintHeight.constant = h
//        //print(h1)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return memberRows.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let row: IconTextRow = memberRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            
            //填入資料
//            let key = tableRowKeys[indexPath.row]
//            if tableRows[key] != nil {
//                let row = tableRows[key]!
//                let icon = row["icon"] ?? ""
//                let title = row["title"] ?? ""
//                let content = row["content"] ?? ""
//                cell.update(icon: icon, title: title, content: content)
//            }
            
            //計算高度
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
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}
