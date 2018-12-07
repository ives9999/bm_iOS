//
//  ColorSelectVC.swift
//  bm
//
//  Created by ives on 2018/12/6.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol ColorSelectDelegate: class {
    func setColorData(res: [MYCOLOR], indexPath: IndexPath?)
}

class ColorSelectVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var selecteds: [MYCOLOR] = [MYCOLOR]()
    var delegate: ColorSelectDelegate?
    //選擇的類型：just one單選，multi複選
    var select: String = "just one"
    var indexPath: IndexPath?
    var allColors: [[String: Any]] = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "顏色"
        
        allColors = MYCOLOR.all()
        
        let cellNib = UINib(nibName: "ColorSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    @objc func submit() {
        
        self.delegate?.setColorData(res: selecteds, indexPath: indexPath)
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allColors.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColorSelectCell

        let colorDict = allColors[indexPath.row]
        //print(colorDict)
        if colorDict["color"] != nil {
            cell.colorLbl.backgroundColor = (colorDict["color"] as! UIColor)
        }
        var thisColorType: MYCOLOR?
        if colorDict["value"] != nil {
            thisColorType = (colorDict["value"] as! MYCOLOR)
        }
        var isSelected = false
        if thisColorType != nil {
            for colorType in selecteds {
                if colorType == thisColorType {
                    isSelected = true
                    break
                }
            }
        }
        if isSelected {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(MY_GREEN)
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            cell.tintColor = UIColor.white
        } else {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(MY_GREEN)
        }
        
        let colorDict = allColors[indexPath.row]
        var colorType: MYCOLOR?
        if colorDict["value"] != nil {
            colorType = (colorDict["value"] as! MYCOLOR)
        }
        var isExist = false
        var at = 0
        for (idx, selectColor) in selecteds.enumerated() {
            if colorType != nil {
                if selectColor == colorType! {
                    isExist = true
                    at = idx
                    break
                }
            }
        }
        if isExist {
            selecteds.remove(at: at)
        } else {
            if select == "just one" {
                selecteds.removeAll()
            }
            selecteds.append(colorType!)
        }
        if select == "just one" && selecteds.count > 0 {
            submit()
        }
    }
}
