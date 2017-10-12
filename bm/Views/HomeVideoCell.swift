//
//  HomeVideoCell.swift
//  bm
//
//  Created by ives on 2017/10/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import WebKit
import TRVideoView

class HomeVideoCell: UICollectionViewCell {
    
    var webView: WKWebView?
    var webView_frame: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func updateViews(home: Home) {
        print("update web view")
        
        //print(frame)
        //let embedHTML="<iframe src='https://player.vimeo.com/video/\(home.vimeo)' width='640' height='360' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
        var link: String?
        if home.vimeo.count > 0 {
            link = "https://player.vimeo.com/video/\(home.vimeo)"
        } else {
            link = "https://www.youtube.com/embed/\(home.youtube)?rel=0"
        }
        //print(link)
        
        //let html = "<head> <meta name=viewport content='width=device-width, initial-scale=1'><style type='text/css'> body { margin: 0;} </style></head><iframe src='\(link!)' width='\(webView_frame!.width)' height='\(webView_frame!.height)' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
        //print(html)
        //webView = WKWebView(frame: webView_frame!)
        //print(webView)
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.webView!.loadHTMLString("html", baseURL: nil)
//        })
        //self.addSubview(webView!)
        caculateFrame()
        //print(self.bounds)
        //print(webView_frame!)
        let video = TRVideoView(frame: webView_frame!, text: link!)
        self.addSubview(video)
        

        //let url: URL = URL(string: "https://gcs-vimeo.akamaized.net/exp=1507823516~acl=%2A%2F836889642.mp4%2A~hmac=8e188cb2c7eb66d647f450148a11c2d243b1b588f38aaa156a1f95177ae48b74/vimeo-prod-skyfire-std-us/01/2068/9/235344541/836889642.mp4")!
    }
    
    func caculateFrame() {
        let bounds_width = self.bounds.width
        let bounds_height = self.bounds.height
        let ratio: CGFloat = bounds_height / bounds_width
        let width: CGFloat, height: CGFloat, x: CGFloat, y:CGFloat
        if ratio < 0.75 {
            height = bounds_height - 10
            width = height * 1.33
            y = 5.0
            x = (bounds_width - width) / 2
        } else {
            width = bounds_width - 10
            height = width * 0.75
            x = 5.0
            y = (bounds_height - height) / 2
        }
        self.webView_frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
