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
    private var dao: ArenaReadDao = ArenaReadDao()
    private var list: [ArenaReadDao.Arena] = [ArenaReadDao.Arena]()
    
    var mainBottom2: MainBottom2 = MainBottom2(able_type: "arena")
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(bg_950)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        
        view.register(read_arena.self, forCellReuseIdentifier: "read_arena")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        viewModel = ArenaReadViewModel()
        
        viewModel!.isLoading.bind { [weak self] (isLoading) in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                //print("isLoading: \(isLoading)")
                if !isLoading {
                    Global.instance.removeSpinner(superView: self!.view)
                }
            }
        }
        
        viewModel!.dao.bind { [weak self] (dao) in
            guard let dao = dao else { return }
            DispatchQueue.main.async {
                self!.dao = dao
                self!.list += dao.data.rows
                self!.tableView.reloadData()
            }
        }
        
        getData()
    }
    
    // MARK: - init view for controller
    override func initView() {
        super.initView()
        
        let filterContainer: UIView = {
            let view = UIView()
            //view.backgroundColor = UIColor.white
            return view
        }()
        self.view.addSubview(filterContainer)
        filterContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(showTop2!.snp.bottom)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(mainBottom2)
        mainBottom2.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(72)
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(filterContainer.snp.bottom).offset(12)
            make.bottom.equalTo(mainBottom2.snp.top)
        }
        
        mainBottom2.delegate = self
    }
    
    func getData(page: Int = 1) {
        if page == 1 {
            list = [ArenaReadDao.Arena]()
        }
        Global.instance.addSpinner(superView: self.view)
        viewModel!.getData(page: page)
    }
}

extension ArenaReadVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "read_arena", for: indexPath) as? read_arena {
            let row: ArenaReadDao.Arena = self.list[indexPath.row]
            cell.update(row: row, idx: indexPath.row + 1)
            return cell
        }
        return UITableViewCell()
    }
}

extension ArenaReadVC: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("indexPath: \(indexPath.row)")
//    }
    
}

extension ArenaReadVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        // fetch data from API for those rows are being prefetched (near to visible area)
        let idx: Int = indexPaths[0].row + 1
        if idx > list.count-1 {
            let r = idx.quotientAndRemainder(dividingBy: PERPAGE)
            let pageIdx = r.quotient + 1
            //print("pageIdx \(pageIdx)")
            self.getData(page: pageIdx)
        }
        
//        indexPaths.forEach {
//            //print("prefetchRowsAt \($0.row)")
//            let idx: Int = $0.row + 1
//            if idx > list.count-1 {
//                let r = idx.quotientAndRemainder(dividingBy: PERPAGE)
//                let pageIdx = r.quotient + 1
//                //print("pageIdx \(pageIdx)")
//                self.getData(page: pageIdx)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

extension ArenaReadVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ArenaReadVC: MainBottom2Delegate {
    
    func to(able_type: String) {
//        switch able_type {
//        case "team": toSearch()
//        case "course": toCourse()
//        case "member": toMember()
//        case "arena": toArena()
//        case "more": toMore()
//        default:
//            toTeam()
//        }
    }
}


























































