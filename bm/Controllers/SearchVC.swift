//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class SearchVC: MyTableVC, UINavigationControllerDelegate, CitySelectDelegate, ArenaSelectDelegate, DaysSelectDelegate, TimeSelectDelegate, TextInputDelegate, DegreeSelectDelegate, TeamSubmitCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var type: String!
    var model: Team!
    var _rows: [[String: Any]]!
    
    var citys: [City] = [City]()
    
    override func viewDidLoad() {
        model = Team.instance
        myTablView = tableView
        super.viewDidLoad()
        tableView.register(TeamSubmitCell.self, forCellReuseIdentifier: "cell")
        _rows = [
            ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":""],
            ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
//            ["ch": "區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":"team_area","show":"全部","segue":TO_ARENA,"sender":0],
            ["ch":"日期","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_DAYS_KEY,"show":"全部","segue":TO_DAY,"sender":[Int]()],
            ["ch":"時段","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_INTERVAL_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()]
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TeamSubmitCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSubmitCell
        cell.teamSubmitCellDelegate = self
        let row: [String: Any] = _rows[indexPath.row]
        cell.forRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: [String: Any] = _rows[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! TeamSubmitCell
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            if row["segue"] != nil {
                let segue: String = row["segue"] as! String
                //print(iden)
                let city: Int = model.data[TEAM_CITY_KEY]!["value"] as! Int
                if segue == TO_ARENA && city == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
                } else {
                    performSegue(withIdentifier: segue, sender: row["sender"])
                }
            }
        } else {
            cell.generalTextField.becomeFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationNavigationController: UINavigationController?
        if segue.identifier == TO_CITY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let citySelectVC: CitySelectVC = destinationNavigationController!.topViewController as! CitySelectVC
            citySelectVC.delegate = self
            citySelectVC.type = "simple"
            citySelectVC.select = "multi"
            var selects: [Int] = [Int]()
            for city in citys {
                selects.append(city.id)
            }
            citySelectVC.selects = selects
        } else if segue.identifier == TO_ARENA {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let arenaSelectVC: ArenaSelectVC = destinationNavigationController!.topViewController as! ArenaSelectVC
            arenaSelectVC.delegate = self
            arenaSelectVC.selectedID = (sender as! [String: Int])
        } else if segue.identifier == TO_DAY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let daysSelectVC: DaysSelectVC = destinationNavigationController!.topViewController as! DaysSelectVC
            daysSelectVC.selectedDays = (sender as! [Int])
            daysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let timeSelectVC: TimeSelectVC = destinationNavigationController!.topViewController as! TimeSelectVC
            timeSelectVC.delegate = self
            timeSelectVC.input = (sender as! [String: Any])
        } else if segue.identifier == TO_TEXT_INPUT {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let textInputVC: TextInputVC = destinationNavigationController!.topViewController as! TextInputVC
            textInputVC.delegate = self
            textInputVC.input = (sender as! [String: Any])
        } else if segue.identifier == TO_SELECT_DEGREE {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let degreeSelectVC: DegreeSelectVC = destinationNavigationController!.topViewController as! DegreeSelectVC
            degreeSelectVC.delegate = self
            degreeSelectVC.selectedDegrees = (sender as! [String])
        }
    }
    
    
    func setCityData(id: Int, name: String) {
        //not use
    }
    func setCitysData(res: [City]) {
        //print(res)
        var row = getDefinedRow(TEAM_CITY_KEY)
        var texts: [String] = [String]()
        citys = res
        if citys.count > 0 {
            for city in citys {
                let text = city.name
                texts.append(text)
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        _rows[1] = row
        tableView.reloadData()
    }
    
    func setArenaData(id: Int, name: String) {
        
    }
    
    func setDaysData(res: [Int]) {
        
    }
    
    func setTimeData(time: String, type: SELECT_TIME_TYPE) {
        
    }
    
    func setTextInputData(text: String, type: TEXT_INPUT_TYPE) {
        
    }
    
    func setDegreeData(degrees: [String]) {
        
    }
    
    func setTextField(iden: String, value: String) {
        
    }
    
    private func getDefinedRow(_ key: String) -> [String: Any] {
        for row in _rows {
            if row["key"] as! String == key {
                return row
            }
        }
        return [String: Any]()
    }

    @IBAction func submitBtnPressed(_ sender: Any) {
        print("submit")
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
