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
    
    
    lazy var tableView: MyTable2VC<MemberTeamMemberCell, TeamMemberTable> = {
        let tableView = MyTable2VC<MemberTeamMemberCell, TeamMemberTable>(didSelect: didSelect(item:at:), selected: tableViewSetSelected(row:))
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
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
//    var captureSession: AVCaptureSession!
//    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.setAnchor(parent: self.view)
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
        
        scanIV.image = UIImage(named: "scan")
        let scanRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleScan(sender:)))
        scanIV.addGestureRecognizer(scanRecognizer)
        
        tableView.anchor(parent: view, showTop: toolView)
        
        //setupBottomThreeView()
        
//        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
//        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
        panelHeight = 500
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.teamMemberList(token: token!, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                let b: Bool = self.tableView.parseJSON(jsonData: TeamService.instance.jsonData)
                if !b && self.tableView.msg.count == 0 {
                    self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop!)
                } else {
                    //tableView.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
    func didSelect<T: TeamMemberTable>(item: T, at indexPath: IndexPath) {
        
    }
    
    func tableViewSetSelected(row: TeamMemberTable)-> Bool {
        return false
    }
    
    @objc func handleScan(sender: UIView) {
        
        setupQRScanner()
        
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
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }
    
    private func setupQRScannerView() {
        
        let qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }
    
    private func showAlert() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self ] in
            let alert = UIAlertController(title: "錯誤", message: "羽球密碼APP需要使用相機", preferredStyle: .alert)
            alert.addAction(.init(title: "是", style: .default))
            self?.present(alert, animated: true)
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
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        let member_token = code
        qrScannerView.stopRunning()
        qrScannerView.removeFromSuperview()
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error.localizedDescription)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        
    }
}

class MemberTeamMemberCell: BaseCell<TeamMemberTable> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
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
        backgroundColor = UIColor(MY_BLACK)
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setSelectedBackgroundColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED1)
        selectedBackgroundView = bgColorView
    }
}

