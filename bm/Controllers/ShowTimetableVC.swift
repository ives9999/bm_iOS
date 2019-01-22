//
//  ShowTimeTableVC.swift
//  bm
//
//  Created by ives on 2019/1/22.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ShowTimetableVC: BaseViewController {
    
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var tt_id: Int?
    var source: String?  //coach or arena
    var token: String?     // coach token or arena token

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(tt_id)
//        print(source)
//        print(token)

        refresh()
    }
    
    override func refresh() {
        if tt_id != nil {
            TimetableService.instance.getOne(id: tt_id!, source: source!, token: token!) { (success) in
                if (success) {
                    
                }
            }
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
