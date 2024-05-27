//
//  ArenaShowVC.swift
//  bm
//
//  Created by ives on 2024/5/24.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class ArenaShowVC: BaseV2VC {
    
    var token: String = ""
    private var viewModel: ArenaShowViewModel?
    private var dao: ArenaShowDao = ArenaShowDao()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextSize(22)
        
        return view
    }()
    
    let cityITT2: IconTextText2 = {
        let view = IconTextText2(icon: "location_svg", title: "縣市", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let areaITT2: IconTextText2 = {
        let view = IconTextText2(icon: "location_svg", title: "區域", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let addressITT2: IconTextText2 = {
        let view = IconTextText2(icon: "location_svg", title: "住址", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let telITT2: IconTextText2 = {
        let view = IconTextText2(icon: "phone_svg", title: "電話", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let timeITT2: IconTextText2 = {
        let view = IconTextText2(icon: "clock_svg", title: "營業時間", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let blockITT2: IconTextText2 = {
        let view = IconTextText2(icon: "check_svg", title: "場地", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let bathroomITT2: IconTextText2 = {
        let view = IconTextText2(icon: "bathroom_svg", title: "浴室", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let airConditionITT2: IconTextText2 = {
        let view = IconTextText2(icon: "check_svg", title: "空調", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let parkingITT2: IconTextText2 = {
        let view = IconTextText2(icon: "check_svg", title: "停車塲", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let fbITT2: IconTextText2 = {
        let view = IconTextText2(icon: "fb_svg", title: "FB", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(light_blue_A400)
        
        return view
    }()
    let youtubeITT2: IconTextText2 = {
        let view = IconTextText2(icon: "youtube_svg", title: "youtube", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(youtube)
        
        return view
    }()
    let lineITT2: IconTextText2 = {
        let view = IconTextText2(icon: "line_svg", title: "line", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()
    let websiteITT2: IconTextText2 = {
        let view = IconTextText2(icon: "website_svg", title: "網站", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(MY_WHITE)
        
        return view
    }()
    let pvITT2: IconTextText2 = {
        let view = IconTextText2(icon: "pv_svg", title: "瀏覽數", show: "", iconWidth: 18, iconHeight: 18)
        view.setIconColor(Primary_300)
        
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(token)

        initView()
        
        viewModel = ArenaShowViewModel()
        
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
                self!.setData()
            }
        }
        
        getData()
    }
    

    // MARK: - init view for controller
    override func initView() {
        super.initView()
        
        self.view.backgroundColor = UIColor(bg_950)
        
        let filterContainer: UIView = {
            let view = UIView()
            //view.backgroundColor = UIColor.white
            return view
        }()
        self.view.addSubview(filterContainer)
        filterContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            //make.top.equalTo(textLbl.snp.bottom)
            make.top.equalTo(showTop2!.snp.bottom)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(filterContainer.snp.bottom).offset(24)
        }
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.alignment = .leading
            view.spacing = 8
            return view
        }()
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(nameLbl.snp.bottom).offset(24)
        }
        
        stackView.addArrangedSubview(cityITT2)
        stackView.addArrangedSubview(areaITT2)
        stackView.addArrangedSubview(addressITT2)
        stackView.addArrangedSubview(telITT2)
        stackView.addArrangedSubview(timeITT2)
        stackView.addArrangedSubview(blockITT2)
        stackView.addArrangedSubview(bathroomITT2)
        stackView.addArrangedSubview(airConditionITT2)
        stackView.addArrangedSubview(parkingITT2)
        stackView.addArrangedSubview(fbITT2)
        stackView.addArrangedSubview(youtubeITT2)
        stackView.addArrangedSubview(lineITT2)
        stackView.addArrangedSubview(websiteITT2)
        stackView.addArrangedSubview(pvITT2)
    }
    
    func getData() {
        Global.instance.addSpinner(superView: self.view)
        viewModel!.getOne(token: token)
    }
    
    func setData() {
        nameLbl.text = dao.data.name
        cityITT2.setShow(dao.data.zone!.city_name)
        areaITT2.setShow(dao.data.zone!.area_name)
        addressITT2.setShow(dao.data.zone!.city_name + dao.data.zone!.area_name + String(dao.data.zip) + dao.data.road)
        telITT2.setShow(dao.data.tel)
        timeITT2.setShow(dao.data.open_time.noSec() + "~" + dao.data.close_time.noSec())
        blockITT2.setShow(dao.data.block <= 0 ? "未提供" : String(dao.data.block))
        if dao.data.bathroom < 0 {
            bathroomITT2.setShow("未提供")
        } else if dao.data.bathroom == 0 {
            bathroomITT2.setShow("無")
        } else {
            bathroomITT2.setShow("\(dao.data.bathroom)間")
        }
        airConditionITT2.setShow(dao.data.air_condition <= 0 ? "未提供" : String(dao.data.air_condition))
        parkingITT2.setShow(dao.data.parking <= 0 ? "未提供" : String(dao.data.parking))
        fbITT2.setShow(dao.data.fb)
        youtubeITT2.setShow(dao.data.youtube)
        lineITT2.setShow(dao.data.line)
        websiteITT2.setShow(dao.data.website)
        pvITT2.setShow(dao.data.pv.formattedWithSeparator)
    }
}
