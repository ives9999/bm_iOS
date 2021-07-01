//
//  ShowTeachVC.swift
//  bm
//
//  Created by ives sun on 2021/7/1.
//  Copyright © 2021 bm. All rights reserved.
//

import WebKit

class ShowTeachVC: UIViewController, WKUIDelegate {
    
    //var show_in: Show_IN?
    //var show: Dictionary<String, Any> = Dictionary<String, Any>()
    //var content: String = ""
    var webView: WKWebView!
    let type: String = "teach"
    var token: String?
    
    override func loadView() {
        let webConfiguation = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguation)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url: String? = nil
        if (token != nil) {
            url = String(format: URL_SHOW, type, token!)
            //print(url)
            //let myURL = URL(string: "http://bm.sportpassword.localhost/app/news/show/dBFcLdrDEAuk1WzPRXQvUw5aIcMNVun23yta7kPNddSqCqnquyTjmOMvgngBxUbSX7M55StEs27wgrzG3O0tacXpEMgw18VDSBQrhXs8jHWOkfjR4lXJP8YXuaalhue?device=app")
            let myRequest = URLRequest(url: URL(string: url!)!)
            webView.load(myRequest)
        }
        //print(show_in!)

//        DataService.instance.getShow(type: "news", id: show_in!.id, token: show_in!.token) { (success) in
//            if success {
//                self.content = DataService.instance.show_html
//                print(self.content)
//                self.reloadData()
//            }
//            Global.instance.removeSpinner()
//            Global.instance.removeProgressLbl()
//        }
        //Global.instance.addSpinner(center: self.view.center, superView: self.view)
        //Global.instance.addProgressLbl(center: self.view.center, superView: self.view)
    }
    
//    func initShowVC(sin: Show_IN) {
//        self.show_in = sin
//    }
    
    func reloadData() {
//        let title: String = show["title"] as? String ?? ""
//        titleLbl.text = title
//        if let image: UIImage = show["featured"] as? UIImage {
//            let width: CGFloat = image.size.width
//            let height: CGFloat = image.size.height
//            //print("width: \(width), height: \(height)")
//            let ratio: CGFloat = width / height
//            let newHeight = featured.frame.width / ratio
//            featuredHeight.constant = newHeight
//            featured.image = image
//        }
//        let content: String = show["content"] as? String ?? ""
//
//        label.text = content
        //webView.loadHTMLString(content, baseURL: nil)
    }
}
