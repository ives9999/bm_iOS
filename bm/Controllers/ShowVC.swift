//
//  ShowVC.swift
//  bm
//
//  Created by ives on 2017/10/13.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowVC: UIViewController, WKNavigationDelegate {


    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredHeight: NSLayoutConstraint!

    var show_in: Show_IN?
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(show_in!)

        DataService.instance.getShow(type: "news", id: show_in!.id, token: show_in!.token) { (success) in
            if success {
                self.show = DataService.instance.show
                //print(self.show)
                self.reloadData()
            }
            Global.instance.removeSpinner()
            Global.instance.removeProgressLbl()
        }
        Global.instance.addSpinner(center: self.view.center, superView: self.view)
        Global.instance.addProgressLbl(center: self.view.center, superView: self.view)
        //webView.addObserver(self, forKeyPath: "webView.scrollView.contentSize", options: .new, context: nil)
    }
    
    func initShowVC(sin: Show_IN) {
        self.show_in = sin
    }
    
    func reloadData() {
        let title: String = show["title"] as? String ?? ""
        titleLbl.text = title
        if let image: UIImage = show["featured"] as? UIImage {
            let width: CGFloat = image.size.width
            let height: CGFloat = image.size.height
            //print("width: \(width), height: \(height)")
            let ratio: CGFloat = width / height
            let newHeight = featured.frame.width / ratio
            featuredHeight.constant = newHeight
            featured.image = image
        }
        let content: String = show["content"] as? String ?? ""
        
        label.text = content
        //webView.loadHTMLString(content, baseURL: nil)
    }
    
    
}
