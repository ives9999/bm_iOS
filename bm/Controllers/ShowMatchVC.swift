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
    
    var showTab2: ShowTab2 = {
        let view: ShowTab2 = ShowTab2()
        
        return view
    }()
    
    let button_width: CGFloat = 120
    var bottom_button_count: Int = 1
    var showBottom: ShowBottom2?
    
    //var spacer: UIView = UIView()
    
    var scrollView: UIScrollView = UIScrollView()
    var introduceContentView: UIView = UIView()
    var matchContentView: UIView = UIView()
    
    var token: String?
    var table: MatchTable?

    override func viewDidLoad() {
        
        dataService = MatchService.instance
        
        super.viewDidLoad()
        
        initTop()
        initBottom()
        initTopTab()
        initScrollView()
        
        
        
        refresh(MatchTable.self)
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
    }
    
    func initBottom() {
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
        showBottom!.setSubmitBtnTitle("報名")
    }
    
    func initTopTab() {
        
        self.view.addSubview(showTab2)
        showTab2.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.horizontalEdges.equalToSuperview()
        }
        
        showTab2.tab1Name("說明")
        showTab2.tab2Name("內容")
        showTab2.tab3Name("報名")
    }
    
    private func initScrollView() {
        
        self.view.addSubview(scrollView)
        //scrollView.backgroundColor = UIColor.red
        scrollView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalToSuperview()
            make.top.equalTo(showTab2.snp.bottom).offset(20)
            make.bottom.equalTo(showBottom!.snp.top)
        }
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { [self] (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    //jsonData.prettyPrintedJSONString
                    do {
                        let t: Table = try JSONDecoder().decode(t, from: jsonData)
                        if (t.id == 0) {
                            //token錯誤，所以無法解析
                            self.warning("token錯誤，所以無法解析")
                        } else {
                            
                            guard let _myTable = t as? MatchTable else { return }
                            self.table = _myTable
                            self.table!.filterRow()
                            
                            self.showTop2!.setTitle(self.table!.name)
                            //self.setIntroduceData()
                            //self.setContentWeb()
                        }
                    } catch {
                        print(error.localizedDescription)
                        //self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
}
