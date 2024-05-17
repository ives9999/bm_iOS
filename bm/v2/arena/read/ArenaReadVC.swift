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
        initView()
        viewModel = ArenaReadViewModel(repository: ArenaReadRepository())
        
        viewModel!.isLoading.bind { [weak self] (isLoading) in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                print("isLoading: \(isLoading)")
            }
        }
        
        viewModel!.getData()
    }
    
    // MARK: - init view for controller
    override func initView() {
        super.initView()
        
        var filterContainer: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            return view
        }()
        self.view.addSubview(filterContainer)
        filterContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(showTop2!.snp.bottom)
            make.height.equalTo(50)
        }
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

extension ArenaReadVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


























































