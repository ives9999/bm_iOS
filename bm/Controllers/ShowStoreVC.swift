//
//  ShowStoreVC.swift
//  bm
//
//  Created by ives sun on 2020/10/27.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ShowStoreVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.backgroundColor = UIColor.clear
        
//        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: "cell")
//        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
//        coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
//        initTableView()
//        initSignupTableView()
//        initCoachTableView()
//        initContentView()
//
//        signupButton.setTitle("報名")
        //signupListButton.setTitle("報名列表")
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
}
