//
//  ArenaReadVC.swift
//  bm
//
//  Created by ives on 2024/5/8.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class ArenaReadVC: BaseV2VC, ArenaReadCellDelegate {
    
    private var viewModel: ArenaReadViewModel?
    private var dao: ArenaReadDao = ArenaReadDao()
    private var list: [ArenaReadDao.Arena] = [ArenaReadDao.Arena]()
    
    var mainBottom2: MainBottom2 = MainBottom2(able_type: "arena")
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(bg_950)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        
        view.register(ArenaReadCell.self, forCellReuseIdentifier: "ArenaReadCell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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
            //make.top.equalTo(textLbl.snp.bottom)
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
        viewModel!.getList(page: page)
    }
    
    func toArenaShow(idx: Int) {
        let vc: ArenaShowVC = ArenaShowVC()
        vc.modalPresentationStyle = .fullScreen
        vc.token = self.list[idx].token
        show(vc, sender: nil)
    }
}

extension ArenaReadVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArenaReadCell", for: indexPath) as? ArenaReadCell {
            cell.arenaReadCellDelegate = self
            let row: ArenaReadDao.Arena = self.list[indexPath.row]
            cell.update(row: row, idx: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

extension ArenaReadVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("indexPath: \(indexPath.row)")
        let vc: ArenaShowVC = ArenaShowVC()
        vc.token = list[indexPath.row].token
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)
    }
    
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
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

//extension ArenaReadVC: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}

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

class ArenaReadCell: UITableViewCell {
    
    var idx: Int = 0
    var arenaReadCellDelegate: ArenaReadCellDelegate? = nil
    
    let container: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = UIColor(PrimaryBlock_950)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(gray_700).cgColor
        return view
    }()
    
    let memberContainer: UIView = {
        let view: UIView = UIView()
        //view.backgroundColor = UIColor.red
        return view
    }()
    
    let featuredIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        //view.backgroundColor = UIColor.yellow
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let cityLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextColor(UIColor(bg_300))
        view.setTextSize(14)
        return view
    }()
    
    let pvLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextColor(UIColor(bg_300))
        view.setTextSize(14)
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(18)
        view.setTextBold()
        view.setTextColor(UIColor(Primary_300))
        
        return view
    }()
    
    let avatarIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let memberNameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(15)
        view.setTextColor(UIColor(bg_300))
        
        return view
    }()
    
    let createdLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(15)
        view.setTextColor(UIColor(bg_300))
        
        return view
    }()
    
    let moreLbl: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(bg_300)
        //view.setTextSize(18)
        //view.setTextColor(UIColor(bg_300))
        view.text = "更多..."
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(bg_950)
//        let imageGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toArenaShow))
//        featruedIV.addGestureRecognizer(imageGR)
        
        anchor()
    }
    
    private func anchor() {
        
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        container.addSubview(featuredIV)
        featuredIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            //make.centerY.equalToSuperview()
            make.height.width.equalTo(90)
//            make.left.top.equalToSuperview().offset(8)
//            make.right.bottom.equalToSuperview().offset(-8)
        }
        
        let rg: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toArenaShow))
        rg.cancelsTouchesInView = true
        featuredIV.addGestureRecognizer(rg)
        
        container.addSubview(cityLbl)
        cityLbl.snp.makeConstraints { make in
            make.top.equalTo(featuredIV.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        container.addSubview(pvLbl)
        pvLbl.snp.makeConstraints { make in
            make.centerY.equalTo(cityLbl.snp.centerY)
            make.right.equalToSuperview().offset(-12)
        }
        
        let pvIcon: UIImageView = {
            let view: UIImageView = UIImageView()
            view.image = UIImage(named: "member_svg")
            view.tintColor = UIColor(bg_300)
            return view
        }()
        
        container.addSubview(pvIcon)
        pvIcon.snp.makeConstraints { make in
            make.centerY.equalTo(cityLbl.snp.centerY)
            make.right.equalTo(pvLbl.snp.left)
            make.width.height.equalTo(16)
        }
        
        container.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(cityLbl.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(12)
        }
        
        container.addSubview(memberContainer)
        memberContainer.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        memberContainer.addSubview(avatarIV)
        avatarIV.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(36)
            make.bottom.equalToSuperview()
        }
        
        memberContainer.addSubview(memberNameLbl)
        memberNameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.top)
            make.left.equalTo(avatarIV.snp.right).offset(6)
        }
        
        memberContainer.addSubview(createdLbl)
        createdLbl.snp.makeConstraints { make in
            make.bottom.equalTo(avatarIV.snp.bottom)
            make.left.equalTo(avatarIV.snp.right).offset(6)
        }
        
        memberContainer.addSubview(moreLbl)
        moreLbl.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(avatarIV.snp.centerY)
        }
        
        let moreGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toArenaShow))
        moreGR.cancelsTouchesInView = true
        moreLbl.addGestureRecognizer(moreGR)
    }

    func update(row: ArenaReadDao.Arena, idx: Int) {
        self.idx = idx
        var featured_path: String? = nil
        for image in row.images {
            if (image.isFeatured) {
                featured_path = image.path
                break
            }
        }
        
        if (featured_path != nil) {
            let width = UIScreen.main.bounds.width - 32
            let height = featuredIV.heightForUrl(url: featured_path!, width: width)
            featuredIV.snp.updateConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            featuredIV.downloaded(from: featured_path!, isCircle: false)
            featuredIV.tag = idx
        }
        cityLbl.text = row.zone.city_name
        pvLbl.text = row.pv.formattedWithSeparator
        
        nameLbl.text = "\(idx + 1). \(row.name)"
        
        avatarIV.downloaded(from: row.member.avatar)
        memberNameLbl.text = row.member.nickname
        createdLbl.text = row.created_at.noSec()
    }

    @objc func toArenaShow(_ sender: UITapGestureRecognizer) {
        //print(idx)
        arenaReadCellDelegate?.toArenaShow(idx: idx)
    }
}

protocol ArenaReadCellDelegate {
    func toArenaShow(idx: Int)
}

























































