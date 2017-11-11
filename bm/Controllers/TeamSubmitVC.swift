//
//  TeamSubmitVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamSubmitVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredView: ImagePickerView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    let sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    let rows: [[String]] = [
        [TEAM_NAME_KEY],
        [TEAM_LEADER_KEY, TEAM_MOBILE_KEY, TEAM_EMAIL_KEY],
        [TEAM_ZONE_ID_KEY, TEAM_ARENA_ID_KEY],
        [TEAM_DAY_KEY, TEAM_PLAY_START_KEY, TEAM_PLAY_END_KEY],
        [TEAM_TEMP_FEE_M_KEY, TEAM_TEMP_FEE_F_KEY, TEAM_TEMP_CONTENT_KEY],
        [TEAM_BALL_KEY, TEAM_DEGREE_KEY, TEAM_CHARGE_KEY, TEAM_CONTENT_KEY]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: FONT_NAME, size: FONT_SIZE_TITLE)
        header.textLabel!.textColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        let separator: UIView = UIView(frame: CGRect(x: 15, y: 0, width: footer.frame.width, height: 1))
        separator.layer.backgroundColor = UIColor("#6c6c6e").cgColor
        footer.addSubview(separator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            //print("cell is nil")
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key: String = rows[indexPath.section][indexPath.row]
        let row: [String: String] = Team.instance.info[key]!
        var field: String = ""
        var data: String = ""
        if let tmp: String = row["ch"] {
            field = tmp
        }
        /*if let tmp: Any = Team.instance.getData(key: key) {
            let type: String = row["type"]!
            if type == "String" {
                data = tmp as! String
                if data.count == 0 {
                    data = "未提供"
                }
            } else if type == "Int" {
                let tmp1 = tmp as! Int
                if key == VALIDATE_KEY {
                    data = Member.instance.validateShow(rawValue: tmp1)
                } else if key == MEMBER_TYPE_KEY {
                    data = Member.instance.typeShow(rawValue: tmp1)
                } else {
                    data = String(tmp1)
                }
            }
        }*/
        
        
        
        cell!.textLabel!.text = "\(field)"
        cell!.textLabel!.textColor = UIColor.white
        cell!.detailTextLabel!.text = "\(data)"
        cell!.detailTextLabel!.textColor = UIColor.white
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key: String = rows[indexPath.section][indexPath.row]
        performSegue(withIdentifier: TO_EDIT_PROFILE, sender: key)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            featuredView.setPickedImage(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let edit: EditProfileVC = segue.destination as! EditProfileVC {
            edit.key = sender as! String
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
