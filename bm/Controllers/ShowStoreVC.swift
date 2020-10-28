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
    
    @IBOutlet weak var featured: UIImageView!
    
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
        //refresh()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
//        let h2 = courseDataLbl.bounds.size.height
//        let h3 = tableViewConstraintHeight.constant
//        let h4 = coachDataLbl.bounds.size.height
//        let h5 = coachTableViewConstraintHeight.constant
//        let h6 = contentLbl.bounds.size.height
//        let h7 = contentViewConstraintHeight!.constant
//        let h8 = signupDataLbl.bounds.size.height
//        let h9 = signupTableViewConstraintHeight.constant
        //print(contentViewConstraintHeight)
        
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
//        let h: CGFloat = h1 + h2 + h3 + h4 + h5 + h6 + h7 + h8 + h9 + 300
//        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
//        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
}
