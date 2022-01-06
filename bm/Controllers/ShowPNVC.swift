//
//  ShowPNVC.swift
//  bm
//
//  Created by ives on 2019/3/7.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import OneSignal


class ShowPNVC: MyTableVC, PNCellDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    //@IBOutlet weak var emptyLbl: SuperLabel!
    //@IBOutlet weak var emptyCons: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var clearBtn: SubmitButton!
    //@IBOutlet weak var scrollView: SuperScrollView!
    @IBOutlet weak var bottomView: StaticBottomView!
    @IBOutlet weak var setupSwitch: SuperSwitch!
    
    var pnArr: [[String: String]]?
    var isReceive: Bool = false

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        clearBtn.setTitle("全部清除")
        setupSwitch.isHidden = true
        
        //MyOneSignal.instance.save(id: "012", title: "eee", content: "這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1，這是測試內容1")
        
        let cellNib = UINib(nibName: "PNCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 800
        
        OneSignal.promptForPushNotifications { (accepted) in
            //print("User accepted notifications: \(accepted)")
            if !accepted {
                self.isReceive = false
            } else {
                self.isReceive = true
            }
            self.setupSwitch.isOn = self.isReceive
        }
        
        beginRefresh()
        //scrollView.addSubview(refreshControl)
        refresh()
        //UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewDidLayoutSubviews() {
        changeScrollViewContentSize()
    }
    
    override func refresh() {
        pnArr = MyOneSignal.instance.getSession()
        if pnArr == nil || pnArr!.count == 0 {
            //emptyLbl.isHidden = false
            //emptyCons.constant = 20
            clearBtn.isHidden = true
            //bottomView.isHidden = true
        } else {
            //emptyLbl.isHidden = true
            //emptyCons.constant = 0
            clearBtn.isHidden = false
            //bottomView.isHidden = false
        }
        self.endRefresh()
        tableView.reloadData()
        changeScrollViewContentSize()
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x != 0 {
//            scrollView.contentOffset.x = 0
//        }
//    }
    
    func changeScrollViewContentSize() {
        //let height: CGFloat = tableView.contentSize.height
        //let height: CGFloat = 10000
        //print(height)
        
        //scrollView.contentSize = CGSize(width: frameWidth!, height: height)
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
            var pnID = ""
            if obj["pnid"] != nil {
                pnID = obj["pnid"]!
            }
            var title: String?
            if obj["title"] != nil {
                title = obj["title"]!
            }
            let content: String = obj["content"]!
            cell.thisDelegate = self
            cell.update(id: id, title: title, content: content, pnID: pnID)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeightCons.constant = tableView.contentSize.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
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
    
    @IBAction func receivedChange(sender: UISwitch) {
        let receive = sender as! SuperSwitch
        //print(receive.isOn)
        info(msg: "iOS必須透過設定來開啟或關閉是否接收推播功能，因此應用程式將為您開啟設定，請設定完後，再回到羽球密碼", buttonTitle: "確定") {
            
            //OneSignal.presentAppSettings()
        }
    }
}
