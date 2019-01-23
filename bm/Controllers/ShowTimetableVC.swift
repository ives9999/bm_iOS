//
//  ShowTimeTableVC.swift
//  bm
//
//  Created by ives on 2019/1/22.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ShowTimetableVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var tt_id: Int?
    var source: String?  //coach or arena
    var token: String?     // coach token or arena token
    let tableRowKeys:[String] = [TT_WEEKDAY,"date","interval",TT_CHARGE,TT_LIMIT,"signup"]
    var tableRows: [String: [String:String]] = [
        TT_WEEKDAY:["icon":"calendar","title":"日期","content":""],
        "date":["icon":"calendar","title":"期間","content":""],
        "interval":["icon":"clock","title":"時段","content":""],
        TT_CHARGE:["icon":"money","title":"收費","content":""],
        TT_LIMIT:["icon":"group","title":"接受報名人數","content":""],
        "signup":["icon":"group","title":"已報名人數","content":""]
    ]
    var timetable: Timetable?

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(tt_id)
//        print(source)
//        print(token)
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "IconCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")

        refresh()
    }
    
    override func refresh() {
        if tt_id != nil {
            TimetableService.instance.getOne(id: tt_id!, source: source!, token: token!) { (success) in
                if (success) {
                    self.timetable = TimetableService.instance.timetable
                    //let mirror: Mirror? = Mirror(reflecting: self.timetable!)
                    for key in self.tableRowKeys {
                        if (self.timetable!.responds(to: Selector(key))) {
                            let content: String = String(describing:(self.timetable!.value(forKey: key))!)
                            self.tableRows[key]!["content"] = content
                        }
//                        for property in mirror!.children {
//                            if key == property.label {
//                                var content: String = String(describing:(event.value(forKey: name))!)
//                                self.tableRows[key]!["content"] = content
//                            }
//                        }
                    }
                    print(self.tableRows)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell
        let key = tableRowKeys[indexPath.row]
        if tableRows[key] != nil {
            let row = tableRows[key]!
            let icon = row["icon"] ?? ""
            let title = row["title"] ?? ""
            let content = row["content"] ?? ""
            cell.update(icon: icon, title: title, content: content)
        }
        
        return cell
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
