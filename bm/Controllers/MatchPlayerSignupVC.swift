//
//  MatchPlayerSignup.swift
//  bm
//
//  Created by ives on 2023/4/26.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchPlayerSignupVC: BaseViewController {
    
    var match_group_token: String?
    
    var showTop2: ShowTop2?
    
    var table: MatchGroupTable?
    
    var formContainer: UIView = UIView()
    
    let nameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "姓名", icon: "member_on_svg", placeholder: "王大明", isRequired: true)
        
        return view
    }()
    
    let mobileTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "手機", icon: "mobile_svg", placeholder: "0960283457", isRequired: true, keyboard: KEYBOARD.numberPad)
        
        return view
    }()
    
    let emailTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "Email", icon: "email_svg", placeholder: "davie@gmail.com", isRequired: true, keyboard: KEYBOARD.emailAddress)
        
        return view
    }()
    
    override func viewDidLoad() {
        
        dataService = MatchGroupService.instance
        
        super.viewDidLoad()
        
        initTop()
        initForm()
        
        refresh(MatchGroupTable.self)
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
    }
    
    func initForm() {
        self.view.addSubview(formContainer)
        formContainer.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        formContainer.addSubview(nameTxt2)
        nameTxt2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        formContainer.addSubview(mobileTxt2)
        mobileTxt2.snp.makeConstraints { make in
            make.top.equalTo(nameTxt2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        formContainer.addSubview(emailTxt2)
        emailTxt2.snp.makeConstraints { make in
            make.top.equalTo(mobileTxt2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        if match_group_token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": match_group_token!, "member_token": Member.instance.token]
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
                            
                            guard let _myTable = t as? MatchGroupTable else { return }
                            self.table = _myTable
                            self.table!.filterRow()
                            
                            self.showTop2!.setTitle(self.table!.name)
                            //self.setIntroduceData()
                            //self.setSignupData()
                            
                            //self._tabPressed(self.focusTabIdx)
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
