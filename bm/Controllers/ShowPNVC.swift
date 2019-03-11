//
//  ShowPNVC.swift
//  bm
//
//  Created by ives on 2019/3/7.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ShowPNVC: MyTableVC, PNCellDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: SuperLabel!
    @IBOutlet weak var emptyCons: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var clearBtn: SubmitButton!
    @IBOutlet weak var scrollView: SuperScrollView!
    
    var pnArr: [[String: String]]?

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        clearBtn.setTitle("全部清除")
        
        MyOneSignal.instance.save(id: "011", title: "eee", content: "這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1")
        
        let cellNib = UINib(nibName: "PNCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewDidLayoutSubviews() {
        changeScrollViewContentSize()
    }
    
    override func refresh() {
        pnArr = MyOneSignal.instance.getSession()
        if pnArr == nil || pnArr!.count == 0 {
            emptyLbl.isHidden = false
            emptyCons.constant = 20
            clearBtn.isHidden = true
        } else {
            emptyLbl.isHidden = true
            emptyCons.constant = 0
            clearBtn.isHidden = false
        }
        self.endRefresh()
        tableView.reloadData()
        changeScrollViewContentSize()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        let height: CGFloat = tableView.contentSize.height
        //let height: CGFloat = 10000
        //print(height)
        
        scrollView.contentSize = CGSize(width: frameWidth!, height: height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pnArr == nil {
            return 0
        } else {
            //print(pnArr!.count)
            return pnArr!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PNCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PNCell
        if pnArr != nil {
            let idx = indexPath.row
            let obj: [String: String] = pnArr![pnArr!.count-1-idx]
            let id = obj["id"]!
            var title: String?
            if obj["title"] != nil {
                title = obj["title"]!
            }
            let content: String = obj["content"]!
            cell.thisDelegate = self
            cell.update(id: id, title: title, content: content)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeightCons.constant = tableView.contentSize.height
    }
    
    func remove(id: String) {
        //print(id)
        warning(msg: "是否確定刪除此訊息", showCloseButton: true, buttonTitle: "刪除") {
            let b = MyOneSignal.instance.remove(id: id)
            if b {
                self.refresh()
            }
        }
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        warning(msg: "是否要刪除全部訊息", showCloseButton: true, buttonTitle: "刪除") {
            MyOneSignal.instance.clear()
            self.refresh()
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
