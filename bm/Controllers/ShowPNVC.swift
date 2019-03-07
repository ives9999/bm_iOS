//
//  ShowPNVC.swift
//  bm
//
//  Created by ives on 2019/3/7.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ShowPNVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: SuperLabel!
    @IBOutlet weak var emptyCons: NSLayoutConstraint!

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
