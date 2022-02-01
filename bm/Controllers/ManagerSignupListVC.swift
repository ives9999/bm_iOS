//
//  ManagerTeamSignupLostVC.swift
//  bm
//
//  Created by ives on 2021/12/23.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ManagerSignupListVC: MyTableVC {
    
    var able_token: String?
    var able_title: String = ""
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var signupListResultTable: SignupListResultTable?
    var signupNormalTables: [SignupNormalTable] = [SignupNormalTable]()
    var signupSections: [SignupSection] = [SignupSection]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        if (able_type == "team") {
            dataService = TeamService.instance
        } else if (able_type == "course") {
            dataService = CourseService.instance
        }
        
        titleLbl.text = able_title + "報名會員列表"
        
        super.viewDidLoad()

        let cellNibName = UINib(nibName: "ManagerSignupListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "managerSignupListCell")
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataStart(page: page, perPage: PERPAGE)
    }
    
    override func getDataStart(token: String? = nil, page: Int=1, perPage: Int=PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        if (able_token != nil) {
            dataService.managerSignupList(able_type: able_type, able_token: able_token!, page: page, perPage: perPage) { (success) in
                
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    self.jsonData = self.dataService.jsonData
                    self.getDataEnd(success: success)
                }
            }
        } else {
            warning("沒有傳送管理者金鑰錯誤，請洽管理員")
        }
    }
    
    override func getDataEnd(success: Bool) {
        
        if (jsonData != nil) {
            genericTable()
            if page == 1 {
                if (signupListResultTable != nil) {
                    totalCount = signupListResultTable!.totalCount
                    perPage = signupListResultTable!.perPage
                    let _pageCount: Int = totalCount / perPage
                    totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                    //print(totalPage)
                }
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
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
//                let str = String(decoding: jsonData!, as: UTF8.self)
//                print(str)
                self.signupListResultTable = try JSONDecoder().decode(SignupListResultTable.self, from: jsonData!)
                if (self.signupListResultTable != nil) {
                    if (self.signupListResultTable!.success) {
                        self.signupNormalTables = self.signupListResultTable!.rows
                    } else {
                        warning(self.signupListResultTable!.msg)
                    }
                } else {
                    warning("解析JSON字串失敗，請洽管理員")
                }
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        
//        if (page == 1) {
//            lists1 = [SignupNormalTable]()
//        }
//        lists1 += signupNormalTables
        //var rows: [SignupNormalTable] = [SignupNormalTable]()
        //var sectionIdx: Int = 0
        
        for signupNormalTable in signupNormalTables {
            
            if (signupNormalTable.dateTable != nil) {
                
                let dateTable: DateTable = signupNormalTable.dateTable!
                let date: String = dateTable.date
                
                var bExist: Bool = false
                for signupSection in signupSections {
                    if (signupSection.date == date) {
                        signupSection.rows.append(signupNormalTable)
                        bExist = true
                    }
                }
                
                if (!bExist) {
                    let signupSection: SignupSection = SignupSection()
                    signupSection.date = date
                    signupSection.rows.append(signupNormalTable)
                    signupSections.append(signupSection)
                }
            }
        }
        
        //print(signupSections)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let count: Int = signupSections.count

        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 34
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = signupSections[section].date
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: 34)
        headerView.addSubview(titleLabel)
        
        var expanded_image: String = "to_right"
        if signupSections[section].isExpanded {
            expanded_image = "to_down"
        }
        let mark = UIImageView(image: UIImage(named: expanded_image))
        mark.frame = CGRect(x: view.frame.width-10-20, y: (34-20)/2, width: 20, height: 20)
        headerView.addSubview(mark)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
        headerView.addGestureRecognizer(gesture)
        
        return headerView
        //return UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        if (!signupSections[section].isExpanded) {
            count = 0
        } else {
            count = signupSections[section].rows.count
        }

        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "managerSignupListCell", for: indexPath) as? ManagerSignupListCell {
            
            let signupNormalTable = signupSections[indexPath.section].rows[indexPath.row]
            signupNormalTable.filterRow()
            cell.update(_row: signupNormalTable)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc override func handleExpandClose(gesture : UITapGestureRecognizer) {
        
        let headerView = gesture.view!
        let section = headerView.tag
        let tmp = headerView.subviews.filter({$0 is UIImageView})
        var mark: UIImageView?
        if tmp.count > 0 {
            mark = tmp[0] as? UIImageView
        }
        
        var indexPaths: [IndexPath] = [IndexPath]()
        
        let rows: [SignupNormalTable] = signupSections[section].rows
        for (i, _) in rows.enumerated() {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        var isExpanded = signupSections[section].isExpanded
        signupSections[section].isExpanded = !isExpanded
        
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
}

class SignupListResultTable: Codable {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var msg: String = ""
    var rows: [SignupNormalTable] = [SignupNormalTable]()
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        rows = try container.decodeIfPresent([SignupNormalTable].self, forKey: .rows) ?? [SignupNormalTable]()
    }
}

class SignupSection {
    
    var date: String = ""
    var rows: [SignupNormalTable] = [SignupNormalTable]()
    var isExpanded: Bool = true
}
