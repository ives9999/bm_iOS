//
//  SingleSelectVC.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SingleSelectVC: MyTableVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var key: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func submit() {
        
        //self.delegate?.setStatusData(res: selected!, indexPath: indexPath)
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
