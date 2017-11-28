//
//  MyTableVC.swift
//  bm
//
//  Created by ives on 2017/11/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MyTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sections: [String]?
    var rows:[[Dictionary<String, Any>]]?
    internal var myTablView: UITableView!
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    
    convenience init(sections: [String], rows: [[Dictionary<String, Any>]]) {
        self.init(nibName:nil, bundle:nil)
        setData(sections: sections, rows: rows)
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

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FormCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? FormCell
        if cell == nil {
            //print("cell is nil")
            cell = FormCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell!.accessoryType = UITableViewCellAccessoryType.none
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        } else {
            //            if cell!.subviews.contains(nameTxt) {
            //                nameTxt.removeFromSuperview()
            //            }
            //            if cell!.subviews.contains(leaderTxt) {
            //                leaderTxt.removeFromSuperview()
            //            }
            //            if cell!.subviews.contains(mobileTxt) {
            //                mobileTxt.removeFromSuperview()
            //            }
            //            if cell!.subviews.contains(emailTxt) {
            //                emailTxt.removeFromSuperview()
            //            }
            //            if cell!.subviews.contains(tempFeeMTxt) {
            //                tempFeeMTxt.removeFromSuperview()
            //            }
            //            if cell!.subviews.contains(tempFeeFTxt) {
            //                tempFeeFTxt.removeFromSuperview()
            //            }
            //            if cell!.subviews.contains(ballTxt) {
            //                ballTxt.removeFromSuperview()
            //            }
            //            cell!.textLabel?.text = ""
            //            cell!.detailTextLabel?.text = ""
            cell!.accessoryType = .none
        }
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        let field: String = row["text"] as! String
        cell!.textLabel!.text = field
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //header and footer
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections![section]
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
}