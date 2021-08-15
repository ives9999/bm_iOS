//
//  MyTableVC.swift
//  bm
//
//  Created by ives on 2017/11/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MyTableVC: BaseViewController, List1CellDelegate {

    var sections: [String]?
    var searchSections: [ExpandableItems] = [ExpandableItems]()
    
    var mySections: [[String: Any]] = [[String: Any]]()
    var myRows: [[String: Any]] = [[String: Any]]()
    
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
    var params: [String: Any] = [String: Any]()
    
    var lists1: [Table] = [Table]()
    var newY: CGFloat = 0
    
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
        
        let cellNibName = UINib(nibName: "List2Cell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "lis2Cell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
    }
    
    override func refresh() {
        page = 1
        getDataStart(page: page, perPage: PERPAGE)
    }
    
    func genericTable() {}
    func getDataStart(token: String? = nil, page: Int=1, perPage: Int=PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        //會員喜歡列表也一並使用此程式
        if (member_like) {
            MemberService.instance.likelist(able_type: able_type) { (success) in
                self.jsonData = MemberService.instance.jsonData
                self.getDataEnd(success: success)
            }
        } else {
            dataService.getList(token: token, _filter: params, page: page, perPage: perPage) { (success) in
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
    
    override func prepareParams(city_type: String="simple") {
        params = [String: Any]()
        for row in searchRows {
            
            if let key: String = row["key"] as? String {
                if let value: String = row["value"] as? String {
                    if value.count == 0 {
                        continue
                    }
                    params[key] = value
                }
            }
        }
        //print(params)
    }
    
    override func singleSelected(key: String, selected: String, show: String?=nil) {
        
        searchPanel.singleSelected(key: key, selected: selected, show: show)
    }
    
    override func setWeekdaysData(selecteds: [Int]) {
        
        searchPanel.setWeekdaysData(selecteds: selecteds)
    }
    
    override func setDegreeData(res: [DEGREE]) {
        
        searchPanel.setDegreeData(res: res)
    }
    
    override func setSwitch(indexPath: IndexPath, value: Bool) {
        
        searchPanel.setSwitch(indexPath: indexPath, value: value)
        
    }
    
    override func setTextField(key: String, value: String) {
        
        searchPanel.setTextField(key: key, value: value)
    }
    
    override func clear(indexPath: IndexPath) {
        let row = searchRows[indexPath.row]
        //print(row)
        
        let key = row["key"] as! String
        searchPanel.clear(key: key)
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

    func getDefinedRow(_ key: String) -> [String: Any] {
        for row in searchRows {
            if row["key"] as! String == key {
                return row
            }
        }
        return [String: Any]()
    }
    
    func getDefinedRow(_ section: Int, _ row: Int) -> [String: Any] {
        let key = searchSections[section].items[row]
        return getDefinedRow(key)
    }

    func replaceRows(_ key: String, _ row: [String: Any]) {
        for (idx, _row) in searchRows.enumerated() {
            if _row["key"] as! String == key {
                searchRows[idx] = row
                break;
            }
        }
    }
    
    //存在row的value只是單純的文字，陣列值使用","來區隔，例如"1,2,3"，但當要傳回選擇頁面時，必須轉回陣列[1,2,3]
    func valueToArray<T>(t:T.Type, row: [String: Any])-> [T] {

        var selecteds: [T] = [T]()
        //print(t)
        var type: String = "String"
        if (t.self == Int.self) {
            type = "Int"
        }
        if let value: String = row["value"] as? String {
            if (value.count > 0) {
                let values = value.components(separatedBy: ",")
                for value in values {
                    if (type == "Int") {
                        if let tmp = Int(value) {
                            selecteds.append(tmp as! T)
                        }
                    } else {
                        if let tmp = value as? T {
                            selecteds.append(tmp)
                        }
                    }
                }
            }
        }

        return selecteds
    }
    
    //目前暫時沒有用到
    func arrayToValue<T>(t: T.Type, res: [T])-> String {
        
        var value: String = ""
        
        var type: String = "String"
        if (t.self == Int.self) {
            type = "Int"
        }
        
        var values: [String] = [String]()
        if (res.count > 0) {
            for one in res {
                if (type == "Int") {
                    if let tmp: Int = one as? Int {
                        values.append(String(tmp))
                    }
                } else if (type == "String") {
                    values.append(one as! String)
                }
            }
            value = values.joined(separator: ",")
        } else {
            value = ""
        }
        
        return value
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        searchPanel.showSearchPanel(baseVC: self, view: view, newY: newY, searchRows: searchRows)
    }
    
    func cellRefresh() {
        params.removeAll()
        
        self.refresh()
    }
    
    func cellMobile(row: Table) {
        if (row.mobile_show.count > 0) {
            //print(row.mobile)
            row.mobile.makeCall()
        } else if (row.tel_show.count > 0) {
            //print(row.tel)
            row.tel.makeCall()
        }
    }
    
    func cellShowMap(row: Table) {
        
        var name: String = ""
        if row.name.count > 0 {
            name = row.name
        } else if row.title.count > 0 {
            name = row.title
        }
        //print(row.address)
        _showMap(title: name, address: row.address)
        
//        if indexPath != nil {
//            let row = lists1[indexPath!.row] as! TeamTable
//            if row.arena != nil {
//                //print(row.arena!.address)
//                _showMap(title: row.name, address: row.arena!.address)
//            } else {
//                warning("球隊沒有輸入球館位置")
//            }
//        } else {
//            warning("index path 為空值，請洽管理員")
//        }
    }
    
    func cellCity(row: Table) {
        let key: String = CITY_KEY
        let city_id: Int = row.city_id
        var row = getDefinedRow(key)
        row["value"] = String(city_id)
        replaceRows(key, row)
        prepareParams()
        refresh()
    }
    
    func cellArena(row: Table) {}
    func cellArea(row: Table) {}
    func cellEdit(row: Table) {}
    func cellDelete(row: Table) {}
    
    func cellLike(row: Table) {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            dataService.like(token: row.token, able_id: row.id)
        }
    }
    
    func cellWarning(msg: String) {
        warning(msg)
    }
    
    func cellToLogin() {
        toLogin()
    }
    
    @objc func handleExpandClose(gesture : UITapGestureRecognizer) {
        
        let headerView = gesture.view!
        let section = headerView.tag
        let tmp = headerView.subviews.filter({$0 is UIImageView})
        var mark: UIImageView?
        if tmp.count > 0 {
            mark = tmp[0] as? UIImageView
        }
        
        var indexPaths: [IndexPath] = [IndexPath]()
        
        let key: String = getSectionKey(idx: section)
        let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
        for (i, _) in rows.enumerated() {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        var isExpanded = getSectionExpanded(idx: section)
        if (mySections[section].keyExist(key: "isExpanded")) {
            mySections[section]["isExpanded"] = !isExpanded
            //searchSections[section].isExpanded = !isExpanded
        }
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
        isExpanded = !isExpanded
        if mark != nil {
            toggleMark(mark: mark!, isExpanded: isExpanded)
        }
    }
    
    func toggleMark(mark: UIImageView, isExpanded: Bool) {
        
        if (isExpanded) {
            mark.image = UIImage(named: "to_down")
        } else {
            mark.image = UIImage(named: "to_right")
        }
    }
    
    func getSectionName(idx: Int)-> String {
        
        var name: String = ""
        let row: [String: Any] = mySections[idx]
        if (row.keyExist(key: "name")) {
            if let tmp: String = row["name"] as? String {
                name = tmp
            }
        }
        
        return name
    }
    
    func getSectionKey(idx: Int)-> String {
        
        var key: String = ""
        let row: [String: Any] = mySections[idx]
        if (row.keyExist(key: "key")) {
            if let tmp: String = row["key"] as? String {
                key = tmp
            }
        }
        
        return key
    }
    
    func getSectionExpanded(idx: Int)-> Bool {
        
        var b: Bool = true
        let row: [String: Any] = mySections[idx]
        if (row.keyExist(key: "isExpanded")) {
            if let tmp: Bool = row["isExpanded"] as? Bool {
                b = tmp
            }
        }
        
        return b
    }
    
    func getRowFromKey(rows: [[String: String]], key: String)-> [String: String] {
        
        for row in rows {
            
            if let key1: String = row["key"] {
                if (key1 == key) {
                    return row
                }
            }
        }
        return [String: String]()
    }
    
    func replaceRowByKey(rows: [[String: String]], key: String, newRow: [String: String])-> [[String: String]] {
        
        var _rows = rows
        for (idx, row) in rows.enumerated() {
            
            if let key1: String = row["key"] {
                if (key1 == key) {
                    _rows[idx] = newRow
                    break
                }
            }
        }
        return _rows
    }
    
    //    myRows = [
    //        ["key":"data", "rows": fixedRows],
    //        ["key":"order", "rows": orderRows],
    //        ["key":"like", "rows": likeRows],
    //        ["key":"manager", "rows": courseRows],
    //    ]
        
    func getSectionRowFromMyRowsByKey(key: String)-> [String: Any] {
        
        for row in myRows {
            if let key1: String = row["key"] as? String {
                if key == key1 {
                    return row
                }
            }
        }
        
        return [String: Any]()
    }
        
    func getSectionRowFromMyRowsByIdx(idx: Int)-> [String: Any] {
        
        return myRows[idx]
    }
        
    //    let fixedRows: [[String: String]] = [
    //        ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
    //        ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD]
    //    ]
    func getRowRowsFromMyRowsByKey(key: String)-> [[String: String]] {
        
        let sectionRow: [String: Any] = getSectionRowFromMyRowsByKey(key: key)
        if (sectionRow.keyExist(key: "rows")) {
            if let tmp: [[String: String]] = sectionRow["rows"] as? [[String: String]] {
                return tmp
            }
        }
        
        return [[String: String]]()
    }
    
    func getRowRowsFromMyRowsByKey1(key: String) -> [String : String] {
        
        
        for sectionRow in myRows {
            if (sectionRow.keyExist(key: "rows")) {
                let rowRows = sectionRow["rows"] as! [[String: String]]
                for rowRow in rowRows {
                    if (rowRow["key"] == key) {
                        return rowRow
                    }
                }
            }
        }
        
        return [String: String]()
    }
    
    func replaceRowByKey(rowKey: String, _row: [String: String]) {
        
//        var tmp: [String: String] = [String: String]()
//        for (key, value) in _row {
//            if let _value: String = value as? String {
//                tmp[key] = _value
//            }
//        }
        
        //var sectionIdx: Int = -1
        var sectionKey: String = ""
        for (idx, row) in myRows.enumerated() {
            
            // row is  ["key":"product", "rows": productRows]
            if (row.keyExist(key: "rows")) {
                let rows: [[String: String]] = row["rows"] as! [[String: String]]
                for row1 in rows {
                    if let key1: String = row1["key"] {
                        if rowKey == key1 {
                            //sectionIdx = idx
                            //找出 section row 的 key
                            sectionKey = myRows[idx]["key"] as! String
                            break
                        }
                    }
                }
            }
        }
        
        replaceRowByKey(sectionKey: sectionKey, rowKey: rowKey, _row: _row)
        
//        if (sectionIdx >= 0) {
//            var rows: [[String: String]]? = myRows[sectionIdx]["rows"] as? [[String: String]]
//            if (rows != nil) {
//                for (idx, row) in rows!.enumerated() {
//                    // row is ["title": "商品","key":"product","value":"","show":""]
//                    if (row.keyExist(key: "key")) {
//                        if (row["key"] == rowKey) {
//                            rows![idx] = tmp
//                            break
//                        }
//                    }
//                }
//                myRows[sectionIdx]["rows"] = rows!
//            }
//        }
    }
    
    func replaceRowByKey(sectionKey: String, rowKey: String, _row: [String: String]) {
        
        var tmpRows: [[String: Any]] = [[String: Any]]()
        
        
        for (sectionIdx, sectionRow) in myRows.enumerated() {
            
            tmpRows = sectionRow["rows"] as! [[String: Any]]
            if let sectionKey1: String = sectionRow["key"] as? String {
                
                // 1.用section key找出 section row
                if (sectionKey1 == sectionKey) {
                    
                    if let sectionRows: [[String: Any]] = sectionRow["rows"] as? [[String : Any]] {
                        for (rowIdx, rowRow) in sectionRows.enumerated() {
                            
                            if let rowKey1: String = rowRow["key"] as? String {
                                
                                //2.用row key找出 row row
                                if (rowKey1 == rowKey) {
                                    tmpRows[rowIdx] = _row
                                }
                            }
                        }
                    }
                }
            }
            myRows[sectionIdx]["rows"] = tmpRows
        }
    }
    
    func replaceRowsByKey(sectionKey: String, rows: [[String: String]]) {
        
        for (sectionIdx, sectionRow) in myRows.enumerated() {
            
            if let sectionKey1: String = sectionRow["key"] as? String {
                if (sectionKey1 == sectionKey) {
                    myRows[sectionIdx]["rows"] = rows
                }
            }
        }
    }
    
    //["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
    func getRowFromIndexPath(indexPath: IndexPath)-> [String: String] {
        
        let section: Int = indexPath.section
        let key: String = getSectionKey(idx: section)
        let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
        let row: [String: String] = rows[indexPath.row]
        
        return row
    }
    
    func getRowValue(rowKey: String)-> String {
        
        let row = getRowRowsFromMyRowsByKey1(key: rowKey)
        var value: String = ""
        if let tmp: String = row["value"] {
            value = tmp
        }
        
        return value
    }
    
    func getRowShow(rowKey: String)-> String {
        
        let row = getRowRowsFromMyRowsByKey1(key: rowKey)
        var show: String = ""
        if let tmp: String = row["show"] {
            show = tmp
        }
        
        return show
    }
}

extension MyTableVC: UITableViewDataSource {
    
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
        
        if (lists1.count > 0) {
            return lists1.count
        }
        
        var count: Int?
        if rows == nil {
            count = 0
        } else {
            count = rows![section].count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Listcell", for: indexPath) as? List2Cell {
            
            cell.cellDelegate = self
            //let row = lists[indexPath.row]
            //cell.updateViews(indexPath: indexPath, data: row, iden: _type)
            
            return cell
        }
        
//        if var cell: FormCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FormCell {
//            cell = FormCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
//            cell.accessoryType = UITableViewCell.AccessoryType.none
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//            let row: [String: Any] = rows![indexPath.section][indexPath.row]
//            let field: String = row["text"] as! String
//            cell.textLabel!.text = field
//            return cell
//        }
        
        return UITableViewCell()
    }
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = sections?[section]
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: 34)
        headerView.addSubview(titleLabel)
        
        let mark = UIImageView(image: UIImage(named: "to_right"))
        mark.frame = CGRect(x: view.frame.width-10-20, y: (34-20)/2, width: 20, height: 20)
        headerView.addSubview(mark)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
        headerView.addGestureRecognizer(gesture)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UITableViewHeaderFooterView()
//        view.backgroundColor = UIColor.white
//        
//        return view
//    }
    
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
//        print("page:\(page)")
//        print("page:\(perPage)")
//        print("index.row:\(indexPath.row)")
        if indexPath.row == page * perPage - 2 {
            page += 1
//            print("current page: \(page)")
//            print(totalPage)
            if page <= totalPage {
                getDataStart(page: page, perPage: perPage)
            }
        }
    }
}

extension MyTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = lists1[indexPath.row]
        let iden = TO_SHOW
        
        performSegue(withIdentifier: iden, sender: data)
    }
}
