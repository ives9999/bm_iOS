//
//  WebViewVC.swift
//  bm
//
//  Created by ives on 2022/7/3.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import WebKit

class WebViewVC: BaseViewController {
    
    @IBOutlet weak var top: Top!
    @IBOutlet weak var dataContainer: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "web view")
        top.delegate = self
        
        let request = URLRequest(url: URL(string: "http://bm.sportpassword.localhost/c2c.html?LogisticsType&LogisticsSubType=UNIMARTC2C&IsCollection=Y&Device=1&n=3")!)
        webView.load(request)
        
    }
}
