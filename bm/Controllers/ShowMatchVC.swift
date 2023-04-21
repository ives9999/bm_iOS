//
//  ShowMatchVC.swift
//  bm
//
//  Created by ives on 2023/4/20.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class ShowMatchVC: BaseViewController {
    
    var showTop2: ShowTop2?
    
    var token: String?
    var table: MatchTable?

    override func viewDidLoad() {
        
        dataService = MatchService.instance
        
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("賽事內容")
        
        refresh(MatchTable.self)
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { [self] (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    do {
                        let t: Table = try JSONDecoder().decode(t, from: jsonData)
                        if (self.table != nil) {
                            if (self.table!.id == 0) {
                                //token錯誤，所以無法解析
                                self.warning("token錯誤，所以無法解析")
                            } else {
                                
                                guard let _myTable = t as? MatchTable else { return }
                                self.table = _myTable
                                self.table!.filterRow()
                                //self.setIntroduceData()
                                //self.setContentWeb()
                            }
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
}
