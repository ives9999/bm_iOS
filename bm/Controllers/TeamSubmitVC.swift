//
//  TeamSubmitVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamSubmitVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

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
    var nameTxt: SuperTextField = SuperTextField()
    var leaderTxt: SuperTextField = SuperTextField()
    var mobileTxt: NumberTextField = NumberTextField()
    var emailTxt: EMailTextField = EMailTextField()
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //nameTxt = SuperTextField()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        //nameTxt = SuperTextField()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FormCell.self, forCellReuseIdentifier: "cell")
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        nameTxt.father = self
        //nameTxt.setupView()
        leaderTxt.father = self
        mobileTxt.father = self
        emailTxt.father = self
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
        let cell: FormCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FormCell
//        if cell == nil {
//            //print("cell is nil")
//            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
//            cell?.selectionStyle = .none
//        }
        
        let key: String = rows[indexPath.section][indexPath.row]
        let row: [String: String] = Team.instance.info[key]!
        var field: String = ""
        //var data: String = ""
        if let tmp: String = row["ch"] {
            field = tmp
        }
        let cellFrame: CGRect = cell.frame
        var editFrame: CGRect = CGRect(x: 15, y: 0, width: cellFrame.width, height: cellFrame.height)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                nameTxt.frame = editFrame
                //print("field: \(field)")
                nameTxt.placeholder(field)
                cell.addSubview(nameTxt)
                break
            default:
                print("default")
            }
            break;
        case 1:
            cell.textLabel!.text = "\(field)"
            let width: CGFloat = 250
            editFrame = CGRect(x: cellFrame.width - width, y: 0, width: width, height: cellFrame.height)
            var txt: SuperTextField = SuperTextField()
            switch indexPath.row {
            case 0:
                leaderTxt.frame = editFrame
                txt = leaderTxt
                break
            case 1:
                mobileTxt.frame = editFrame
                txt = mobileTxt
                break
            case 2:
                emailTxt.frame = editFrame
                txt = emailTxt
                break
            default:
                print("default")
            }
            cell.textLabel?.text = field
            cell.addSubview(txt)
            break;
        case 2:
            cell.textLabel!.text = "\(field)"
            switch indexPath.row {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            case 1:
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            default:
                print("default")
            }
        default:
            print("default")
        }
        
        //cell!.detailTextLabel!.text = "\(data)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let key: String = rows[indexPath.section][indexPath.row]
        //performSegue(withIdentifier: TO_EDIT_PROFILE, sender: key)
        switch indexPath.section {
        case 0:
            break
        case 1:
            switch indexPath.row {
            case 0:
                print(indexPath.row)
                //leaderTxt.becomeFirstResponder()
                break
            default:
                print("click")
            }
            break
        default:
            print("click")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.layer.backgroundColor = UIColor.clear.cgColor
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
