//
//  ShowVC.swift
//  bm
//
//  Created by ives on 2017/10/13.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowVC: UIViewController, WKUIDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    var show_in: Show_IN?
    //var show: Dictionary<String, Any> = Dictionary<String, Any>()
    //var content: String = ""
    var webView: WKWebView!
    
//    override func loadView() {
//        let webConfiguation = WKWebViewConfiguration()
//        webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height) , configuration: webConfiguation)
//        webView.uiDelegate = self
//        view = webView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguation = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.height) , configuration: webConfiguation)
        webView.uiDelegate = self
        self.view.addSubview(webView)
        titleLbl.text = show_in!.title
        
        let url: String = String(format: URL_SHOW, show_in!.type, show_in!.token)
        //print(url)
        //let myURL = URL(string: "http://bm.sportpassword.localhost/app/news/show/dBFcLdrDEAuk1WzPRXQvUw5aIcMNVun23yta7kPNddSqCqnquyTjmOMvgngBxUbSX7M55StEs27wgrzG3O0tacXpEMgw18VDSBQrhXs8jHWOkfjR4lXJP8YXuaalhue?device=app")
        let myRequest = URLRequest(url: URL(string: url)!)
        webView.load(myRequest)
    }
    
    func initShowVC(sin: Show_IN) {
        self.show_in = sin
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
