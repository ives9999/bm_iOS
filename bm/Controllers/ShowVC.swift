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

    var show_in: Show_IN?
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var content: String = ""
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguation = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguation)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        //print(show_in!)
        //webView.scrollView.isScrollEnabled = false
        //let content = "<div style='font-size:96px;background-color:#000;color:#FFF;'>This method calculates the zoom scale for the scroll view. A zoom scale of one indicates that the content is displayed at normal size. A zoom scale less than one shows he content zoomed out, and a zoom scale greater than one shows the content zoomed in. To get the minimum zoom scale, you first calculate the required zoom to fit the image view snugly within the scroll view based on its width. You then calculate the same for the height. You take the minimum of the width and height zoom scales, and set this for both minimumZoomScale and zoomScale on the scroll view. Thereby, you’ll initially see the entire image fully zoomed out, and you’ll be able to zoom out to this level too. Since the maximumZoomScale defaults to 1, you don’t need to set it. If you set it to greater than 1, the image may appear blurry when fully zoomed in. If you set it to less than 1, you wouldn’t be able to zoom in to the full image’s resolution. Finally, you also need to update the minimum zoom scale each time the controller updates its subviews. Add the following right before the previous method to do this:</div>"
        //webView.loadHTMLString(content, baseURL: nil)

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
    
    func initShowVC(sin: Show_IN) {
        self.show_in = sin
    }
    
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
        webView.loadHTMLString(content, baseURL: nil)
    }
    
    
}
