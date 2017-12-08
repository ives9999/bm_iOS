//
//  TempPlayShowVC.swift
//  bm
//
//  Created by ives on 2017/12/8.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayShowVC: MyTableVC {
    
    var token: String!
    var model: Team!
    var featured: UIImageView!

    // outlet
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bkView: UIImageView!
    
    override func viewDidLoad() {
        model = Team.instance
        myTablView = tableView
        
        super.viewDidLoad()

        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.getOne(type: "team", token: token) { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                //print(self.model.data)
                self.setPage()
                //self.tableView.reloadData()
            }
        }
        
        featured = UIImageView(frame: CGRect.zero)
        bkView.addSubview(featured)
    }
    
    func setPage() {
        titleLbl.text = (model.data[TEAM_NAME_KEY]!["value"] as! String)
        let img: UIImage = (model.data[TEAM_FEATURED_KEY]!["value"] as! UIImage)
        //let img: UIImage! = UIImage(named: "nophoto")
        let img_width: CGFloat = img.size.width
        let img_height: CGFloat = img.size.height
        //print(img_width)
        //print(img_height)
        let width: CGFloat = bkView.frame.width
        let height: CGFloat = width * (img_height / img_width)
        //featured.frame = CGRect(x: 0, y: headerView.frame.height, width: self.view.frame.width, height: img_height + 2*CELL_EDGE_MARGIN)
        
        featured.frame = CGRect(x: 0, y: 0, width: width, height: height)
        featured.image = img
        featured.contentMode = .scaleAspectFit
        //featured.image = UIImage(named: "nophoto")
        //featured.bringSubview(toFront: bkView)
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
