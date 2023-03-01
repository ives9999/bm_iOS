//
//  ManagerTeamMemberVC.swift
//  bm
//
//  Created by ives on 2022/10/30.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import AVFoundation
import MercariQRScanner

class ManagerTeamMemberVC: BaseViewController {
    
    
    lazy var tableView: MyTable2VC<ManagerTeamMemberCell, TeamMemberTable, ManagerTeamMemberVC> = {
        let tableView = MyTable2VC<ManagerTeamMemberCell, TeamMemberTable, ManagerTeamMemberVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var token: String? = nil
    
    var showTop: ShowTop2?
    
    var teamMemberTables: [TeamMemberTable] = [TeamMemberTable]()
    
    var toolView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(MY_BLACK)
        
        return view
    }()
    
    var scanIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.image = UIImage(named: "scan")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var qrScannerView: QRScannerView = QRScannerView(frame: CGRectZero)
    var isScanning: Bool = false
    let scanerWidth: Int = 300
    let scanerHeight: Int = 300
    
//    var cancelScanIV: UIImageView = {
//        let view: UIImageView = UIImageView()
//        view.image = UIImage(named: "delete")
//        view.isUserInteractionEnabled = true
//
//        return view
//    }()
    
    var member_token: String? //要加入會員的token
    var rows: [TeamMemberTable] = [TeamMemberTable]()
    
    var infoLbl: SuperLabel?
    
//    var captureSession: AVCaptureSession!
//    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.anchor(parent: self.view)
        showTop!.setTitle(title: "球隊隊員")
        
        view.addSubview(toolView)
        toolView.snp.makeConstraints { make in
            make.top.equalTo(showTop!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        toolView.addSubview(scanIV)
        scanIV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
//        toolView.addSubview(cancelScanIV)
//        cancelScanIV.snp.makeConstraints { make in
//            make.left.equalTo(scanIV.snp.right).offset(20)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(35)
//            make.height.equalTo(35)
//        }
        
        let scanRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleScan(sender:)))
        scanIV.addGestureRecognizer(scanRecognizer)
        
//        let cancelScanRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelScan(sender:)))
//        cancelScanIV.addGestureRecognizer(cancelScanRecognizer)
        
        //tableView = MyTable2VC(didSelect: didSelect(item:, at:), selected: tableViewSetSelected(row:), myDelegate: self)
        //tableView = ManagerTeamMemberTable(didSelect: didSelect(item:at:), selected: tableViewSetSelected(row:), myDelegate: self)
        tableView.anchor(parent: view, showTop: toolView)
        
        //setupBottomThreeView()
        
//        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
//        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
        panelHeight = 500
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        tableView.getDataFromServer(page: page)
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.teamMemberList(token: token!, page: page, perPage: tableView.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                //TeamService.instance.jsonData?.prettyPrintedJSONString
                let b: Bool = self.tableView.parseJSON(jsonData: TeamService.instance.jsonData)
                if !b && self.tableView.msg.count == 0 {
                    self.infoLbl = self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop!)
                } else {
                    self.infoLbl?.removeFromSuperview()
                    self.rows = self.tableView.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        
    }
    
    func deleteTeamMember(row: TeamMemberTable) {
        //print(row.member_nickname)
        warning(msg: "確定要刪除嗎？", closeButtonTitle: "取消", buttonTitle: "刪除") {
            Global.instance.addSpinner(superView: self.view)
            
            TeamService.instance.deleteTeamMember(token: row.token) { success in
                if success {
                    self.refresh()
                } else {
                    self.info("刪除失敗")
                }
            }
        }
    }
    
    func tableViewSetSelected(row: TeamMemberTable)-> Bool {
        return false
    }
    
    @objc func cancelScan(sender: UIView) {
        stopScan()
    }
    
    @objc func handleScan(sender: UIView) {
        
        if (!isScanning) {
            setupQRScannerView()
            startScan()
        } else {
            stopScan()
        }
        
//        captureSession = AVCaptureSession()
//
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return
//        }
//
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//        } else {
//            failed()
//            return
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)
//
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]
//        } else {
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
//
//        captureSession.startRunning()
    }
    
    private func setupQRScanner() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            startScan()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.startScan()
                    }
                }
            }
        default:
            showAlert()
        }
    }
    
    private func setupQRScannerView() {
        
//        let scannerTop: ShowTop2 = ShowTop2(delegate: self)
//        scannerTop.setAnchor(parent: self.view)
        
        //let qrScannerView: QRScannerView = QRScannerView()
        //let qrScannerView = QRScannerView(frame: view.bounds)
        let showTopHeight: Int = Int(showTop!.frame.height)
        let toolViewHeight: Int = Int(toolView.frame.height)
        let x: Int = (Int(screen_width) - scanerWidth) / 2
        let y: Int = showTopHeight + toolViewHeight + 100
        qrScannerView = QRScannerView(frame: CGRect(x: x, y: y, width: scanerWidth, height: scanerHeight))
        self.view.addSubview(qrScannerView)
        
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        //qrScannerView.startRunning()
    }
    
    private func showAlert() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self ] in
            let alert = UIAlertController(title: "錯誤", message: "羽球密碼APP需要使用相機", preferredStyle: .alert)
            alert.addAction(.init(title: "是", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func addTeamMember(member_token: String) {
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.addTeamMember(token: token!, member_token: member_token, manager_token: Member.instance.token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                do {
                    self.jsonData = TeamService.instance.jsonData
                    if (self.jsonData != nil) {
                        let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                        if (!successTable.success) {
                            
                            self.warning(successTable.parseMsgs())
                        } else {
                            self.refresh()
                        }
                    } else {
                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                    self.warning(self.msg)
                }
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        qrScannerView.stopRunning()
//    }
    
    
    
//    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//        captureSession = nil
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if (captureSession?.isRunning == false) {
//            captureSession.startRunning()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if (captureSession?.isRunning == true) {
//            captureSession.startRunning()
//        }
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//
//        captureSession.stopRunning()
//
//        if let metadataObject = metadataObjects.first {
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//            guard let stringValue = readableObject.stringValue else { return }
//            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: stringValue)
//        }
//
//        dismiss(animated: true)
//    }
//
//    func found(code: String) {
//        print(code)
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
}

extension ManagerTeamMemberVC: QRScannerViewDelegate {
    
    func startScan() {
        qrScannerView.startRunning()
        isScanning = true
        scanIV.image = UIImage(named: "delete")
    }
    
    func stopScan() {
        qrScannerView.remove()
        isScanning = false
        scanIV.image = UIImage(named: "scan")
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        //print(code)
        let member_token: String = code
        stopScan()
        addTeamMember(member_token: member_token)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        stopScan()
        print(error.localizedDescription)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        
    }
}

extension QRScannerView {
    
    func remove() {
        self.stopRunning()
        self.removeFromSuperview()
    }
}

//class ManagerTeamMemberTable: MyTable2VC<ManagerTeamMemberCell, TeamMemberTable, ManagerTeamMemberVC> {
//
//    typealias deleteClosure = ((TeamMemberTable) -> Void)?
//    //var delete: deleteClosure = nil
//    var thisDelegate: ManagerTeamMemberVC?
//
//    override init(didSelect: didSelectClosure, selected: selectedClosure, myDelegate: ManagerTeamMemberVC) {
//        super.init(didSelect: didSelect, selected: selected, myDelegate: myDelegate)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func cellForRow(atBaseTableIndexPath: IndexPath) -> UITableViewCell {
//        let cell = super.cellForRow(atBaseTableIndexPath: atBaseTableIndexPath) as! ManagerTeamMemberCell
//
//        if self.thisDelegate != nil {
//            cell.thisDelegate = self.thisDelegate
//        }
//
//        return cell
//    }
//}

class ManagerTeamMemberCell: BaseCell<TeamMemberTable, ManagerTeamMemberVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let avatarIV: Avatar = {
        let view = Avatar()
        return view
    }()
    
    let dataContainer: UIView = UIView()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let createdAtLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let deleteIV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "delete")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.2)
        return view
    }()
    
    //var thisDelegate: ManagerTeamMemberVC?
    
//    typealias deleteClosure = ((TeamMemberTable) -> Void)?
//    var delete: deleteClosure = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        anchor()
        
        let deleteGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteThis))
        deleteIV.addGestureRecognizer(deleteGR)
    }
    
    func anchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(avatarIV)
        avatarIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.width.height.equalTo(48)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.contentView.addSubview(dataContainer)
        //dataContainer.backgroundColor = UIColor.blue
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(avatarIV.snp.right).offset(18)
            make.top.equalToSuperview().offset(3)
            make.centerY.equalToSuperview()
        }
        
        self.dataContainer.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.top).offset(4)
            make.left.equalToSuperview()
        }
        
        self.dataContainer.addSubview(createdAtLbl)
        createdAtLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(avatarIV.snp.bottom).offset(-4)
        }
        
        self.contentView.addSubview(deleteIV)
        deleteIV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureSubViews() {
        noLbl.text = String(item!.no) + "."
        
        if item != nil && item!.memberTable != nil {
            self.avatarIV.path(item!.memberTable!.featured_path)
        }
        nameLbl.text = (item != nil && item!.memberTable != nil) ? item!.memberTable!.nickname : ""
        createdAtLbl.text = item?.created_at.noSec()
    }
    
    @objc func deleteThis(_ sender: UIView) {
        //print(item?.token)
//        if thisDelegate != nil {
//            thisDelegate!.deleteTeamMember(row: item!)
//        }
        
        myDelegate?.deleteTeamMember(row: item!)
    }
    
    func setDeleteClickListener() {
        
    }
}

