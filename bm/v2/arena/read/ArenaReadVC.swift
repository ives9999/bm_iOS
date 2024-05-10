//
//  ArenaReadVC.swift
//  bm
//
//  Created by ives on 2024/5/8.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class ArenaReadVC: BaseV2VC {
    
    private var viewModel: ArenaReadViewModel?
    private lazy var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = ArenaReadViewModel(repository: ArenaReadRepository())
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
