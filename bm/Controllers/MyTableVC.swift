//
//  MyTableVC.swift
//  bm
//
//  Created by ives on 2017/11/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MyTableVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var sections: [String]?
    var section_keys: [[String]] = [[String]]()
    var rows:[[Dictionary<String, Any>]]?
    internal var myTablView: UITableView!
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    
    var form: BaseForm!
    
    var page: Int = 1
    var perPage: Int = PERPAGE
    var totalCount: Int = 100000
    var totalPage: Int = 1
    
    var iden: String!
    var titleField: String!
    
    var member_like: Bool = false
    var able_type: String = "coach"
    var jsonData: Data? = nil
    var tables: Tables?
    var params: [String: Any]?
    
//    sections = ["商品", "訂單", "付款", "訂購人"]
//    rows = [
//        [["name":"商品名稱", "value":"value"],["name":"商品屬性", "value":"attributes"]],
//        [["name":"訂單編號", "value":"no"],["name":"商品金額", "value":"amount"],["name":"商品數量", "value":"quantity"],["name":"運費", "value":"shipping_fee"]],
//        [["name":"訂單總金額", "value":"amount"],["name":"訂單建立時間", "value":"create_at"],["name":"付款方式", "value":"gateway"],["name":"到貨方式", "value":"method"]],
//        [["name":"訂購人姓名", "value":"order_name"], ["name":"訂購人電話", "value":"order_tel"], ["name":"訂購人EMail", "value":"order_email"], ["name":"訂購人住址", "value":"order_address"]]
//    ]
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var menuBtn: UIButton!
    
    convenience init(sections: [String], rows: [[Dictionary<String, Any>]]) {
        self.init(nibName:nil, bundle:nil)
        //setData(sections: sections, rows: rows)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //nameTxt = SuperTextField()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        //nameTxt = SuperTextField()
        super.init(coder: aDecoder)
    }
    
    func setData(sections: [String], rows: [[Dictionary<String, Any>]]) {
        self.sections = sections
        self.rows = rows
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameWidth = view.bounds.size.width
        //print("frame width: \(frameWidth)")
        frameHeight = view.bounds.size.height
        myTablView.backgroundColor = UIColor.clear
        myTablView.delegate = self
        myTablView.dataSource = self

        beginRefresh()
        myTablView.addSubview(refreshControl)
        
        if form != nil {
            sections = form.getSections()
            section_keys = form.getSectionKeys()
        }
    }
    
    override func refresh() {
        page = 1
        getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataStart<T: Tables>(t: T.Type, page: Int = 1, perPage: Int = PERPAGE) {
        
        Global.instance.addSpinner(superView: self.view)
        
        //會員喜歡列表也一並使用此程式
        if (member_like) {
            MemberService.instance.likelist(able_type: able_type) { (success) in
                self.jsonData = MemberService.instance.jsonData
                self.getDataEnd(success: success)
            }
        } else {
            dataService.getList(token: nil, _filter: params, page: page, perPage: perPage) { (success) in
                self.jsonData = self.dataService.jsonData
                self.getDataEnd(success: success)
            }
        }
    }
    
//    func _dataToTable<T: Tables>(t: T.Type, _ success: Bool) {
//        if (success) {
//            var s: T? = nil
//            do {
//                if (jsonData != nil) {
//                    s = try JSONDecoder().decode(t, from: jsonData!)
//                } else {
//                    warning("無法從伺服器取得正確的json資料，請洽管理員")
//                }
//            } catch {
//                msg = "解析JSON字串時，得到空值，請洽管理員"
//            }
//            if (s != nil) {
//                tables = s!
//                getDataEnd(success: success)
//            }
//            Global.instance.removeSpinner(superView: view)
//        } else {
//            Global.instance.removeSpinner(superView: view)
//            warning(dataService.msg)
//        }
//    }
    
    func genericTable() {}
    func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        //會員喜歡列表也一並使用此程式
        if (member_like) {
            MemberService.instance.likelist(able_type: able_type) { (success) in
                self.jsonData = MemberService.instance.jsonData
                self.getDataEnd(success: success)
            }
        } else {
            dataService.getList(token: nil, _filter: params, page: page, perPage: perPage) { (success) in
                self.jsonData = self.dataService.jsonData
                self.getDataEnd(success: success)
            }
        }
    }
    
    func getDataEnd(success: Bool) {
        
        if (jsonData != nil) {
            genericTable()
            if page == 1 {
                totalCount = tables!.totalCount
                perPage = tables!.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(totalPage)
            }
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        } else {
            warning("沒有取得回傳的json字串，請洽管理員")
        }
        Global.instance.removeSpinner(superView: view)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int?
        if sections == nil {
            count = 1
        } else {
            count = sections!.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if rows == nil {
            count = 0
        } else {
            count = rows![section].count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FormCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? FormCell
        if cell == nil {
            //print("cell is nil")
            cell = FormCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell!.accessoryType = .none
        }
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        let field: String = row["text"] as! String
        cell!.textLabel!.text = field
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    //header and footer
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections == nil {
            return nil
        } else {
            return sections![section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.backgroundColor = UIColor.white
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.backgroundColor = UIColor.white

        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont(name: FONT_NAME, size: FONT_SIZE_TITLE)
            //header.textLabel!.textColor = UIColor("#A6D903")
            header.textLabel?.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        let separator: UIView = UIView(frame: CGRect(x: 15, y: 0, width: footer.frame.width, height: 1))
        separator.layer.backgroundColor = UIColor("#6c6c6e").cgColor
        //footer.addSubview(separator)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if indexPath.row == page * perPage - 2 {
            page += 1
            //print("current page: \(page)")
            //print(totalPage)
            if page <= totalPage {
                getDataStart(page: page, perPage: perPage)
            }
        }
    }
    
    func getFormItemFromIdx(_ indexPath: IndexPath)-> FormItem? {
        let key = section_keys[indexPath.section][indexPath.row]
        return getFormItemFromKey(key)
    }
    
    func getFormItemFromKey(_ key: String)-> FormItem? {
        var res: FormItem? = nil
        for formItem in form.formItems {
            if key == formItem.name {
                res = formItem
                break
            }
        }
        
        return res
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //let idx = scrollView.contentOffset.y
//        let indexPath = tableView.indexPathsForVisibleRows?.last
//        if indexPath?.row == 5 {
//            refresh()
//        }
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        refresh()
//    }
}
